import { Prisma } from '@prisma/client';

import { prisma } from '../../database/prisma.js';

const notificationInclude = {
  trip: {
    include: {
      originPort: true,
      destinyPort: true,
    },
  },
} satisfies Prisma.NotificationInclude;

export async function listNotifications() {
  return prisma.notification.findMany({
    include: notificationInclude,
    orderBy: [{ sentAt: 'desc' }, { createdAt: 'desc' }],
    take: 30,
  });
}
