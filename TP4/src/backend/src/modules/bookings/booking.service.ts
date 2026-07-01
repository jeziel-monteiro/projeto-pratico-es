import { randomUUID } from 'node:crypto';

import {
  AccommodationType,
  BookingStatus,
  PaymentStatus,
  Prisma,
  TicketStatus,
  TripStatus,
} from '@prisma/client';

import { prisma } from '../../database/prisma.js';
import { HttpError } from '../../http/http-error.js';
import type { AuthenticatedUser } from '../auth/auth.middleware.js';
import { sendBookingConfirmationEmail } from '../notifications/booking-confirmation.service.js';
import type { CreateBookingInput, PaymentMethodInput } from './booking.schemas.js';

const SERVICE_FEE = 5;

const accommodationPrices: Record<AccommodationType, number> = {
  HAMMOCK: 0,
  SEAT: 40,
  CABIN: 120,
};

const bookingInclude = {
  traveler: {
    include: {
      user: true,
    },
  },
  originStop: {
    include: {
      port: true,
    },
  },
  destinationStop: {
    include: {
      port: true,
    },
  },
  trip: {
    include: {
      originPort: true,
      destinyPort: true,
      vessel: true,
    },
  },
  tickets: {
    orderBy: { createdAt: 'asc' },
  },
  payment: true,
} satisfies Prisma.BookingInclude;

export async function createBooking(
  auth: AuthenticatedUser,
  input: CreateBookingInput,
) {
  const booking = await prisma.$transaction(async (transaction) => {
    const traveler = await transaction.user.findUnique({
      where: { firebaseUid: auth.uid },
      include: { travelerProfile: true },
    });

    if (!traveler?.travelerProfile) {
      throw new HttpError(404, 'Perfil de viajante nao encontrado.');
    }

    const trip = await transaction.trip.findUnique({
      where: { id: input.tripId },
      include: {
        stops: true,
      },
    });

    if (!trip || trip.status !== TripStatus.SCHEDULED) {
      throw new HttpError(404, 'Viagem disponivel nao encontrada.');
    }

    const originStop = trip.stops.find(
      (stop) => stop.id === input.originStopId,
    );
    const destinationStop = trip.stops.find(
      (stop) => stop.id === input.destinationStopId,
    );

    if (!originStop || !destinationStop) {
      throw new HttpError(
        400,
        'Pontos de embarque e desembarque devem pertencer a viagem.',
      );
    }

    if (originStop.stopOrder >= destinationStop.stopOrder) {
      throw new HttpError(
        400,
        'O desembarque deve acontecer depois do embarque.',
      );
    }

    const seatUpdate = await transaction.trip.updateMany({
      where: {
        id: trip.id,
        status: TripStatus.SCHEDULED,
        seatsAvailable: { gt: 0 },
      },
      data: {
        seatsAvailable: { decrement: 1 },
      },
    });

    if (seatUpdate.count !== 1) {
      throw new HttpError(409, 'Nao ha vagas disponiveis para esta viagem.');
    }

    const totalAmount = calculateTotalAmount({
      basePrice: Number(trip.basePrice),
      originMultiplier: Number(originStop.priceMultiplier),
      destinationMultiplier: Number(destinationStop.priceMultiplier),
      accommodationType: input.accommodationType,
      paymentMethod: input.paymentMethod,
    });

    return transaction.booking.create({
      data: {
        travelerId: traveler.travelerProfile.id,
        tripId: trip.id,
        originStopId: originStop.id,
        destinationStopId: destinationStop.id,
        passengerName: input.passengerName,
        passengerCpf: input.passengerCpf,
        accommodationType: input.accommodationType,
        status: BookingStatus.CONFIRMED,
        totalAmount,
        tickets: {
          create: {
            code: createTicketCode(),
            status: TicketStatus.ISSUED,
          },
        },
        payment: {
          create: {
            method: input.paymentMethod,
            amount: totalAmount,
            status: PaymentStatus.APPROVED,
          },
        },
      },
      include: bookingInclude,
    });
  });

  sendBookingConfirmationEmail(booking).catch((error: unknown) => {
    console.error(
      `[email] falha ao enviar confirmacao da reserva ${booking.id}.`,
      error,
    );
  });

  return booking;
}

