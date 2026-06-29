class TripTracking {
  const TripTracking({
    required this.id,
    required this.vesselName,
    required this.routeLabel,
    required this.status,
    required this.progressPercentage,
    required this.remainingMinutes,
    required this.currentPosition,
    required this.previousStop,
    required this.nextStop,
    required this.updatedAt,
    required this.averageSpeed,
  });

  factory TripTracking.fromJson(Map<String, Object?> json) {
    final vessel = (json['vessel'] as Map).cast<String, Object?>();
    final route = (json['route'] as Map).cast<String, Object?>();
    final currentPosition = (json['currentPosition'] as Map?)
        ?.cast<String, Object?>();
    final previousStop = (json['previousStop'] as Map?)
        ?.cast<String, Object?>();
    final nextStop = (json['nextStop'] as Map?)?.cast<String, Object?>();
    final averageSpeed = vessel['averageSpeed'] as num?;

    return TripTracking(
      id: json['id'] as String,
      vesselName: vessel['name'] as String,
      routeLabel:
          '${_portLabel(route['origin'])} -> ${_portLabel(route['destination'])}',
      status: json['status'] as String,
      progressPercentage: json['progressPercentage'] as int,
      remainingMinutes: json['remainingMinutes'] as int?,
      currentPosition: currentPosition == null
          ? null
          : TrackingPosition.fromJson(currentPosition),
      previousStop: previousStop == null
          ? null
          : TrackingStop.fromJson(previousStop),
      nextStop: nextStop == null ? null : TrackingStop.fromJson(nextStop),
      updatedAt: currentPosition?['updatedAt'] == null
          ? null
          : DateTime.parse(currentPosition!['updatedAt'] as String).toLocal(),
      averageSpeed: averageSpeed?.round(),
    );
  }

  final String id;
  final String vesselName;
  final String routeLabel;
  final String status;
  final int progressPercentage;
  final int? remainingMinutes;
  final TrackingPosition? currentPosition;
  final TrackingStop? previousStop;
  final TrackingStop? nextStop;
  final DateTime? updatedAt;
  final int? averageSpeed;

  String get nextStopLabel => nextStop?.label ?? 'Destino';

  String get positionLabel {
    final position = currentPosition;
    if (position == null) return 'Sem sinal';
    return '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
  }

  String get remainingLabel {
    final minutes = remainingMinutes;
    if (minutes == null) return 'Calculando';
    return _formatDuration(minutes);
  }

  String get updatedLabel {
    final value = updatedAt;
    if (value == null) return 'Sem atualização';
    final diff = DateTime.now().difference(value);
    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inHours < 1) return '${diff.inMinutes} min';
    return '${diff.inHours}h';
  }
}

class TrackingPosition {
  const TrackingPosition({required this.latitude, required this.longitude});

  factory TrackingPosition.fromJson(Map<String, Object?> json) {
    final latitude = json['latitude'] as num;
    final longitude = json['longitude'] as num;

    return TrackingPosition(
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
    );
  }

  final double latitude;
  final double longitude;
}

class TrackingStop {
  const TrackingStop({required this.label});

  factory TrackingStop.fromJson(Map<String, Object?> json) {
    return TrackingStop(label: _portLabel(json['port']));
  }

  final String label;
}

String _portLabel(Object? value) {
  final port = (value as Map?)?.cast<String, Object?>();
  if (port == null) return 'Porto';
  final city = port['city'] as String? ?? 'Porto';
  final state = port['state'] as String? ?? '';
  return state.isEmpty ? city : '$city/$state';
}

String _formatDuration(int minutes) {
  if (minutes <= 0) return 'Chegando';
  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;
  if (hours == 0) return '${remainingMinutes}min';
  if (remainingMinutes == 0) return '${hours}h';
  return '${hours}h ${remainingMinutes}min';
}
