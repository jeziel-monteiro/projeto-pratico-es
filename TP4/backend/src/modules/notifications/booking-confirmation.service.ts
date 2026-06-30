import type {
  Booking,
  Payment,
  Port,
  Ticket,
  TravelerProfile,
  Trip,
  TripStop,
  User,
  Vessel,
} from '@prisma/client';

import { sendEmail } from './providers/email.provider.js';
import { renderBookingConfirmedEmail } from './templates/booking-confirmed.template.js';

type StopWithPort = TripStop & {
  port: Port;
};

export type BookingConfirmationPayload = Booking & {
  traveler: TravelerProfile & {
    user: User;
  };
  originStop: StopWithPort | null;
  destinationStop: StopWithPort | null;
  trip: Trip & {
    originPort: Port;
    destinyPort: Port;
    vessel: Vessel;
  };
  tickets: Ticket[];
  payment: Payment | null;
};

export async function sendBookingConfirmationEmail(
  booking: BookingConfirmationPayload,
) {
  const to = booking.traveler.user.email;

  if (!to) {
    console.info(
      `[email] reserva ${booking.id} sem email do viajante; confirmacao nao enviada.`,
    );
    return;
  }

  const ticket = booking.tickets[0];

  if (!ticket) {
    console.info(
      `[email] reserva ${booking.id} sem bilhete emitido; confirmacao nao enviada.`,
    );
    return;
  }

  const message = renderBookingConfirmedEmail({
    passengerName: booking.passengerName,
    ticketCode: ticket.code,
    bookingId: booking.id,
    route: buildRouteLabel(booking),
    vesselName: booking.trip.vessel.name,
    departureAt: booking.trip.departureAt,
    accommodationLabel: accommodationLabel(booking.accommodationType),
    paymentMethodLabel: paymentMethodLabel(booking.payment?.method),
    totalAmount: Number(booking.totalAmount),
  });

  await sendEmail({
    to,
    subject: message.subject,
    text: message.text,
    html: message.html,
    idempotencyKey: booking.id,
  });
}

function buildRouteLabel(booking: BookingConfirmationPayload) {
  const origin = booking.originStop?.port ?? booking.trip.originPort;
  const destination = booking.destinationStop?.port ?? booking.trip.destinyPort;

  return `${formatPort(origin)} -> ${formatPort(destination)}`;
}

function formatPort(port: Port) {
  return `${port.city}/${port.state}`;
}

function accommodationLabel(value: string) {
  return (
    {
      HAMMOCK: 'Rede',
      SEAT: 'Poltrona',
      CABIN: 'Camarote',
    }[value] ?? value
  );
}

function paymentMethodLabel(value?: string) {
  if (!value) return 'Nao informado';

  return (
    {
      PIX: 'PIX',
      CREDIT_CARD: 'Cartao de credito',
      BOLETO: 'Boleto bancario',
    }[value] ?? value
  );
}
