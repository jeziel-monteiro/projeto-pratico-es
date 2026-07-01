import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/network/api_client.dart';
import '../../../models/review.dart';

class ReviewsRepository {
  ReviewsRepository({ApiClient? apiClient, this.firebaseAuth})
    : _apiClient = apiClient ?? ApiClient();

  static const _useDevAuth = bool.fromEnvironment('PORTO_CERTO_USE_DEV_AUTH');

  final ApiClient _apiClient;
  final FirebaseAuth? firebaseAuth;

  Future<ReviewBundle> listTripReviews(String tripId) async {
    final response =
        await _apiClient.getJson('trips/$tripId/reviews')
            as Map<String, Object?>;

    return ReviewBundle.fromApi(response);
  }

  Future<ReviewSubmission> publishReview({
    required String tripId,
    required int rating,
    required String comment,
  }) async {
    final user = _currentUser('Entre na sua conta para avaliar a embarcação.');
    final idToken = _useDevAuth ? null : await user.getIdToken();
    final response =
        await _apiClient.postJson(
              'trips/$tripId/reviews',
              bearerToken: idToken,
              headers: _useDevAuth ? _devHeaders(user) : null,
              body: {'rating': rating, 'comment': comment},
            )
            as Map<String, Object?>;

    return ReviewSubmission.fromApi(response);
  }

  void close() {
    _apiClient.close();
  }

  User _currentUser(String message) {
    final user = (firebaseAuth ?? FirebaseAuth.instance).currentUser;
    if (user == null) throw ReviewsRepositoryException(message);
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

class ReviewsRepositoryException implements Exception {
  const ReviewsRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
