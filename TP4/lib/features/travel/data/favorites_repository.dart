import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/network/api_client.dart';
import '../../../models/trip.dart';

class FavoritesRepository {
  FavoritesRepository({ApiClient? apiClient, this.firebaseAuth})
    : _apiClient = apiClient ?? ApiClient();

  static const _useDevAuth = bool.fromEnvironment('PORTO_CERTO_USE_DEV_AUTH');

  final ApiClient _apiClient;
  final FirebaseAuth? firebaseAuth;

  Future<List<Trip>> listFavorites() async {
    final user = _currentUser('Entre na sua conta para ver favoritos.');
    final idToken = _useDevAuth ? null : await user.getIdToken();
    final response =
        await _apiClient.getJson(
              'favorites/me',
              bearerToken: idToken,
              headers: _useDevAuth ? _devHeaders(user) : null,
            )
            as Map<String, Object?>;
    final data = response['data'] as List<Object?>;

    return data.map((item) => Trip.fromApi((item as Map).cast())).toList();
  }

  Future<Trip> addFavorite(String tripId) async {
    final user = _currentUser('Entre na sua conta para favoritar viagens.');
    final idToken = _useDevAuth ? null : await user.getIdToken();
    final response =
        await _apiClient.postJson(
              'favorites/$tripId',
              bearerToken: idToken,
              headers: _useDevAuth ? _devHeaders(user) : null,
            )
            as Map<String, Object?>;
    final data = response['data'] as Map<String, Object?>;

    return Trip.fromApi(data);
  }

  Future<void> removeFavorite(String tripId) async {
    final user = _currentUser('Entre na sua conta para remover favoritos.');
    final idToken = _useDevAuth ? null : await user.getIdToken();
    await _apiClient.deleteJson(
      'favorites/$tripId',
      bearerToken: idToken,
      headers: _useDevAuth ? _devHeaders(user) : null,
    );
  }

  void close() {
    _apiClient.close();
  }

  User _currentUser(String message) {
    final user = (firebaseAuth ?? FirebaseAuth.instance).currentUser;
    if (user == null) throw FavoritesRepositoryException(message);
    return user;
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

class FavoritesRepositoryException implements Exception {
  const FavoritesRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
