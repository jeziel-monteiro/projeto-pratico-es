import { Prisma } from '@prisma/client';

import { prisma } from '../../database/prisma.js';
import { HttpError } from '../../http/http-error.js';
import type { AuthenticatedUser } from '../auth/auth.middleware.js';
import type { UpsertReviewInput } from './review.schemas.js';

const reviewInclude = {
  traveler: {
    include: {
      user: true,
    },
  },
} satisfies Prisma.ReviewInclude;

export async function listTripReviews(tripId: string) {
  const vesselId = await vesselIdForTrip(tripId);
  const [reviews, summary] = await Promise.all([
    prisma.review.findMany({
      where: { vesselId },
      include: reviewInclude,
      orderBy: [{ createdAt: 'desc' }],
    }),
    reviewSummary(vesselId),
  ]);

  return { reviews, summary };
}

export async function upsertTripReview(
  tripId: string,
  auth: AuthenticatedUser,
  input: UpsertReviewInput,
) {
  const [vesselId, traveler] = await Promise.all([
    vesselIdForTrip(tripId),
    prisma.travelerProfile.findFirst({
      where: {
        user: { firebaseUid: auth.uid },
      },
      include: {
        user: true,
      },
    }),
  ]);

  if (!traveler) {
    throw new HttpError(404, 'Perfil de viajante nao encontrado.');
  }

  const review = await prisma.review.upsert({
    where: {
      vesselId_travelerId: {
        vesselId,
        travelerId: traveler.id,
      },
    },
    update: {
      rating: input.rating,
      comment: input.comment,
    },
    create: {
      vesselId,
      travelerId: traveler.id,
      rating: input.rating,
      comment: input.comment,
    },
    include: reviewInclude,
  });

  await refreshVesselRating(vesselId);

  return {
    review,
    summary: await reviewSummary(vesselId),
  };
}

async function vesselIdForTrip(tripId: string) {
  const trip = await prisma.trip.findUnique({
    where: { id: tripId },
    select: { vesselId: true },
  });

  if (!trip) {
    throw new HttpError(404, 'Viagem nao encontrada.');
  }

  return trip.vesselId;
}

async function reviewSummary(vesselId: string) {
  const [average, grouped] = await Promise.all([
    prisma.review.aggregate({
      where: { vesselId },
      _avg: { rating: true },
      _count: { rating: true },
    }),
    prisma.review.groupBy({
      by: ['rating'],
      where: { vesselId },
      _count: { rating: true },
    }),
  ]);

  const distribution = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
  } as Record<1 | 2 | 3 | 4 | 5, number>;

  for (const item of grouped) {
    if (item.rating >= 1 && item.rating <= 5) {
      distribution[item.rating as 1 | 2 | 3 | 4 | 5] = item._count.rating;
    }
  }

  return {
    average: Number((average._avg.rating ?? 0).toFixed(1)),
    total: average._count.rating,
    distribution,
  };
}

async function refreshVesselRating(vesselId: string) {
  const summary = await reviewSummary(vesselId);
  if (summary.total === 0) return;

  await prisma.vessel.update({
    where: { id: vesselId },
    data: { rating: summary.average.toFixed(1) },
  });
}
