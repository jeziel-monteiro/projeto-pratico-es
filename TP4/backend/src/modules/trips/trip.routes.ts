import { Router } from 'express';

import { asyncRoute } from '../../http/async-route.js';
import { HttpError } from '../../http/http-error.js';
import { presentTrip } from './trip.presenter.js';
import { tripSearchSchema } from './trip.schemas.js';
import {
  getTrip,
  getTripTracking,
  listRelatedTrips,
  searchTrips,
} from './trip.service.js';

export const tripRoutes = Router();

tripRoutes.get(
  '/search',
  asyncRoute(async (request, response) => {
    const input = tripSearchSchema.parse(request.query);
    const trips = await searchTrips(input);

    return response.json({ data: trips.map(presentTrip) });
  }),
);

tripRoutes.get(
  '/:id/related',
  asyncRoute(async (request, response) => {
    const id = Array.isArray(request.params.id)
      ? request.params.id[0]
      : request.params.id;
    if (!id) throw new HttpError(400, 'Identificador da viagem obrigatorio.');

    const trips = await listRelatedTrips(id);

    return response.json({ data: trips.map(presentTrip) });
  }),
);

tripRoutes.get(
  '/:id/tracking',
  asyncRoute(async (request, response) => {
    const id = Array.isArray(request.params.id)
      ? request.params.id[0]
      : request.params.id;
    if (!id) throw new HttpError(400, 'Identificador da viagem obrigatorio.');

    const tracking = await getTripTracking(id);

    return response.json({ data: tracking });
  }),
);

tripRoutes.get(
  '/:id',
  asyncRoute(async (request, response) => {
    const id = Array.isArray(request.params.id)
      ? request.params.id[0]
      : request.params.id;
    if (!id) throw new HttpError(400, 'Identificador da viagem obrigatorio.');

    const trip = await getTrip(id);

    return response.json({ data: presentTrip(trip) });
  }),
);
