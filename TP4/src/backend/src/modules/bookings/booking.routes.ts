import { Router } from 'express';

import { asyncRoute } from '../../http/async-route.js';
import { HttpError } from '../../http/http-error.js';
import { authenticate } from '../auth/auth.middleware.js';
import { createBookingSchema } from './booking.schemas.js';
import { presentBooking } from './booking.presenter.js';
import {
  cancelBooking,
  createBooking,
  getMyBooking,
  listMyBookings,
} from './booking.service.js';

export const bookingRoutes = Router();

bookingRoutes.post(
  '/',
  authenticate,
  asyncRoute(async (request, response) => {
    const input = createBookingSchema.parse(request.body);
    const booking = await createBooking(request.auth!, input);

    return response.status(201).json({ data: presentBooking(booking) });
  }),
);

bookingRoutes.get(
  '/me',
  authenticate,
  asyncRoute(async (request, response) => {
    const bookings = await listMyBookings(request.auth!);

    return response.json({ data: bookings.map(presentBooking) });
  }),
);

bookingRoutes.get(
  '/:id',
  authenticate,
  asyncRoute(async (request, response) => {
    const id = Array.isArray(request.params.id)
      ? request.params.id[0]
      : request.params.id;
    if (!id) throw new HttpError(400, 'Identificador da reserva obrigatorio.');

    const booking = await getMyBooking(request.auth!, id);

    return response.json({ data: presentBooking(booking) });
  }),
);

bookingRoutes.post(
  '/:id/cancel',
  authenticate,
  asyncRoute(async (request, response) => {
    const id = Array.isArray(request.params.id)
      ? request.params.id[0]
      : request.params.id;
    if (!id) throw new HttpError(400, 'Identificador da reserva obrigatorio.');

    const booking = await cancelBooking(request.auth!, id);

    return response.json({ data: presentBooking(booking) });
  }),
);
