import { z } from 'zod';

import {
  isValidTripSearchPlace,
  parseTripSearchDate,
} from './trip.validation.js';

export const tripSearchSchema = z.object({
  origin: z.string().trim().optional(),
  destination: z.string().trim().optional(),
  date: z.string().trim().optional(),
}).superRefine((input, context) => {
  const hasManualSearch = Boolean(input.origin || input.destination || input.date);
  if (!hasManualSearch) return;

  if (!input.origin) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ['origin'],
      message: 'Origem obrigatoria.',
    });
  } else if (!isValidTripSearchPlace(input.origin)) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ['origin'],
      message: 'Origem invalida.',
    });
  }

  if (!input.destination) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ['destination'],
      message: 'Destino obrigatorio.',
    });
  } else if (!isValidTripSearchPlace(input.destination)) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ['destination'],
      message: 'Destino invalido.',
    });
  }

  if (!input.date) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ['date'],
      message: 'Data obrigatoria.',
    });
  } else if (!parseTripSearchDate(input.date)) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      path: ['date'],
      message: 'Data invalida.',
    });
  }
});

export type TripSearchInput = z.infer<typeof tripSearchSchema>;
