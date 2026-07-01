import { z } from 'zod';

import {
  isAtLeastMinimumTravelerAge,
  parseTravelerBirthDate,
} from './traveler.validation.js';

const optionalDigits = z
  .string()
  .optional()
  .transform((value) => value?.replace(/\D/g, ''))
  .refine((value) => !value || (value.length >= 10 && value.length <= 11), {
    message: 'Telefone invalido.',
  });

const fullNameSchema = z
  .string()
  .trim()
  .min(3, 'Nome completo obrigatorio.')
  .regex(/^[A-Za-zÀ-ÖØ-öø-ÿ\s'.-]+$/, {
    message: 'Nome completo invalido.',
  })
  .refine((value) => value.split(/\s+/).length >= 2, {
    message: 'Informe nome e sobrenome.',
  });

const emailSchema = z
  .string()
  .trim()
  .regex(/^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$/, {
    message: 'Email invalido.',
  });

const birthDateSchema = z.string().trim().transform((value, context) => {
  const birthDate = parseTravelerBirthDate(value);

  if (!birthDate) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'Data de nascimento invalida. Use YYYY-MM-DD.',
    });
    return z.NEVER;
  }

  if (!isAtLeastMinimumTravelerAge(birthDate)) {
    context.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'Restricao de idade: o viajante deve ter 18 anos ou mais.',
    });
    return z.NEVER;
  }

  return birthDate;
});

export const upsertTravelerSchema = z.object({
  fullName: fullNameSchema,
  cpf: z
    .string()
    .transform((value) => value.replace(/\D/g, ''))
    .refine((value) => value.length === 11, 'CPF invalido.'),
  birthDate: birthDateSchema,
  phone: optionalDigits,
  email: emailSchema,
  highContrast: z.boolean().optional().default(false),
});

export const travelerPreferencesSchema = z.object({
  highContrast: z.boolean(),
});

export type UpsertTravelerInput = z.infer<typeof upsertTravelerSchema>;
export type TravelerPreferencesInput = z.infer<
  typeof travelerPreferencesSchema
>;
