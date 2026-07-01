import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../travel/data/my_trips_repository.dart';
import '../data/booking_repository.dart';
import '../data/purchase_draft.dart';

class InfoLine extends StatelessWidget {
  const InfoLine({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class DangerNotice extends StatelessWidget {
  const DangerNotice({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE4E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentHint extends StatelessWidget {
  const PaymentHint({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFB77900),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFB77900),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showFeaturePending(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

String maskedCpf(String cpf) {
  final digits = onlyDigits(cpf);
  if (digits.length != 11) return '***.***.***-**';
  return '***.***.${digits.substring(6, 9)}-${digits.substring(9)}';
}

PurchaseDraft draftWithConfirmation(
  PurchaseDraft draft,
  BookingConfirmation confirmation,
  BookingPaymentMethod paymentMethod,
) {
  return draft.copyWith(
    bookingId: confirmation.id,
    ticketCode: confirmation.ticketCode,
    paymentMethod: paymentMethod.label,
    confirmedTotal: confirmation.totalAmount,
  );
}

String bookingErrorMessage(Object error) {
  if (error is BookingRepositoryException) return error.message;
  if (error is ApiException) return error.message;
  return 'Nao foi possivel confirmar a reserva. Tente novamente.';
}

String reservationActionErrorMessage(Object error) {
  if (error is MyTripsRepositoryException) return error.message;
  if (error is ApiException) return error.message;
  return 'Não foi possível completar esta operação.';
}
