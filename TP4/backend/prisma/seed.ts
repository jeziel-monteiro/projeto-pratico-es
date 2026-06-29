import {
  PrismaClient,
  TripStatus,
  UserRole,
  VesselStatus,
} from '@prisma/client';

const prisma = new PrismaClient();

type PortSeed = {
  key: string;
  name: string;
  city: string;
  state: string;
  latitude: string;
  longitude: string;
};

type TripStopSeed = {
  portKey: string;
  offsetHours: number;
  priceMultiplier: string;
};

type TripSeed = {
  vesselKey: string;
  originKey: string;
  destinationKey: string;
  departureAt: string;
  durationHours: number;
  basePrice: string;
  seatsTotal: number;
  seatsAvailable: number;
  trackingProgress: number;
  stops: TripStopSeed[];
};

const ports: PortSeed[] = [
  {
    key: 'manaus',
    name: 'Porto de Manaus',
    city: 'Manaus',
    state: 'AM',
    latitude: '-3.1376',
    longitude: '-60.0255',
  },
  {
    key: 'itacoatiara',
    name: 'Porto de Itacoatiara',
    city: 'Itacoatiara',
    state: 'AM',
    latitude: '-3.1431',
    longitude: '-58.4449',
  },
  {
    key: 'parintins',
    name: 'Terminal Hidroviario de Parintins',
    city: 'Parintins',
    state: 'AM',
    latitude: '-2.6283',
    longitude: '-56.7358',
  },
  {
    key: 'obidos',
    name: 'Terminal Hidroviario de Obidos',
    city: 'Obidos',
    state: 'PA',
    latitude: '-1.9177',
    longitude: '-55.5181',
  },
  {
    key: 'santarem',
    name: 'Porto de Santarem',
    city: 'Santarem',
    state: 'PA',
    latitude: '-2.4426',
    longitude: '-54.7088',
  },
  {
    key: 'monte-alegre',
    name: 'Terminal Hidroviario de Monte Alegre',
    city: 'Monte Alegre',
    state: 'PA',
    latitude: '-2.0008',
    longitude: '-54.0810',
  },
  {
    key: 'almeirim',
    name: 'Terminal Hidroviario de Almeirim',
    city: 'Almeirim',
    state: 'PA',
    latitude: '-1.5235',
    longitude: '-52.5818',
  },
  {
    key: 'belem',
    name: 'Terminal Hidroviario de Belem',
    city: 'Belem',
    state: 'PA',
    latitude: '-1.4558',
    longitude: '-48.5044',
  },
  {
    key: 'santana',
    name: 'Porto de Santana - Macapa',
    city: 'Santana/Macapa',
    state: 'AP',
    latitude: '-0.0583',
    longitude: '-51.1817',
  },
];

const vessels = [
  {
    key: 'amazonas-expresso',
    name: 'Amazonas Expresso',
    officialRegistry: 'AMZ-2026-001',
    passengerCapacity: 120,
    averageSpeed: '22.0',
    rating: '4.7',
    amenities: ['Refeicao', 'Redario', 'Camarote', 'Banheiro', 'Tomadas'],
    imageUrl:
      'https://images.unsplash.com/photo-1569263979104-865ab7cd8d13?w=900&h=500&fit=crop',
  },
  {
    key: 'tapajos-norte',
    name: 'Tapajos Norte',
    officialRegistry: 'PA-STM-1142',
    passengerCapacity: 90,
    averageSpeed: '19.0',
    rating: '4.5',
    amenities: ['Refeicao', 'Redario', 'Banheiro', 'Area coberta'],
    imageUrl:
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900&h=500&fit=crop',
  },
  {
    key: 'marajo-atlantico',
    name: 'Marajo Atlantico',
    officialRegistry: 'PA-BEL-4088',
    passengerCapacity: 150,
    averageSpeed: '24.0',
    rating: '4.6',
    amenities: ['Poltrona', 'Camarote', 'Lanchonete', 'Ar-condicionado'],
    imageUrl:
      'https://images.unsplash.com/photo-1528154291023-a6525fabe5b4?w=900&h=500&fit=crop',
  },
];

