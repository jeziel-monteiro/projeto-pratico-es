import { z } from 'zod';

export const tripSearchSchema = z.object({
  origin: z.string().trim().optional(),
  destination: z.string().trim().optional(),
  date: z.string().trim().optional(),
});

export type TripSearchInput = z.infer<typeof tripSearchSchema>;
