import '../../../models/trip.dart';

class PurchaseDraft {
  const PurchaseDraft({
    required this.trip,
    required this.passengerName,
    required this.passengerCpf,
    required this.departureStopId,
    required this.arrivalStopId,
    required this.departureName,
    required this.arrivalName,
    required this.fare,
    required this.accommodationId,
    required this.accommodationLabel,
    required this.accommodationPrice,
    this.bookingId,
    this.ticketCode,
    this.paymentMethod,
    this.confirmedTotal,
  });

  factory PurchaseDraft.fromTrip(Trip trip) {
    final firstStop = trip.stops.isEmpty ? null : trip.stops.first;
    final lastStop = trip.stops.isEmpty ? null : trip.stops.last;

    return PurchaseDraft(
      trip: trip,
      passengerName: '',
      passengerCpf: '',
      departureStopId: firstStop?.id,
      arrivalStopId: lastStop?.id,
      departureName: firstStop?.label ?? trip.origin,
      arrivalName: lastStop?.label ?? trip.destination,
      fare: trip.price,
      accommodationId: 'rede',
      accommodationLabel: 'Rede',
      accommodationPrice: 0,
    );
  }

  final Trip trip;
  final String passengerName;
  final String passengerCpf;
  final String? departureStopId;
  final String? arrivalStopId;
  final String departureName;
  final String arrivalName;
  final int fare;
  final String accommodationId;
  final String accommodationLabel;
  final int accommodationPrice;
  final String? bookingId;
  final String? ticketCode;
  final String? paymentMethod;
  final int? confirmedTotal;

  int get serviceFee => 5;

  int get total => fare + accommodationPrice + serviceFee;

  int get creditCardTotal => (total * 1.02).round();

  int get paidTotal => confirmedTotal ?? total;

  String get reservationCode => ticketCode ?? '#PCB-20260704-0001';

  String get paymentLabel => paymentMethod ?? 'PIX';

  String get routeLabel => '$departureName -> $arrivalName';

  PurchaseDraft copyWith({
    Trip? trip,
    String? passengerName,
    String? passengerCpf,
    String? departureStopId,
    String? arrivalStopId,
    String? departureName,
    String? arrivalName,
    int? fare,
    String? accommodationId,
    String? accommodationLabel,
    int? accommodationPrice,
    String? bookingId,
    String? ticketCode,
    String? paymentMethod,
    int? confirmedTotal,
  }) {
    return PurchaseDraft(
      trip: trip ?? this.trip,
      passengerName: passengerName ?? this.passengerName,
      passengerCpf: passengerCpf ?? this.passengerCpf,
      departureStopId: departureStopId ?? this.departureStopId,
      arrivalStopId: arrivalStopId ?? this.arrivalStopId,
      departureName: departureName ?? this.departureName,
      arrivalName: arrivalName ?? this.arrivalName,
      fare: fare ?? this.fare,
      accommodationId: accommodationId ?? this.accommodationId,
      accommodationLabel: accommodationLabel ?? this.accommodationLabel,
      accommodationPrice: accommodationPrice ?? this.accommodationPrice,
      bookingId: bookingId ?? this.bookingId,
      ticketCode: ticketCode ?? this.ticketCode,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      confirmedTotal: confirmedTotal ?? this.confirmedTotal,
    );
  }
}

String formatMoney(int value) => 'R\$ ${value.toString()},00';
