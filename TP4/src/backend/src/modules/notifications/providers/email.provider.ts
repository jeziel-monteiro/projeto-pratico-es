import { env } from '../../../config/env.js';

export type EmailMessage = {
  to: string;
  subject: string;
  text: string;
  html: string;
  idempotencyKey?: string;
};

type ResendEmailPayload = {
  from: string;
  to: string[];
  subject: string;
  text: string;
  html: string;
  reply_to?: string;
};

export async function sendEmail(message: EmailMessage) {
  if (!env.EMAIL_NOTIFICATIONS_ENABLED) {
    console.info(
      `[email] envio desabilitado; mensagem "${message.subject}" para ${message.to} ignorada.`,
    );
    return;
  }

  if (!env.RESEND_API_KEY) {
    throw new Error(
      'RESEND_API_KEY nao configurada para envio de notificacoes por email.',
    );
  }

  const payload: ResendEmailPayload = {
    from: env.EMAIL_FROM,
    to: [message.to],
    subject: message.subject,
    text: message.text,
    html: message.html,
    ...(env.EMAIL_REPLY_TO ? { reply_to: env.EMAIL_REPLY_TO } : {}),
  };

  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${env.RESEND_API_KEY}`,
      'Content-Type': 'application/json',
      ...(message.idempotencyKey
        ? { 'Idempotency-Key': message.idempotencyKey }
        : {}),
    },
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    const responseBody = await response.text();
    throw new Error(
      `Falha ao enviar email pelo Resend (${response.status}): ${responseBody}`,
    );
  }
}
