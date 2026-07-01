class RouteStop {
  const RouteStop({
    this.id,
    required this.name,
    required this.priceMultiplier,
    required this.etaFromStart,
  });

  final String? id;
  final String name;
  final double priceMultiplier;
  final String etaFromStart;
}
