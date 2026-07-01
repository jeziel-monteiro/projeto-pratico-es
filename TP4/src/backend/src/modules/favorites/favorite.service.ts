import { Prisma } from '@prisma/client';

import { prisma } from '../../database/prisma.js';
import { HttpError } from '../../http/http-error.js';
import type { AuthenticatedUser } from '../auth/auth.middleware.js';

const favoriteTripInclude = {
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

export async function listFavoriteTrips(auth: AuthenticatedUser) {
  const traveler = await findTraveler(auth);

  const favorites = await prisma.favorite.findMany({
    where: {
      travelerId: traveler.id,
    },
    include: {
      trip: {
        include: favoriteTripInclude,
      },
    },
    orderBy: { createdAt: 'desc' },
  });

  return favorites.map((favorite) => favorite.trip);
}

export async function addFavoriteTrip(
  auth: AuthenticatedUser,
  tripId: string,
) {
  const traveler = await findTraveler(auth);
  const trip = await prisma.trip.findUnique({
    where: { id: tripId },
    include: favoriteTripInclude,
  });

  if (!trip) {
    throw new HttpError(404, 'Viagem nao encontrada.');
  }

  await prisma.favorite.upsert({
    where: {
      travelerId_tripId: {
        travelerId: traveler.id,
        tripId,
      },
    },
    update: {},
    create: {
      travelerId: traveler.id,
      tripId,
    },
  });

  return trip;
}

export async function removeFavoriteTrip(
  auth: AuthenticatedUser,
  tripId: string,
) {
  const traveler = await findTraveler(auth);

  await prisma.favorite.deleteMany({
    where: {
      travelerId: traveler.id,
      tripId,
    },
  });

  return { tripId };
}

async function findTraveler(auth: AuthenticatedUser) {
  const user = await prisma.user.findUnique({
    where: { firebaseUid: auth.uid },
    include: { travelerProfile: true },
  });

  if (!user?.travelerProfile) {
    throw new HttpError(404, 'Perfil de viajante nao encontrado.');
  }

  return user.travelerProfile;
}
