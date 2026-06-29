import { Router } from 'express';

import { asyncRoute } from '../../http/async-route.js';
import { authenticate } from '../auth/auth.middleware.js';
import { presentTraveler } from './traveler.presenter.js';
import {
  travelerPreferencesSchema,
  upsertTravelerSchema,
} from './traveler.schemas.js';
import {
  getTravelerProfile,
  updateTravelerPreferences,
  upsertTravelerProfile,
} from './traveler.service.js';

export const travelerRoutes = Router();

travelerRoutes.post(
  '/',
  authenticate,
  asyncRoute(async (request, response) => {
    const input = upsertTravelerSchema.parse(request.body);
    const traveler = await upsertTravelerProfile(request.auth!, input);

    return response.status(201).json({ data: presentTraveler(traveler) });
  }),
);

travelerRoutes.get(
  '/me',
  authenticate,
  asyncRoute(async (request, response) => {
    const traveler = await getTravelerProfile(request.auth!);

    return response.json({ data: presentTraveler(traveler) });
  }),
);

travelerRoutes.put(
  '/me',
  authenticate,
  asyncRoute(async (request, response) => {
    const input = upsertTravelerSchema.parse(request.body);
    const traveler = await upsertTravelerProfile(request.auth!, input);

    return response.json({ data: presentTraveler(traveler) });
  }),
);

travelerRoutes.patch(
  '/me/preferences',
  authenticate,
  asyncRoute(async (request, response) => {
    const input = travelerPreferencesSchema.parse(request.body);
    const traveler = await updateTravelerPreferences(request.auth!, input);

    return response.json({ data: presentTraveler(traveler) });
  }),
);
