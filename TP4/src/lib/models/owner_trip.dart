class OwnerTrip {
  const OwnerTrip({
    required this.id,
    required this.route,
    required this.vessel,
    required this.date,
    required this.passengers,
    required this.capacity,
    required this.status,
    required this.revenue,
  });

  final String id;
  final String route;
  final String vessel;
  final String date;
  final int passengers;
  final int capacity;
  final String status;
  final int revenue;
}
