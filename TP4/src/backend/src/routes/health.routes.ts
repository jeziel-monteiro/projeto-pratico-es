import { Router } from 'express';

import { prisma } from '../database/prisma.js';

export const healthRoutes = Router();

healthRoutes.get('/', (_request, response) => {
  return response.json({
    status: 'ok',
    service: 'porto-certo-backend',
  });
});

healthRoutes.get('/db', async (_request, response) => {
  await prisma.$queryRaw`SELECT 1`;

  return response.json({
    status: 'ok',
    database: 'postgresql',
  });
});
