import { Router } from 'express';

import { bookingRoutes } from '../modules/bookings/booking.routes.js';
import { favoriteRoutes } from '../modules/favorites/favorite.routes.js';
import { healthRoutes } from './health.routes.js';
import { notificationRoutes } from '../modules/notifications/notification.routes.js';
import { portRoutes } from '../modules/ports/port.routes.js';
import { travelerRoutes } from '../modules/travelers/traveler.routes.js';
import { tripRoutes } from '../modules/trips/trip.routes.js';

export const routes = Router();

routes.use('/health', healthRoutes);
routes.use('/bookings', bookingRoutes);
routes.use('/favorites', favoriteRoutes);
routes.use('/notifications', notificationRoutes);
routes.use('/ports', portRoutes);
routes.use('/travelers', travelerRoutes);
routes.use('/trips', tripRoutes);
