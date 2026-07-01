import { Router } from 'express';

import { asyncRoute } from '../../http/async-route.js';
import { presentNotification } from './notification.presenter.js';
import { listNotifications } from './notification.service.js';

export const notificationRoutes = Router();

notificationRoutes.get(
  '/',
  asyncRoute(async (_request, response) => {
    const notifications = await listNotifications();

    return response.json({ data: notifications.map(presentNotification) });
  }),
);
