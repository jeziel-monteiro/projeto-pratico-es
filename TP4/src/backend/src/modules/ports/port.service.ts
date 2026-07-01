import { prisma } from '../../database/prisma.js';

export function listPorts() {
  return prisma.port.findMany({
    orderBy: [{ state: 'asc' }, { city: 'asc' }],
  });
}