const trips: TripSeed[] = [
  {
    vesselKey: 'amazonas-expresso',
    originKey: 'manaus',
    destinationKey: 'santarem',
    departureAt: '2026-07-04T08:00:00-04:00',
    durationHours: 36,
    basePrice: '450.00',
    seatsTotal: 120,
    seatsAvailable: 46,
    trackingProgress: 0.62,
    stops: [
      { portKey: 'manaus', offsetHours: 0, priceMultiplier: '0.0000' },
      { portKey: 'itacoatiara', offsetHours: 7, priceMultiplier: '0.1800' },
      { portKey: 'parintins', offsetHours: 18, priceMultiplier: '0.5500' },
      { portKey: 'obidos', offsetHours: 28, priceMultiplier: '0.7800' },
      { portKey: 'santarem', offsetHours: 36, priceMultiplier: '1.0000' },
    ],
  },
  {
    vesselKey: 'amazonas-expresso',
    originKey: 'manaus',
    destinationKey: 'parintins',
    departureAt: '2026-07-05T07:30:00-04:00',
    durationHours: 18,
    basePrice: '190.00',
    seatsTotal: 120,
    seatsAvailable: 22,
    trackingProgress: 0.34,
    stops: [
      { portKey: 'manaus', offsetHours: 0, priceMultiplier: '0.0000' },
      { portKey: 'itacoatiara', offsetHours: 7, priceMultiplier: '0.3900' },
      { portKey: 'parintins', offsetHours: 18, priceMultiplier: '1.0000' },
    ],
  },
  {
    vesselKey: 'tapajos-norte',
    originKey: 'parintins',
    destinationKey: 'santarem',
    departureAt: '2026-07-06T06:00:00-04:00',
    durationHours: 20,
    basePrice: '210.00',
    seatsTotal: 90,
    seatsAvailable: 31,
    trackingProgress: 0.42,
    stops: [
      { portKey: 'parintins', offsetHours: 0, priceMultiplier: '0.0000' },
      { portKey: 'obidos', offsetHours: 11, priceMultiplier: '0.5500' },
      { portKey: 'santarem', offsetHours: 20, priceMultiplier: '1.0000' },
    ],
  },
  {
    vesselKey: 'tapajos-norte',
    originKey: 'santarem',
    destinationKey: 'belem',
    departureAt: '2026-07-07T09:00:00-03:00',
    durationHours: 42,
    basePrice: '380.00',
    seatsTotal: 90,
    seatsAvailable: 18,
    trackingProgress: 0.26,
    stops: [
      { portKey: 'santarem', offsetHours: 0, priceMultiplier: '0.0000' },
      { portKey: 'monte-alegre', offsetHours: 6, priceMultiplier: '0.1500' },
      { portKey: 'almeirim', offsetHours: 18, priceMultiplier: '0.4300' },
      { portKey: 'belem', offsetHours: 42, priceMultiplier: '1.0000' },
    ],
  },
  {
    vesselKey: 'tapajos-norte',
    originKey: 'santarem',
    destinationKey: 'santana',
    departureAt: '2026-07-08T11:00:00-03:00',
    durationHours: 30,
    basePrice: '330.00',
    seatsTotal: 90,
    seatsAvailable: 27,
    trackingProgress: 0.51,
    stops: [
      { portKey: 'santarem', offsetHours: 0, priceMultiplier: '0.0000' },
      { portKey: 'monte-alegre', offsetHours: 6, priceMultiplier: '0.2000' },
      { portKey: 'almeirim', offsetHours: 18, priceMultiplier: '0.6000' },
      { portKey: 'santana', offsetHours: 30, priceMultiplier: '1.0000' },
    ],
  },
  {
    vesselKey: 'marajo-atlantico',
    originKey: 'belem',
    destinationKey: 'santana',
    departureAt: '2026-07-09T18:00:00-03:00',
    durationHours: 26,
    basePrice: '260.00',
    seatsTotal: 150,
    seatsAvailable: 54,
    trackingProgress: 0.48,
    stops: [
      { portKey: 'belem', offsetHours: 0, priceMultiplier: '0.0000' },
      { portKey: 'santana', offsetHours: 26, priceMultiplier: '1.0000' },
    ],
  },
  {
    vesselKey: 'marajo-atlantico',
    originKey: 'santana',
    destinationKey: 'belem',
    departureAt: '2026-07-11T17:00:00-03:00',
    durationHours: 26,
    basePrice: '260.00',
    seatsTotal: 150,
    seatsAvailable: 61,
    trackingProgress: 0.22,
    stops: [
      { portKey: 'santana', offsetHours: 0, priceMultiplier: '0.0000' },
      { portKey: 'belem', offsetHours: 26, priceMultiplier: '1.0000' },
    ],
  },
  {
    vesselKey: 'amazonas-expresso',
    originKey: 'santarem',
    destinationKey: 'manaus',
    departureAt: '2026-07-12T07:00:00-04:00',
    durationHours: 44,
    basePrice: '430.00',
    seatsTotal: 120,
    seatsAvailable: 38,
    trackingProgress: 0.37,
    stops: [
      { portKey: 'santarem', offsetHours: 0, priceMultiplier: '0.0000' },
      { portKey: 'obidos', offsetHours: 8, priceMultiplier: '0.1800' },
      { portKey: 'parintins', offsetHours: 24, priceMultiplier: '0.5500' },
      { portKey: 'itacoatiara', offsetHours: 36, priceMultiplier: '0.8200' },
      { portKey: 'manaus', offsetHours: 44, priceMultiplier: '1.0000' },
    ],
  },
];

