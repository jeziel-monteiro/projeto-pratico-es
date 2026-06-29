import type { TravelerProfile, User } from '@prisma/client';

type TravelerWithUser = User & {
  travelerProfile: TravelerProfile | null;
};

export function presentTraveler(user: TravelerWithUser) {
  return {
    id: user.id,
    firebaseUid: user.firebaseUid,
    fullName: user.fullName,
    cpf: user.cpf,
    email: user.email,
    phone: user.phone,
    role: user.role,
    travelerProfile: user.travelerProfile
      ? {
          id: user.travelerProfile.id,
          highContrast: user.travelerProfile.highContrast,
        }
      : null,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
  };
}
