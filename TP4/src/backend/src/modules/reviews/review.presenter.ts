import type { Review, TravelerProfile, User } from '@prisma/client';

type ReviewWithTraveler = Review & {
  traveler: TravelerProfile & {
    user: User;
  };
};

type ReviewSummary = {
  average: number;
  total: number;
  distribution: Record<1 | 2 | 3 | 4 | 5, number>;
};

export function presentReview(review: ReviewWithTraveler) {
  return {
    id: review.id,
    rating: review.rating,
    comment: review.comment,
    helpfulCount: review.helpfulCount,
    createdAt: review.createdAt,
    updatedAt: review.updatedAt,
    traveler: {
      id: review.traveler.id,
      name: review.traveler.user.fullName,
      avatar: avatarFor(review.traveler.user.fullName),
    },
  };
}

export function presentReviewSummary(summary: ReviewSummary) {
  return summary;
}

function avatarFor(name: string) {
  return name.trim().charAt(0).toLocaleUpperCase('pt-BR') || 'V';
}
