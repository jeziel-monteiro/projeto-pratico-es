import type { Notification, Port, Trip } from '@prisma/client';

type NotificationWithTrip = Notification & {
  trip:
    | (Trip & {
        originPort: Port;
        destinyPort: Port;
      })
    | null;
};

export function presentNotification(notification: NotificationWithTrip) {
  return {
    id: notification.id,
    type: notification.type,
    title: notification.title,
    body: notification.body,
    sentAt: notification.sentAt ?? notification.createdAt,
    createdAt: notification.createdAt,
    trip: notification.trip
      ? {
          id: notification.trip.id,
          origin: {
            city: notification.trip.originPort.city,
            state: notification.trip.originPort.state,
          },
          destination: {
            city: notification.trip.destinyPort.city,
            state: notification.trip.destinyPort.state,
          },
        }
      : null,
  };
}
