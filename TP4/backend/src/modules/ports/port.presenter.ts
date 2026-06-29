import type { Port } from '@prisma/client';

export function presentPort(port: Port) {
  return {
    id: port.id,
    name: port.name,
    city: port.city,
    state: port.state,
    latitude: port.latitude ? Number(port.latitude) : null,
    longitude: port.longitude ? Number(port.longitude) : null,
  };
}