export async function listMyBookings(auth: AuthenticatedUser) {
  const traveler = await prisma.user.findUnique({
    where: { firebaseUid: auth.uid },
    include: { travelerProfile: true },
  });

  if (!traveler?.travelerProfile) {
    throw new HttpError(404, 'Perfil de viajante nao encontrado.');
  }

  return prisma.booking.findMany({
    where: {
      travelerId: traveler.travelerProfile.id,
    },
    include: bookingInclude,
    orderBy: { createdAt: 'desc' },
  });
}

export async function getMyBooking(auth: AuthenticatedUser, bookingId: string) {
  const booking = await prisma.booking.findFirst({
    where: {
      id: bookingId,
      traveler: {
        user: {
          firebaseUid: auth.uid,
        },
      },
    },
    include: bookingInclude,
  });

  if (!booking) {
    throw new HttpError(404, 'Reserva nao encontrada.');
  }

  return booking;
}

export async function cancelBooking(auth: AuthenticatedUser, bookingId: string) {
  return prisma.$transaction(async (transaction) => {
    const booking = await transaction.booking.findFirst({
      where: {
        id: bookingId,
        traveler: {
          user: {
            firebaseUid: auth.uid,
          },
        },
      },
      include: {
        trip: true,
      },
    });

    if (!booking) {
      throw new HttpError(404, 'Reserva nao encontrada.');
    }

    if (booking.status === BookingStatus.CANCELLED) {
      throw new HttpError(409, 'Esta reserva ja foi cancelada.');
    }

    if (booking.status !== BookingStatus.CONFIRMED) {
      throw new HttpError(409, 'Apenas reservas confirmadas podem ser canceladas.');
    }

    const updated = await transaction.booking.updateMany({
      where: {
        id: booking.id,
        status: BookingStatus.CONFIRMED,
      },
      data: {
        status: BookingStatus.CANCELLED,
      },
    });

    if (updated.count !== 1) {
      throw new HttpError(409, 'Nao foi possivel cancelar esta reserva.');
    }

    await transaction.trip.update({
      where: { id: booking.tripId },
      data: {
        seatsAvailable: Math.min(
          booking.trip.seatsAvailable + 1,
          booking.trip.seatsTotal,
        ),
      },
    });

    await transaction.ticket.updateMany({
      where: { bookingId: booking.id },
      data: { status: TicketStatus.CANCELLED },
    });

    await transaction.payment.updateMany({
      where: { bookingId: booking.id },
      data: { status: PaymentStatus.REFUNDED },
    });

    return transaction.booking.findUniqueOrThrow({
      where: { id: booking.id },
      include: bookingInclude,
    });
  });
}

function calculateTotalAmount(input: {
  basePrice: number;
  originMultiplier: number;
  destinationMultiplier: number;
  accommodationType: AccommodationType;
  paymentMethod: PaymentMethodInput;
}) {
  const originBasisPoints = Math.round(input.originMultiplier * 10000);
  const destinationBasisPoints = Math.round(input.destinationMultiplier * 10000);
  const segmentBasisPoints = Math.max(
    0,
    destinationBasisPoints - originBasisPoints,
  );
  const segmentFare = Math.max(
    Math.round((input.basePrice * segmentBasisPoints) / 10000),
    Math.round(input.basePrice * 0.1),
  );
  const subtotal =
    segmentFare + accommodationPrices[input.accommodationType] + SERVICE_FEE;

  if (input.paymentMethod === 'CREDIT_CARD') {
    return Math.round(subtotal * 1.02);
  }

  return subtotal;
}

function createTicketCode() {
  const suffix = randomUUID().replace(/-/g, '').slice(0, 10).toUpperCase();
  return `PC-${new Date().getFullYear()}-${suffix}`;
}
