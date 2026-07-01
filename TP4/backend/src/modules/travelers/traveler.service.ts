import { UserRole } from '@prisma/client';

import { prisma } from '../../database/prisma.js';
import { HttpError } from '../../http/http-error.js';
import type { AuthenticatedUser } from '../auth/auth.middleware.js';
import type {
  TravelerPreferencesInput,
  UpsertTravelerInput,
} from './traveler.schemas.js';

export async function upsertTravelerProfile(
  auth: AuthenticatedUser,
  input: UpsertTravelerInput,
) {
  return prisma.$transaction(async (transaction) => {
    const user = await transaction.user.upsert({
      where: { firebaseUid: auth.uid },
      update: {
        email: input.email,
        phone: input.phone,
        fullName: input.fullName,
        cpf: input.cpf,
        birthDate: input.birthDate,
        role: UserRole.TRAVELER,
      },
      create: {
        firebaseUid: auth.uid,
        email: input.email,
        phone: input.phone,
        fullName: input.fullName,
        cpf: input.cpf,
        birthDate: input.birthDate,
        role: UserRole.TRAVELER,
      },
    });

    await transaction.travelerProfile.upsert({
      where: { userId: user.id },
      update: {
        highContrast: input.highContrast,
      },
      create: {
        userId: user.id,
        highContrast: input.highContrast,
      },
    });

    return transaction.user.findUniqueOrThrow({
      where: { id: user.id },
      include: { travelerProfile: true },
    });
  });
}

export async function getTravelerProfile(auth: AuthenticatedUser) {
  const user = await prisma.user.findUnique({
    where: { firebaseUid: auth.uid },
    include: { travelerProfile: true },
  });

  if (!user || !user.travelerProfile) {
    throw new HttpError(404, 'Perfil de viajante nao encontrado.');
  }

  return user;
}

export async function updateTravelerPreferences(
  auth: AuthenticatedUser,
  input: TravelerPreferencesInput,
) {
  const user = await prisma.user.findUnique({
    where: { firebaseUid: auth.uid },
    include: { travelerProfile: true },
  });

  if (!user || !user.travelerProfile) {
    throw new HttpError(404, 'Perfil de viajante nao encontrado.');
  }

  await prisma.travelerProfile.update({
    where: { id: user.travelerProfile.id },
    data: {
      highContrast: input.highContrast,
    },
  });

  return prisma.user.findUniqueOrThrow({
    where: { id: user.id },
    include: { travelerProfile: true },
  });
}
