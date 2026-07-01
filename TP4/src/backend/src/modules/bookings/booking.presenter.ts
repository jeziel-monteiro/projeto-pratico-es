import type {
  Booking,
  Payment,
  Port,
  Ticket,
  Trip,
  TripStop,
  Vessel,
} from '@prisma/client';

type StopWithPort = TripStop & {
  port: Port;
};

type BookingWithRelations = Booking & {
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

export function presentBooking(booking: BookingWithRelations) {
  const ticket = booking.tickets[0] ?? null;

  return {
    id: booking.id,
    status: booking.status,
    passengerName: booking.passengerName,
    passengerCpf: booking.passengerCpf,
    accommodationType: booking.accommodationType,
    totalAmount: Number(booking.totalAmount),
    route: {
      tripId: booking.tripId,
      departureAt: booking.trip.departureAt,
      vessel: {
        id: booking.trip.vessel.id,
        name: booking.trip.vessel.name,
        registration: booking.trip.vessel.officialRegistry,
      },
      mainOrigin: presentPortSummary(booking.trip.originPort),
      mainDestination: presentPortSummary(booking.trip.destinyPort),
      originStop: booking.originStop
        ? presentStopSummary(booking.originStop)
        : null,
      destinationStop: booking.destinationStop
        ? presentStopSummary(booking.destinationStop)
        : null,
    },
    ticket: ticket
      ? {
          id: ticket.id,
          code: ticket.code,
          status: ticket.status,
        }
      : null,
    payment: booking.payment
      ? {
          id: booking.payment.id,
          method: booking.payment.method,
          status: booking.payment.status,
          amount: Number(booking.payment.amount),
        }
      : null,
    createdAt: booking.createdAt,
    updatedAt: booking.updatedAt,
  };
}

function presentStopSummary(stop: StopWithPort) {
  return {
    id: stop.id,
    order: stop.stopOrder,
    port: presentPortSummary(stop.port),
  };
}

function presentPortSummary(port: Port) {
  return {
    id: port.id,
    name: port.name,
    city: port.city,
    state: port.state,
  };
}
