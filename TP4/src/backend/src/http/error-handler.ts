import type { NextFunction, Request, Response } from 'express';
import { Prisma } from '@prisma/client';
import { ZodError } from 'zod';

import { HttpError } from './http-error.js';

export function errorHandler(
  error: unknown,
  _request: Request,
  response: Response,
  _next: NextFunction,
) {
  if (error instanceof HttpError) {
    return response.status(error.statusCode).json({
      message: error.message,
      details: error.details,
    });
  }

  if (error instanceof ZodError) {
    return response.status(400).json({
      message: 'Dados invalidos.',
      details: error.flatten(),
    });
  }

  if (
    error instanceof Prisma.PrismaClientKnownRequestError &&
    error.code === 'P2002'
  ) {
    return response.status(409).json({
      message: 'Ja existe um registro com estes dados.',
      details: error.meta,
    });
  }

  console.error(error);
  return response.status(500).json({
    message: 'Erro interno na API Porto Certo.',
  });
}
