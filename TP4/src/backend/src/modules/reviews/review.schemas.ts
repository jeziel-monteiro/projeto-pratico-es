import { z } from 'zod';

export const upsertReviewSchema = z.object({
  rating: z.coerce
    .number()
    .int('A nota deve ser um numero inteiro.')
    .min(1, 'A nota minima e 1.')
    .max(5, 'A nota maxima e 5.'),
  comment: z
    .string()
    .trim()
    .min(12, 'A avaliacao deve ter pelo menos 12 caracteres.')
    .max(500, 'A avaliacao deve ter no maximo 500 caracteres.'),
});

export type UpsertReviewInput = z.infer<typeof upsertReviewSchema>;
