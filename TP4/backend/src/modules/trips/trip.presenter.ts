import type {
  Port,
  Trip,
  TripPosition,
  TripStop,
  Vessel,
  VesselPhoto,
} from '@prisma/client';

type TripWithRelations = Trip & {
  originPort: Port;
  destinyPort: Port;
  vessel: Vessel & {
    photos: VesselPhoto[];
  };
  stops: (TripStop & {
    port: Port;
  })[];
  position: TripPosition | null;
};

export function presentTrip(trip: TripWithRelations) {
  return {
    id: trip.id,
    origin: presentPortSummary(trip.originPort),
    destination: presentPortSummary(trip.destinyPort),
    departureAt: trip.departureAt,
    arrivalEstimateAt: trip.arrivalEstimateAt,
    durationMinutes: trip.arrivalEstimateAt
      ? Math.max(
          0,
          Math.round(
            (trip.arrivalEstimateAt.getTime() - trip.departureAt.getTime()) /
              60000,
          ),
        )
      : null,
    basePrice: Number(trip.basePrice),
    seatsTotal: trip.seatsTotal,
    seatsAvailable: trip.seatsAvailable,
    status: trip.status,
    stops: trip.stops.map((stop) => ({
      id: stop.id,
      order: stop.stopOrder,
      port: presentPortSummary(stop.port),
      arrivalEstimateAt: stop.arrivalEstimateAt,
      departureEstimateAt: stop.departureEstimateAt,
      etaMinutesFromStart: stop.arrivalEstimateAt
        ? Math.max(
            0,
            Math.round(
              (stop.arrivalEstimateAt.getTime() - trip.departureAt.getTime()) /
                60000,
            ),
          )
        : 0,
      priceMultiplier: Number(stop.priceMultiplier),
    })),
    vessel: {
      id: trip.vessel.id,
      name: trip.vessel.name,
      registration: trip.vessel.officialRegistry,
      capacity: trip.vessel.passengerCapacity,
      averageSpeed: trip.vessel.averageSpeed
        ? Number(trip.vessel.averageSpeed)
        : null,
      rating: trip.vessel.rating ? Number(trip.vessel.rating) : null,
      amenities: trip.vessel.amenities,
      imageUrl: trip.vessel.photos[0]?.url ?? null,
      photos: trip.vessel.photos.map((photo) => ({
        id: photo.id,
        url: photo.url,
        altText: photo.altText,
      })),
    },
    currentPosition: trip.position
      ? {
          latitude: Number(trip.position.latitude),
          longitude: Number(trip.position.longitude),
          updatedAt: trip.position.updatedAt,
        }
      : null,
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