async function main() {
  const ownerUser = await prisma.user.upsert({
    where: { email: 'operacao@portocerto.com' },
    update: {},
    create: {
      email: 'operacao@portocerto.com',
      fullName: 'Operacao Porto Certo',
      role: UserRole.OWNER,
    },
  });

  const owner = await prisma.ownerProfile.upsert({
    where: { userId: ownerUser.id },
    update: {},
    create: {
      userId: ownerUser.id,
      companyName: 'Porto Certo Operacoes Fluviais',
      cnpj: '12345678000190',
      responsibleName: 'Equipe Porto Certo',
    },
  });

  const portIds = new Map<string, string>();
  for (const port of ports) {
    const savedPort = await prisma.port.upsert({
      where: {
        city_state: {
          city: port.city,
          state: port.state,
        },
      },
      update: {
        name: port.name,
        latitude: port.latitude,
        longitude: port.longitude,
      },
      create: {
        name: port.name,
        city: port.city,
        state: port.state,
        latitude: port.latitude,
        longitude: port.longitude,
      },
    });

    portIds.set(port.key, savedPort.id);
  }

  const vesselIds = new Map<string, string>();
  for (const vessel of vessels) {
    const savedVessel = await prisma.vessel.upsert({
      where: { officialRegistry: vessel.officialRegistry },
      update: {
        name: vessel.name,
        passengerCapacity: vessel.passengerCapacity,
        averageSpeed: vessel.averageSpeed,
        rating: vessel.rating,
        amenities: vessel.amenities,
        status: VesselStatus.VALIDATED,
      },
      create: {
        ownerId: owner.id,
        name: vessel.name,
        officialRegistry: vessel.officialRegistry,
        passengerCapacity: vessel.passengerCapacity,
        averageSpeed: vessel.averageSpeed,
        rating: vessel.rating,
        amenities: vessel.amenities,
        status: VesselStatus.VALIDATED,
      },
    });

    await prisma.vesselPhoto.upsert({
      where: {
        vesselId_url: {
          vesselId: savedVessel.id,
          url: vessel.imageUrl,
        },
      },
      update: {
        altText: `Imagem da embarcacao ${vessel.name}`,
      },
      create: {
        vesselId: savedVessel.id,
        url: vessel.imageUrl,
        altText: `Imagem da embarcacao ${vessel.name}`,
      },
    });

    vesselIds.set(vessel.key, savedVessel.id);
  }

  for (const trip of trips) {
    const vesselId = requireValue(vesselIds, trip.vesselKey);
    const originPortId = requireValue(portIds, trip.originKey);
    const destinyPortId = requireValue(portIds, trip.destinationKey);
    const departureAt = new Date(trip.departureAt);
    const arrivalEstimateAt = new Date(
      departureAt.getTime() + trip.durationHours * 60 * 60 * 1000,
    );

    const savedTrip = await prisma.trip.upsert({
      where: {
        vesselId_originPortId_destinyPortId_departureAt: {
          vesselId,
          originPortId,
          destinyPortId,
          departureAt,
        },
      },
      update: {
        arrivalEstimateAt,
        basePrice: trip.basePrice,
        seatsTotal: trip.seatsTotal,
        seatsAvailable: trip.seatsAvailable,
        status: TripStatus.SCHEDULED,
      },
      create: {
        vesselId,
        originPortId,
        destinyPortId,
        departureAt,
        arrivalEstimateAt,
        basePrice: trip.basePrice,
        seatsTotal: trip.seatsTotal,
        seatsAvailable: trip.seatsAvailable,
        status: TripStatus.SCHEDULED,
      },
    });

    await prisma.tripStop.deleteMany({
      where: { tripId: savedTrip.id },
    });

    for (const [index, stop] of trip.stops.entries()) {
      const portId = requireValue(portIds, stop.portKey);
      const stopDate = new Date(
        departureAt.getTime() + stop.offsetHours * 60 * 60 * 1000,
      );

      await prisma.tripStop.create({
        data: {
          tripId: savedTrip.id,
          portId,
          stopOrder: index,
          arrivalEstimateAt: index === 0 ? null : stopDate,
          departureEstimateAt:
            index === trip.stops.length - 1 ? null : stopDate,
          priceMultiplier: stop.priceMultiplier,
        },
      });
    }

    const position = simulatedPositionForTrip(trip);
    await prisma.tripPosition.upsert({
      where: { tripId: savedTrip.id },
      update: {
        latitude: position.latitude,
        longitude: position.longitude,
      },
      create: {
        tripId: savedTrip.id,
        latitude: position.latitude,
        longitude: position.longitude,
      },
    });
  }

  console.log(
    'Seed de portos, embarcacoes, viagens, paradas e posicoes concluido.',
  );
}

