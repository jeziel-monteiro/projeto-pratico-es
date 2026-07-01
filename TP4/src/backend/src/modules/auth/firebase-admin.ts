import { cert, getApps, initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';

import { env } from '../../config/env.js';
import { HttpError } from '../../http/http-error.js';

function ensureFirebaseApp() {
  const [existingApp] = getApps();
  if (existingApp) return existingApp;

  const hasServiceAccount =
    env.FIREBASE_PROJECT_ID &&
    env.FIREBASE_CLIENT_EMAIL &&
    env.FIREBASE_PRIVATE_KEY;

  if (!hasServiceAccount) {
    throw new HttpError(
      503,
      'Firebase Admin nao foi configurado no backend.',
    );
  }

  return initializeApp({
    credential: cert({
      projectId: env.FIREBASE_PROJECT_ID,
      clientEmail: env.FIREBASE_CLIENT_EMAIL,
      privateKey: env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
    }),
  });
}

export async function verifyFirebaseIdToken(idToken: string) {
  const app = ensureFirebaseApp();
  return getAuth(app).verifyIdToken(idToken);
}
