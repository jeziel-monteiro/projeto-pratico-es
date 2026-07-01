import { Router } from 'express';

import { asyncRoute } from '../../http/async-route.js';
import { presentPort } from './port.presenter.js';
import { listPorts } from './port.service.js';

export const portRoutes = Router();

portRoutes.get(
  '/',
  asyncRoute(async (_request, response) => {
    const ports = await listPorts();

    return response.json({ data: ports.map(presentPort) });
  }),
);
