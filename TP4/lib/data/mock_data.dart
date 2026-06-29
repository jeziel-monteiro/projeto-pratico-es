import '../models/my_trip.dart';
import '../models/notification_item.dart';
import '../models/owner_trip.dart';
import '../models/review.dart';
import '../models/route_stop.dart';
import '../models/trip.dart';

class MockData {
  static const trips = [
    Trip(
      id: 'mock-1',
      vessel: 'Comandante Freitas',
      origin: 'Manaus',
      destination: 'Santarem',
      date: '25/06/2026',
      time: '06:00',
      duration: '14h',
      price: 180,
      seats: 12,
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1774453262743-451850856acf?w=900&h=500&fit=crop',
      amenities: ['Refeicao', 'WiFi', 'AC', 'Camarote'],
      capacity: 60,
      speed: '20 km/h',
      registration: 'AMZ-2891-M',
    ),
    Trip(
      id: 'mock-2',
      vessel: 'Ana Beatriz',
      origin: 'Manaus',
      destination: 'Parintins',
      date: '26/06/2026',
      time: '08:30',
      duration: '8h',
      price: 95,
      seats: 3,
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1558484779-3092f73da26e?w=900&h=500&fit=crop',
      amenities: ['Lanche', 'Banheiro'],
      capacity: 40,
      speed: '25 km/h',
      registration: 'RNE-1023-M',
    ),
    Trip(
      id: 'mock-3',
      vessel: 'Expresso Amazonas',
      origin: 'Manaus',
      destination: 'Tefe',
      date: '27/06/2026',
      time: '05:00',
      duration: '20h',
      price: 220,
      seats: 0,
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1632022083836-e0f2abb5a212?w=900&h=500&fit=crop',
      amenities: ['Refeicao', 'WiFi', 'AC', 'Camarote', 'Restaurante'],
      capacity: 80,
      speed: '18 km/h',
      registration: 'SOL-3340-M',
    ),
    Trip(
      id: 'mock-4',
      vessel: 'Rei Davi',
      origin: 'Santarem',
      destination: 'Belem',
      date: '28/06/2026',
      time: '07:00',
      duration: '18h',
      price: 155,
      seats: 8,
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1668431396497-d5528cf612a5?w=900&h=500&fit=crop',
      amenities: ['Refeicao', 'WiFi', 'Camarote'],
      capacity: 55,
      speed: '22 km/h',
      registration: 'TAP-4412-B',
    ),
  ];

  static const reviews = [
    Review(
      id: 'mock-1',
      user: 'Pedro Henrique L.',
      avatar: 'P',
      rating: 5,
      date: '15/06/2026',
      comment:
          'Viagem excelente. Embarcacao limpa, tripulacao atenciosa e chegada no horario.',
      helpful: 12,
    ),
    Review(
      id: 'mock-2',
      user: 'Juliana Ferreira',
      avatar: 'J',
      rating: 4,
      date: '10/06/2026',
      comment:
          'Boa experiencia. O camarote era confortavel, mas o WiFi oscilou em parte do trajeto.',
      helpful: 7,
    ),
    Review(
      id: 'mock-3',
      user: 'Roberto Costa',
      avatar: 'R',
      rating: 5,
      date: '02/06/2026',
      comment:
          'Organizacao muito boa, comida honesta e uma vista incrivel do rio ao amanhecer.',
      helpful: 19,
    ),
  ];

  static const routeStops = [
    RouteStop(name: 'Manaus', priceMultiplier: 0, etaFromStart: 'Partida'),
    RouteStop(
      name: 'Itacoatiara',
      priceMultiplier: 0.45,
      etaFromStart: '3h 30min',
    ),
    RouteStop(name: 'Silves', priceMultiplier: 0.60, etaFromStart: '5h 20min'),
    RouteStop(
      name: 'Itapiranga',
      priceMultiplier: 0.72,
      etaFromStart: '7h 10min',
    ),
    RouteStop(name: 'Urucurituba', priceMultiplier: 0.85, etaFromStart: '10h'),
    RouteStop(name: 'Parintins', priceMultiplier: 1, etaFromStart: '12h 30min'),
  ];

  static const ownerTrips = [
    OwnerTrip(
      id: 'VG-001',
      route: 'Manaus -> Santarem',
      vessel: 'Amazonas I',
      date: '25/06',
      passengers: 48,
      capacity: 60,
      status: 'confirmada',
      revenue: 8640,
    ),
    OwnerTrip(
      id: 'VG-002',
      route: 'Manaus -> Parintins',
      vessel: 'Rio Negro Express',
      date: '26/06',
      passengers: 37,
      capacity: 40,
      status: 'embarcando',
      revenue: 3515,
    ),
    OwnerTrip(
      id: 'VG-003',
      route: 'Manaus -> Tefe',
      vessel: 'Solimoes Star',
      date: '27/06',
      passengers: 72,
      capacity: 80,
      status: 'confirmada',
      revenue: 15840,
    ),
    OwnerTrip(
      id: 'VG-004',
      route: 'Santarem -> Belem',
      vessel: 'Tapajos Veloz',
      date: '28/06',
      passengers: 29,
      capacity: 55,
      status: 'pendente',
      revenue: 4495,
    ),
  ];

  static const myTrips = [
    MyTrip(
      id: '#PCB-20260625-4721',
      vessel: 'Comandante Freitas',
      route: 'Manaus -> Santarem',
      date: '25/06/2026',
      time: '06:00',
      status: 'confirmada',
      price: 185,
    ),
    MyTrip(
      id: '#PCB-20260510-3812',
      vessel: 'Ana Beatriz',
      route: 'Manaus -> Parintins',
      date: '10/05/2026',
      time: '08:30',
      status: 'concluida',
      price: 95,
    ),
    MyTrip(
      id: '#PCB-20260115-1094',
      vessel: 'Rei Davi',
      route: 'Santarem -> Belem',
      date: '15/01/2026',
      time: '07:00',
      status: 'cancelada',
      price: 155,
    ),
  ];

  static const notifications = [
    NotificationItem(
      id: 'mock-1',
      type: 'embarque',
      title: 'Embarque em 2 horas',
      body: 'Viagem Manaus -> Parintins embarca as 08:30.',
      time: '08:10',
      date: 'Hoje',
      read: false,
    ),
    NotificationItem(
      id: 'mock-2',
      type: 'atraso',
      title: 'Atraso na embarcacao',
      body:
          'Comandante Freitas sofreu atraso de 30 minutos. Nova saida: 06:30.',
      time: '05:45',
      date: 'Hoje',
      read: false,
    ),
    NotificationItem(
      id: 'mock-3',
      type: 'confirmacao',
      title: 'Reserva confirmada',
      body: 'Sua reserva #PCB-20260625-4721 foi confirmada com sucesso.',
      time: '14:32',
      date: '24/06',
      read: true,
    ),
    NotificationItem(
      id: 'mock-4',
      type: 'cancelamento',
      title: 'Cancelamento',
      body: 'Uma viagem foi cancelada. Reembolso em ate 3 dias uteis.',
      time: '08:20',
      date: '22/06',
      read: true,
    ),
  ];
}
