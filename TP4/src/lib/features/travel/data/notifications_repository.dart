import '../../../core/network/api_client.dart';
import '../../../models/notification_item.dart';

class NotificationsRepository {
  NotificationsRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<NotificationItem>> listNotifications() async {
    final response =
        await _apiClient.getJson('notifications') as Map<String, Object?>;
    final data = response['data'] as List<Object?>;

    return data
        .map((item) => NotificationItem.fromApi((item as Map).cast()))
        .toList();
  }

  void close() {
    _apiClient.close();
  }
}
