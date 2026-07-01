import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/network/api_client.dart';
import 'purchase_draft.dart';

enum BookingPaymentMethod {
  pix('PIX', 'PIX'),
  creditCard('CREDIT_CARD', 'Cartão de crédito'),
  boleto('BOLETO', 'Boleto');

  const BookingPaymentMethod(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

class BookingRepository {
  BookingRepository({ApiClient? apiClient, FirebaseAuth? firebaseAuth})
    : _apiClient = apiClient ?? ApiClient(),
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  static const _useDevAuth = bool.fromEnvironment('PORTO_CERTO_USE_DEV_AUTH');

  final ApiClient _apiClient;
  final FirebaseAuth _firebaseAuth;

  Future<BookingConfirmation> createBooking({
    required PurchaseDraft draft,
    required BookingPaymentMethod paymentMethod,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const BookingRepositoryException(
        'Entre na sua conta para confirmar a reserva.',
      );
    }

    final originStopId = draft.departureStopId;
    final destinationStopId = draft.arrivalStopId;
    if (originStopId == null || destinationStopId == null) {
      throw const BookingRepositoryException(
        'Selecione uma viagem carregada pela API para concluir a reserva.',
      );
    }

    final idToken = _useDevAuth ? null : await user.getIdToken();
    final response =
        await _apiClient.postJson(
              'bookings',
              bearerToken: idToken,
              headers: _useDevAuth ? _devHeaders(user) : null,
              body: {
                'tripId': draft.trip.id,
                'originStopId': originStopId,
                'destinationStopId': destinationStopId,
                'passengerName': draft.passengerName,
                'passengerCpf': draft.passengerCpf,
                'accommodationType': _apiAccommodationType(draft),
                'paymentMethod': paymentMethod.apiValue,
              },
            )
            as Map<String, Object?>;
    final data = response['data'] as Map<String, Object?>;

    return BookingConfirmation.fromJson(data);
  }

  void close() {
    _apiClient.close();
  }

  Map<String, String> _devHeaders(User user) {
    return {
      'x-dev-firebase-uid': user.uid,
      if (user.email != null && user.email!.isNotEmpty)
        'x-dev-email': user.email!,
      if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
        'x-dev-phone': user.phoneNumber!,
      if (user.displayName != null && user.displayName!.isNotEmpty)
        'x-dev-name': user.displayName!,
    };
  }

  String _apiAccommodationType(PurchaseDraft draft) {
    return switch (draft.accommodationId) {
      'camarote' => 'CABIN',
      'poltrona' => 'SEAT',
      _ => 'HAMMOCK',
    };
  }
}

class BookingConfirmation {
  const BookingConfirmation({
    required this.id,
    required this.totalAmount,
    required this.ticketCode,
    required this.paymentMethod,
  });

  factory BookingConfirmation.fromJson(Map<String, Object?> json) {
    final ticket = json['ticket'] as Map<String, Object?>?;
    final payment = json['payment'] as Map<String, Object?>?;
    final totalAmount = json['totalAmount'] as num;

    return BookingConfirmation(
      id: json['id'] as String,
      totalAmount: totalAmount.round(),
      ticketCode: ticket?['code'] as String? ?? '',
      paymentMethod: payment?['method'] as String? ?? '',
    );
  }

  final String id;
  final int totalAmount;
  final String ticketCode;
  final String paymentMethod;
}

class BookingRepositoryException implements Exception {
  const BookingRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
