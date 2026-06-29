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

  final int id;
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
