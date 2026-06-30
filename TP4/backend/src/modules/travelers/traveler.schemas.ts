import { z } from 'zod';

const optionalDigits = z
  .string()
  .optional()
  .transform((value) => value?.replace(/\D/g, ''))
  .refine((value) => !value || value.length >= 10, {
    message: 'Telefone invalido.',
  });

export const upsertTravelerSchema = z.object({
  fullName: z.string().trim().min(3, 'Nome completo obrigatorio.'),
  cpf: z
    .string()
    .transform((value) => value.replace(/\D/g, ''))
    .refine((value) => value.length === 11, 'CPF invalido.'),
  phone: optionalDigits,
  email: z.string().email('Email invalido.'),
  highContrast: z.boolean().optional().default(false),
});

export const travelerPreferencesSchema = z.object({
  highContrast: z.boolean(),
});

export type UpsertTravelerInput = z.infer<typeof upsertTravelerSchema>;
export type TravelerPreferencesInput = z.infer<
  typeof travelerPreferencesSchema
>;
