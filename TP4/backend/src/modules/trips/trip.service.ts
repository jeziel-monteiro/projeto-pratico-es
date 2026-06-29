import { Prisma, TripStatus } from '@prisma/client';

import { prisma } from '../../database/prisma.js';
import { HttpError } from '../../http/http-error.js';
import type { TripSearchInput } from './trip.schemas.js';

const tripInclude = {
  originPort: true,
  destinyPort: true,
  stops: {
    include: {
      port: true,
    },
    orderBy: { stopOrder: 'asc' },
  },
  vessel: {
    include: {
      photos: {
        orderBy: { createdAt: 'asc' },
      },
    },
  },
  position: true,
} satisfies Prisma.TripInclude;

type TripStopSearchItem = {
  stopOrder: number;
  port: {
    name: string;
    city: string;
    state: string;
  };
};

type TrackingStop = {
  id: string;
  stopOrder: number;
  priceMultiplier: Prisma.Decimal;
  arrivalEstimateAt: Date | null;
  port: {
    id: string;
    name: string;
    city: string;
    state: string;
    latitude: Prisma.Decimal | null;
    longitude: Prisma.Decimal | null;
  };
};

export async function searchTrips(input: TripSearchInput) {
  const segmentFilters: Prisma.TripWhereInput[] = [];

  if (input.origin) {
    segmentFilters.push({
      stops: {
        some: {
          port: portSearchFilter(input.origin),
        },
      },
    });
  }

  if (input.destination) {
    segmentFilters.push({
      stops: {
        some: {
          port: portSearchFilter(input.destination),
        },
      },
    });
  }

  const where: Prisma.TripWhereInput = {
    status: TripStatus.SCHEDULED,
    departureAt: dateRange(input.date),
    AND: segmentFilters.length > 0 ? segmentFilters : undefined,
  };

  const trips = await prisma.trip.findMany({
    where,
    include: tripInclude,
    orderBy: [{ departureAt: 'asc' }, { basePrice: 'asc' }],
    take: 30,
  });

  return trips.filter((trip) => hasValidSegment(trip.stops, input));
}

export async function getTrip(id: string) {
  const trip = await prisma.trip.findUnique({
    where: { id },
    include: tripInclude,
  });

  if (!trip) {
    throw new HttpError(404, 'Viagem nao encontrada.');
  }

  return trip;
}

export async function listRelatedTrips(id: string) {
  const trip = await prisma.trip.findUnique({
    where: { id },
    select: { vesselId: true },
  });

  if (!trip) {
    throw new HttpError(404, 'Viagem nao encontrada.');
  }

  return prisma.trip.findMany({
    where: {
      vesselId: trip.vesselId,
      status: TripStatus.SCHEDULED,
      departureAt: { gte: new Date() },
    },
    include: tripInclude,
    orderBy: [{ departureAt: 'asc' }, { basePrice: 'asc' }],
    take: 10,
  });
}

export async function getTripTracking(id: string) {
  const trip = await prisma.trip.findUnique({
    where: { id },
    include: tripInclude,
  });

  if (!trip) {
    throw new HttpError(404, 'Viagem nao encontrada.');
  }

  const routePoints = trip.stops
    .filter((stop) => stop.port.latitude && stop.port.longitude)
    .sort((first, second) => first.stopOrder - second.stopOrder)
    .map((stop) => ({
      stop,
      latitude: Number(stop.port.latitude),
      longitude: Number(stop.port.longitude),
      multiplier: Number(stop.priceMultiplier),
    }));

  const originPoint = routePoints[0];
  const currentPosition = trip.position
    ? {
        latitude: Number(trip.position.latitude),
        longitude: Number(trip.position.longitude),
        updatedAt: trip.position.updatedAt,
      }
    : originPoint
      ? {
          latitude: originPoint.latitude,
          longitude: originPoint.longitude,
          updatedAt: trip.departureAt,
        }
      : null;

  const progress = currentPosition
    ? projectedProgress(routePoints, currentPosition)
    : 0;
  const progressPercentage = Math.round(progress * 100);
  const previousStop = stopAtOrBefore(routePoints, progress);
  const nextStop = stopAfter(routePoints, progress);
  const durationMinutes = trip.arrivalEstimateAt
    ? Math.max(
        0,
        Math.round(
          (trip.arrivalEstimateAt.getTime() - trip.departureAt.getTime()) /
            60000,
        ),
      )
    : null;
  const remainingMinutes = durationMinutes
    ? Math.max(0, Math.round(durationMinutes * (1 - progress)))
    : null;

  return {
    id: trip.id,
    status: trip.status,
    vessel: {
      id: trip.vessel.id,
      name: trip.vessel.name,
      registration: trip.vessel.officialRegistry,
      averageSpeed: trip.vessel.averageSpeed
        ? Number(trip.vessel.averageSpeed)
        : null,
    },
    route: {
      origin: presentTrackingPort(trip.originPort),
      destination: presentTrackingPort(trip.destinyPort),
    },
    stops: trip.stops
      .sort((first, second) => first.stopOrder - second.stopOrder)
      .map((stop) => presentTrackingStop(stop, trip.departureAt)),
    currentPosition,
    previousStop: previousStop
      ? presentTrackingStop(previousStop.stop, trip.departureAt)
      : null,
    nextStop: nextStop
      ? presentTrackingStop(nextStop.stop, trip.departureAt)
      : null,
    progressPercentage,
    remainingMinutes,
    updatedAt: currentPosition?.updatedAt ?? null,
  };
}

