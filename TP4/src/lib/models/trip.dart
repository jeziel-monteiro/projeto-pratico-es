class Trip {
  const Trip({
    required this.id,
    required this.vessel,
    required this.origin,
    required this.destination,
    required this.date,
    required this.time,
    required this.duration,
    required this.price,
    required this.seats,
    required this.rating,
    required this.imageUrl,
    required this.amenities,
    required this.capacity,
    required this.speed,
    required this.registration,
    this.stops = const [],
  });

  factory Trip.fromApi(Map<String, Object?> json) {
    final origin = json['origin'] as Map<String, Object?>;
    final destination = json['destination'] as Map<String, Object?>;
    final vessel = json['vessel'] as Map<String, Object?>;
    final departureAt = DateTime.parse(json['departureAt'] as String).toLocal();
    final durationMinutes = json['durationMinutes'] as int?;
    final basePrice = json['basePrice'] as num;
    final seatsAvailable = json['seatsAvailable'] as int;
    final averageSpeed = vessel['averageSpeed'] as num?;
    final rating = vessel['rating'] as num?;
    final stops = (json['stops'] as List<Object?>? ?? const [])
        .map((stop) => TripStop.fromApi((stop as Map).cast()))
        .toList();

    return Trip(
      id: json['id'] as String,
      vessel: vessel['name'] as String,
      origin: origin['city'] as String,
      destination: destination['city'] as String,
      date: _formatDate(departureAt),
      time: _formatTime(departureAt),
      duration: _formatDuration(durationMinutes),
      price: basePrice.round(),
      seats: seatsAvailable,
      rating: (rating ?? 4.5).toDouble(),
      imageUrl: vessel['imageUrl'] as String? ?? '',
      amenities: (vessel['amenities'] as List<Object?>? ?? const [])
          .cast<String>(),
      capacity: vessel['capacity'] as int,
      speed: averageSpeed == null
          ? 'Veloc. variável'
          : '${averageSpeed.toStringAsFixed(0)} km/h',
      registration: vessel['registration'] as String,
      stops: stops,
    );
  }

  final String id;
  final String vessel;
  final String origin;
  final String destination;
  final String date;
  final String time;
  final String duration;
  final int price;
  final int seats;
  final double rating;
  final String imageUrl;
  final List<String> amenities;
  final int capacity;
  final String speed;
  final String registration;
  final List<TripStop> stops;
}

class TripStop {
  const TripStop({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.order,
    required this.priceMultiplier,
    required this.etaMinutesFromStart,
  });

  factory TripStop.fromApi(Map<String, Object?> json) {
    final port = json['port'] as Map<String, Object?>;
    final eta = json['etaMinutesFromStart'] as num?;
    final priceMultiplier = json['priceMultiplier'] as num;

    return TripStop(
      id: json['id'] as String,
      name: port['name'] as String,
      city: port['city'] as String,
      state: port['state'] as String,
      order: json['order'] as int,
      priceMultiplier: priceMultiplier.toDouble(),
      etaMinutesFromStart: eta?.round() ?? 0,
    );
  }

  final String id;
  final String name;
  final String city;
  final String state;
  final int order;
  final double priceMultiplier;
  final int etaMinutesFromStart;

  String get label => '$city/$state';

  String get etaFromStart {
    if (etaMinutesFromStart <= 0) return 'Partida';
    return _formatDuration(etaMinutesFromStart);
  }
}

String _formatDate(DateTime value) {
  return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}

String _formatTime(DateTime value) {
  return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

String _formatDuration(int? minutes) {
  if (minutes == null) return 'Duração variável';
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  if (remainingMinutes == 0) return '${hours}h';
  return '${hours}h ${remainingMinutes}min';
}
