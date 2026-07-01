import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/network/api_client.dart';
import '../../../models/my_trip.dart';

class MyTripsRepository {
  MyTripsRepository({ApiClient? apiClient, FirebaseAuth? firebaseAuth})
    : _apiClient = apiClient ?? ApiClient(),
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  static const _useDevAuth = bool.fromEnvironment('PORTO_CERTO_USE_DEV_AUTH');

  final ApiClient _apiClient;
  final FirebaseAuth _firebaseAuth;

  Future<List<MyTrip>> listMyTrips() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const MyTripsRepositoryException(
        'Entre na sua conta para visualizar suas viagens.',
      );
    }

    final idToken = _useDevAuth ? null : await user.getIdToken();
    final response =
        await _apiClient.getJson(
              'bookings/me',
              bearerToken: idToken,
              headers: _useDevAuth ? _devHeaders(user) : null,
            )
            as Map<String, Object?>;
    final data = response['data'] as List<Object?>;

    return data
        .map((item) => MyTrip.fromBooking((item as Map).cast()))
        .toList();
  }

  Future<MyTrip> getBooking(String bookingId) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const MyTripsRepositoryException(
        'Entre na sua conta para visualizar o bilhete.',
      );
    }

    final idToken = _useDevAuth ? null : await user.getIdToken();
    final response =
        await _apiClient.getJson(
              'bookings/$bookingId',
              bearerToken: idToken,
              headers: _useDevAuth ? _devHeaders(user) : null,
            )
            as Map<String, Object?>;
    final data = response['data'] as Map<String, Object?>;

    return MyTrip.fromBooking(data);
  }

  Future<MyTrip> cancelBooking(String bookingId) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const MyTripsRepositoryException(
        'Entre na sua conta para cancelar reservas.',
      );
    }

    final idToken = _useDevAuth ? null : await user.getIdToken();
    final response =
        await _apiClient.postJson(
              'bookings/$bookingId/cancel',
              bearerToken: idToken,
              headers: _useDevAuth ? _devHeaders(user) : null,
            )
            as Map<String, Object?>;
    final data = response['data'] as Map<String, Object?>;

    return MyTrip.fromBooking(data);
  }

  void close() {
    _apiClient.close();
  }

  Map<String, String> _devHeaders(User user) {
    return {
      'x-dev-firebase-uid': user.uid,
      if (user.email != null && user.email!.isNotEmpty)
        'x-dev-email': user.email!,
      if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
        'x-dev-phone': user.phoneNumber!,
    };
  }
}

class MyTripsRepositoryException implements Exception {
  const MyTripsRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