function requireValue(values: Map<string, string>, key: string) {
  const value = values.get(key);
  if (!value) throw new Error(`Chave nao encontrada no seed: ${key}`);
  return value;
}

function simulatedPositionForTrip(trip: TripSeed) {
  const orderedStops = [...trip.stops].sort(
    (first, second) => Number(first.priceMultiplier) - Number(second.priceMultiplier),
  );
  const progress = Math.max(0, Math.min(1, trip.trackingProgress));
  const nextIndex = orderedStops.findIndex(
    (stop) => Number(stop.priceMultiplier) >= progress,
  );

  if (nextIndex <= 0) {
    return coordinatesForStop(orderedStops[0].portKey);
  }

  const nextStop = orderedStops[nextIndex] ?? orderedStops[orderedStops.length - 1];
  const previousStop = orderedStops[nextIndex - 1];
  const previousMultiplier = Number(previousStop.priceMultiplier);
  const nextMultiplier = Number(nextStop.priceMultiplier);
  const segmentProgress =
    nextMultiplier === previousMultiplier
      ? 0
      : (progress - previousMultiplier) / (nextMultiplier - previousMultiplier);
  const previousCoordinates = coordinatesForStop(previousStop.portKey);
  const nextCoordinates = coordinatesForStop(nextStop.portKey);

  return {
    latitude: interpolate(
      previousCoordinates.latitude,
      nextCoordinates.latitude,
      segmentProgress,
    ).toFixed(7),
    longitude: interpolate(
      previousCoordinates.longitude,
      nextCoordinates.longitude,
      segmentProgress,
    ).toFixed(7),
  };
}

function coordinatesForStop(portKey: string) {
  const port = ports.find((item) => item.key === portKey);
  if (!port) throw new Error(`Porto nao encontrado para posicao: ${portKey}`);

  return {
    latitude: Number(port.latitude),
    longitude: Number(port.longitude),
  };
}

function interpolate(start: number, end: number, progress: number) {
  return start + (end - start) * progress;
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
