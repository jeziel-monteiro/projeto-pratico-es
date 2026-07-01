class MyTrip {
  const MyTrip({
    required this.id,
    required this.vessel,
    required this.route,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
    this.tripId,
    this.bookingId,
    this.passengerName,
    this.passengerCpf,
    this.accommodationLabel,
    this.ticketStatus,
    this.paymentMethod,
    this.paymentStatus,
  });

  factory MyTrip.fromBooking(Map<String, Object?> json) {
    final route = (json['route'] as Map).cast<String, Object?>();
    final vessel = (route['vessel'] as Map?)?.cast<String, Object?>();
    final payment = (json['payment'] as Map?)?.cast<String, Object?>();
    final ticket = (json['ticket'] as Map?)?.cast<String, Object?>();
    final departureAt = DateTime.parse(
      route['departureAt'] as String,
    ).toLocal();
    final totalAmount = json['totalAmount'] as num;

    return MyTrip(
      id: ticket?['code'] as String? ?? json['id'] as String,
      tripId: route['tripId'] as String?,
      bookingId: json['id'] as String,
      vessel: vessel?['name'] as String? ?? 'Embarcação',
      route:
          '${_stopCity(route['originStop']) ?? _portCity(route['mainOrigin'])} -> ${_stopCity(route['destinationStop']) ?? _portCity(route['mainDestination'])}',
      date: _formatDate(departureAt),
      time: _formatTime(departureAt),
      status: _statusLabel(json['status'] as String),
      price: totalAmount.round(),
      passengerName: json['passengerName'] as String?,
      passengerCpf: json['passengerCpf'] as String?,
      accommodationLabel: _accommodationLabel(
        json['accommodationType'] as String?,
      ),
      ticketStatus: ticket?['status'] as String?,
      paymentMethod: _paymentMethodLabel(payment?['method'] as String?),
      paymentStatus: _paymentStatusLabel(payment?['status'] as String?),
    );
  }

  final String id;
  final String vessel;
  final String route;
  final String date;
  final String time;
  final String status;
  final int price;
  final String? tripId;
  final String? bookingId;
  final String? passengerName;
  final String? passengerCpf;
  final String? accommodationLabel;
  final String? ticketStatus;
  final String? paymentMethod;
  final String? paymentStatus;
}

String? _stopCity(Object? value) {
  final stop = (value as Map?)?.cast<String, Object?>();
  if (stop == null) return null;
  return _portCity(stop['port']);
}

String _portCity(Object? value) {
  final port = (value as Map?)?.cast<String, Object?>();
  if (port == null) return 'Porto';
  final city = port['city'] as String? ?? 'Porto';
  final state = port['state'] as String? ?? '';
  return state.isEmpty ? city : '$city/$state';
}

String _statusLabel(String status) {
  return switch (status) {
    'CONFIRMED' => 'confirmada',
    'CANCELLED' => 'cancelada',
    _ => 'pendente',
  };
}

String _accommodationLabel(String? value) {
  return switch (value) {
    'CABIN' => 'Camarote',
    'SEAT' => 'Poltrona',
    _ => 'Rede',
  };
}

String? _paymentMethodLabel(String? value) {
  return switch (value) {
    'CREDIT_CARD' => 'Cartão de crédito',
    'BOLETO' => 'Boleto',
    'PIX' => 'PIX',
    null => null,
    _ => value,
  };
}

String? _paymentStatusLabel(String? value) {
  return switch (value) {
    'APPROVED' => 'Aprovado',
    'PENDING' => 'Pendente',
    'REJECTED' => 'Recusado',
    'REFUNDED' => 'Reembolsado',
    null => null,
    _ => value,
  };
}

String _formatDate(DateTime value) {
  return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}

String _formatTime(DateTime value) {
  return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}
