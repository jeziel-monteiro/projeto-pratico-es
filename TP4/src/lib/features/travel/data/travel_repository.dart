import '../../../core/network/api_client.dart';
import '../../../models/trip.dart';
import '../../../models/trip_tracking.dart';

class TravelRepository {
  TravelRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<PortOption>> listPorts() async {
    final response = await _apiClient.getJson('ports') as Map<String, Object?>;
    final data = response['data'] as List<Object?>;

    return data.cast<Map<String, Object?>>().map(PortOption.fromJson).toList();
  }

  Future<List<Trip>> searchTrips(TripSearchCriteria criteria) async {
    final response =
        await _apiClient.getJson(
              'trips/search',
              queryParameters: {
                'origin': criteria.origin,
                'destination': criteria.destination,
                'date': criteria.apiDate,
              },
            )
            as Map<String, Object?>;
    final data = response['data'] as List<Object?>;

    return data.cast<Map<String, Object?>>().map(Trip.fromApi).toList();
  }

  Future<List<Trip>> listFeaturedTrips() async {
    final response =
        await _apiClient.getJson('trips/search') as Map<String, Object?>;
    final data = response['data'] as List<Object?>;

    return data.cast<Map<String, Object?>>().map(Trip.fromApi).take(4).toList();
  }

  Future<List<Trip>> listRelatedTrips(String tripId) async {
    final response =
        await _apiClient.getJson('trips/$tripId/related')
            as Map<String, Object?>;
    final data = response['data'] as List<Object?>;

    return data.cast<Map<String, Object?>>().map(Trip.fromApi).toList();
  }

  Future<Trip> getTrip(String id) async {
    final response =
        await _apiClient.getJson('trips/$id') as Map<String, Object?>;
    final data = response['data'] as Map<String, Object?>;

    return Trip.fromApi(data);
  }

  Future<TripTracking> getTripTracking(String id) async {
    final response =
        await _apiClient.getJson('trips/$id/tracking') as Map<String, Object?>;
    final data = response['data'] as Map<String, Object?>;

    return TripTracking.fromJson(data);
  }

  void close() {
    _apiClient.close();
  }
}

class PortOption {
  const PortOption({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
  });

  factory PortOption.fromJson(Map<String, Object?> json) {
    return PortOption(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
    );
  }

  final String id;
  final String name;
  final String city;
  final String state;

  String get label => '$city/$state';
}

class TripSearchCriteria {
  const TripSearchCriteria({
    required this.origin,
    required this.destination,
    required this.date,
  });

  final String origin;
  final String destination;
  final DateTime date;

  String get apiDate {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String get displayDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String get routeLabel => '$origin -> $destination';
}
