import '../../../core/network/api_client.dart';
import 'traveler_profile.dart';

class TravelerRepository {
  TravelerRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  static const _useDevAuth = bool.fromEnvironment('PORTO_CERTO_USE_DEV_AUTH');

  final ApiClient _apiClient;

  Future<TravelerProfile> createProfile({
    required String firebaseUid,
    required String idToken,
    required String fullName,
    required String cpf,
    required String email,
    String? phone,
  }) async {
    final response =
        await _apiClient.postJson(
              'travelers',
              bearerToken: _useDevAuth ? null : idToken,
              headers: _devHeaders(firebaseUid, email, phone),
              body: {
                'fullName': fullName,
                'cpf': cpf,
                'email': email,
                'phone': phone,
                'highContrast': false,
              },
            )
            as Map<String, Object?>;

    return TravelerProfile.fromJson(response['data'] as Map<String, Object?>);
  }

  Future<TravelerProfile> fetchMe({
    required String firebaseUid,
    required String idToken,
    String? email,
  }) async {
    final response =
        await _apiClient.getJson(
              'travelers/me',
              bearerToken: _useDevAuth ? null : idToken,
              headers: _devHeaders(firebaseUid, email, null),
            )
            as Map<String, Object?>;

    return TravelerProfile.fromJson(response['data'] as Map<String, Object?>);
  }

  void close() {
    _apiClient.close();
  }

  Map<String, String>? _devHeaders(
    String firebaseUid,
    String? email,
    String? phone,
  ) {
    if (!_useDevAuth) return null;

    return {
      'x-dev-firebase-uid': firebaseUid,
      if (email != null && email.isNotEmpty) 'x-dev-email': email,
      if (phone != null && phone.isNotEmpty) 'x-dev-phone': phone,
    };
  }
}
