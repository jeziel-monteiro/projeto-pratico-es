import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';

import { env } from './config/env.js';
import { errorHandler } from './http/error-handler.js';
import { routes } from './routes/index.js';

export const app = express();

app.use(helmet());
app.use(
  cors({
    origin: env.CORS_ORIGIN === '*' ? true : env.CORS_ORIGIN.split(','),
  }),
);
app.use(express.json());
app.use(morgan(env.NODE_ENV === 'production' ? 'combined' : 'dev'));

app.use('/api/v1', routes);

app.use((_request, response) => {
  return response.status(404).json({
    message: 'Rota nao encontrada.',
  });
});

app.use(errorHandler);
