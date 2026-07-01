import { AccommodationType } from '@prisma/client';
import { z } from 'zod';

export const paymentMethodSchema = z.enum(['PIX', 'CREDIT_CARD', 'BOLETO']);

export const createBookingSchema = z.object({
  tripId: z.string().uuid('Viagem invalida.'),
  originStopId: z.string().uuid('Ponto de embarque invalido.'),
  destinationStopId: z.string().uuid('Ponto de desembarque invalido.'),
  passengerName: z.string().trim().min(3, 'Nome do passageiro obrigatorio.'),
  passengerCpf: z
    .string()
    .transform((value) => value.replace(/\D/g, ''))
    .refine((value) => value.length === 11, 'CPF do passageiro invalido.'),
  accommodationType: z.nativeEnum(AccommodationType),
  paymentMethod: paymentMethodSchema,
});

export type CreateBookingInput = z.infer<typeof createBookingSchema>;
export type PaymentMethodInput = z.infer<typeof paymentMethodSchema>;