function dateRange(date?: string) {
  if (!date) {
    return {
      gte: new Date(),
    };
  }

  const [year, month, day] = date.includes('-')
    ? date.split('-').map(Number)
    : date.split('/').reverse().map(Number);

  if (!year || !month || !day) {
    throw new HttpError(400, 'Data invalida. Use YYYY-MM-DD ou DD/MM/AAAA.');
  }

  const start = new Date(Date.UTC(year, month - 1, day, 0, 0, 0));
  const end = new Date(Date.UTC(year, month - 1, day + 1, 0, 0, 0));

  return { gte: start, lt: end };
}

function portSearchFilter(value: string): Prisma.PortWhereInput {
  return {
    OR: [
      { city: { contains: value, mode: 'insensitive' } },
      { name: { contains: value, mode: 'insensitive' } },
      { state: { contains: value, mode: 'insensitive' } },
    ],
  };
}

function hasValidSegment(
  stops: TripStopSearchItem[],
  input: TripSearchInput,
) {
  const originStop = input.origin ? findStop(stops, input.origin) : null;
  const destinationStop = input.destination
    ? findStop(stops, input.destination)
    : null;

  if (input.origin && !originStop) return false;
  if (input.destination && !destinationStop) return false;

  if (originStop && destinationStop) {
    return originStop.stopOrder < destinationStop.stopOrder;
  }

  return true;
}

function findStop(stops: TripStopSearchItem[], value: string) {
  const search = normalizeSearch(value);

  return stops.find((stop) => {
    const label = normalizeSearch(
      `${stop.port.city} ${stop.port.name} ${stop.port.state}`,
    );

    return label.includes(search);
  });
}

function normalizeSearch(value: string) {
  return value
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .toLocaleLowerCase('pt-BR')
    .trim();
}

function projectedProgress(
  routePoints: Array<{
    stop: TrackingStop;
    latitude: number;
    longitude: number;
    multiplier: number;
  }>,
  point: { latitude: number; longitude: number },
) {
  if (routePoints.length < 2) return 0;

  let bestDistance = Number.POSITIVE_INFINITY;
  let bestProgress = 0;

  for (let index = 0; index < routePoints.length - 1; index += 1) {
    const start = routePoints[index];
    const end = routePoints[index + 1];
    const projection = projectPointOnSegment(point, start, end);
    const distance = squaredDistance(point, projection);
    const progress =
      start.multiplier + (end.multiplier - start.multiplier) * projection.t;

    if (distance < bestDistance) {
      bestDistance = distance;
      bestProgress = progress;
    }
  }

  return Math.max(0, Math.min(1, bestProgress));
}

function projectPointOnSegment(
  point: { latitude: number; longitude: number },
  start: { latitude: number; longitude: number },
  end: { latitude: number; longitude: number },
) {
  const vectorX = end.longitude - start.longitude;
  const vectorY = end.latitude - start.latitude;
  const lengthSquared = vectorX * vectorX + vectorY * vectorY;

  if (lengthSquared === 0) {
    return { latitude: start.latitude, longitude: start.longitude, t: 0 };
  }

  const t = Math.max(
    0,
    Math.min(
      1,
      ((point.longitude - start.longitude) * vectorX +
        (point.latitude - start.latitude) * vectorY) /
        lengthSquared,
    ),
  );

  return {
    latitude: start.latitude + vectorY * t,
    longitude: start.longitude + vectorX * t,
    t,
  };
}

function squaredDistance(
  first: { latitude: number; longitude: number },
  second: { latitude: number; longitude: number },
) {
  const latitude = first.latitude - second.latitude;
  const longitude = first.longitude - second.longitude;
  return latitude * latitude + longitude * longitude;
}

function stopAtOrBefore(
  routePoints: Array<{ stop: TrackingStop; multiplier: number }>,
  progress: number,
) {
  return [...routePoints]
    .reverse()
    .find((point) => point.multiplier <= progress);
}

function stopAfter(
  routePoints: Array<{ stop: TrackingStop; multiplier: number }>,
  progress: number,
) {
  return routePoints.find((point) => point.multiplier > progress);
}

function presentTrackingStop(stop: TrackingStop, departureAt: Date) {
  return {
    id: stop.id,
    order: stop.stopOrder,
    port: presentTrackingPort(stop.port),
    arrivalEstimateAt: stop.arrivalEstimateAt,
    etaMinutesFromStart: stop.arrivalEstimateAt
      ? Math.max(
          0,
          Math.round(
            (stop.arrivalEstimateAt.getTime() - departureAt.getTime()) / 60000,
          ),
        )
      : 0,
    priceMultiplier: Number(stop.priceMultiplier),
  };
}

function presentTrackingPort(port: {
  id: string;
  name: string;
  city: string;
  state: string;
  latitude: Prisma.Decimal | null;
  longitude: Prisma.Decimal | null;
}) {
  return {
    id: port.id,
    name: port.name,
    city: port.city,
    state: port.state,
    latitude: port.latitude ? Number(port.latitude) : null,
    longitude: port.longitude ? Number(port.longitude) : null,
  };
}
