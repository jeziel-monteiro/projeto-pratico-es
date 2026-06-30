import type { NextFunction, Request, Response } from 'express';

import { env } from '../../config/env.js';
import { HttpError } from '../../http/http-error.js';
import { verifyFirebaseIdToken } from './firebase-admin.js';

export type AuthenticatedUser = {
  uid: string;
  email?: string;
  phone?: string;
  name?: string;
};

declare global {
  namespace Express {
    interface Request {
      auth?: AuthenticatedUser;
    }
  }
}

export async function authenticate(
  request: Request,
  _response: Response,
  next: NextFunction,
) {
  try {
    const bearerToken = request.headers.authorization?.match(/^Bearer (.+)$/)?.[1];

    if (bearerToken) {
      const decodedToken = await verifyFirebaseIdToken(bearerToken);
      request.auth = {
        uid: decodedToken.uid,
        email: decodedToken.email,
        phone: decodedToken.phone_number,
        name: decodedToken.name,
      };
      return next();
    }

    if (env.ALLOW_DEV_AUTH) {
      const uid = headerValue(request, 'x-dev-firebase-uid');
      if (!uid) {
        throw new HttpError(
          401,
          'Informe x-dev-firebase-uid para autenticar em desenvolvimento.',
        );
      }

      request.auth = {
        uid,
        email: headerValue(request, 'x-dev-email'),
        phone: headerValue(request, 'x-dev-phone'),
        name: headerValue(request, 'x-dev-name'),
      };
      return next();
    }

    throw new HttpError(401, 'Token de autenticacao nao informado.');
  } catch (error) {
    return next(error);
  }
}

function headerValue(request: Request, name: string) {
  const value = request.headers[name];
  return Array.isArray(value) ? value[0] : value;
}
