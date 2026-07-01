class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.date,
    required this.read,
  });

  factory NotificationItem.fromApi(Map<String, Object?> json) {
    final sentAt = DateTime.parse(json['sentAt'] as String).toLocal();

    return NotificationItem(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      time: _formatTime(sentAt),
      date: _dateLabel(sentAt),
      read: false,
    );
  }

  final String id;
  final String type;
  final String title;
  final String body;
  final String time;
  final String date;
  final bool read;

  NotificationItem copyWith({bool? read}) {
    return NotificationItem(
      id: id,
      type: type,
      title: title,
      body: body,
      time: time,
      date: date,
      read: read ?? this.read,
    );
  }
}

String _formatTime(DateTime value) {
  return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

String _dateLabel(DateTime value) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(value.year, value.month, value.day);
  final diff = today.difference(date).inDays;

  if (diff == 0) return 'Hoje';
  if (diff == 1) return 'Ontem';
  return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}';
}
