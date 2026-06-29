import { Router } from 'express';

import { asyncRoute } from '../../http/async-route.js';
import { HttpError } from '../../http/http-error.js';
import { authenticate } from '../auth/auth.middleware.js';
import { presentTrip } from '../trips/trip.presenter.js';
import {
  addFavoriteTrip,
  listFavoriteTrips,
  removeFavoriteTrip,
} from './favorite.service.js';

export const favoriteRoutes = Router();

favoriteRoutes.get(
  '/me',
  authenticate,
  asyncRoute(async (request, response) => {
    const trips = await listFavoriteTrips(request.auth!);

    return response.json({ data: trips.map(presentTrip) });
  }),
);

favoriteRoutes.post(
  '/:tripId',
  authenticate,
  asyncRoute(async (request, response) => {
    const tripId = normalizeTripId(request.params.tripId);
    const trip = await addFavoriteTrip(request.auth!, tripId);

    return response.status(201).json({ data: presentTrip(trip) });
  }),
);

favoriteRoutes.delete(
  '/:tripId',
  authenticate,
  asyncRoute(async (request, response) => {
    const tripId = normalizeTripId(request.params.tripId);
    const result = await removeFavoriteTrip(request.auth!, tripId);

    return response.json({ data: result });
  }),
);

function normalizeTripId(value: string | string[] | undefined) {
  const tripId = Array.isArray(value) ? value[0] : value;
  if (!tripId) throw new HttpError(400, 'Identificador da viagem obrigatorio.');
  return tripId;
}
