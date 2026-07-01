import 'dart:async';

import 'package:flutter/material.dart';
import 'package:porto_certo_tp4/app/app_state.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/pc_text_field.dart';
import '../data/booking_repository.dart';
import '../data/purchase_draft.dart';
import '../widgets/purchase_widgets.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({
    super.key,
    required this.nav,
    required this.draft,
    required this.onDraftChanged,
  });

  final AppNavigator nav;
  final PurchaseDraft draft;
  final ValueChanged<PurchaseDraft> onDraftChanged;

  @override
  State<CreditCardScreen> createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  final _bookingRepository = BookingRepository();
  final _name = TextEditingController();
  final _number = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  final _errors = <String, String>{};
  bool _processing = false;
  String? _paymentError;

  @override
  void dispose() {
    _bookingRepository.close();
    _name.dispose();
    _number.dispose();
    _expiry.dispose();
    _cvv.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    _errors.clear();
    _paymentError = null;
    if (_name.text.trim().isEmpty) _errors['name'] = 'Nome obrigatório.';
    if (onlyDigits(_number.text).length < 16) {
      _errors['number'] = 'Número inválido.';
    }
    if (_expiry.text.length < 5) _errors['expiry'] = 'Data inválida.';
    if (_cvv.text.length < 3) _errors['cvv'] = 'CVV inválido.';
    if (_errors.isNotEmpty) {
      setState(() {});
      return;
    }
    setState(() => _processing = true);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      final confirmation = await _bookingRepository.createBooking(
        draft: widget.draft,
        paymentMethod: BookingPaymentMethod.creditCard,
      );
      widget.onDraftChanged(
        draftWithConfirmation(
          widget.draft,
          confirmation,
          BookingPaymentMethod.creditCard,
        ),
      );
      if (mounted) widget.nav(AppScreen.approved);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _paymentError = bookingErrorMessage(error);
        _processing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_processing) return const _ProcessingPaymentScreen();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Cartão de Crédito',
            backTo: AppScreen.payment,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.navy, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.22),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.waves, color: Colors.white70),
                          Spacer(),
                          Icon(Icons.credit_card, color: Colors.white70),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        _number.text.isEmpty
                            ? '•••• •••• •••• ••••'
                            : _number.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          letterSpacing: 2,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _CardLabel(
                              label: 'Nome',
                              value: _name.text.isEmpty
                                  ? 'NOME NO CARTÃO'
                                  : _name.text,
                            ),
                          ),
                          _CardLabel(
                            label: 'Validade',
                            value: _expiry.text.isEmpty
                                ? 'MM/AA'
                                : _expiry.text,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PaymentHint(
                  message:
                      'Taxa de 2% aplicada para pagamentos via cartão. Total: ${formatMoney(widget.draft.creditCardTotal)}',
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      PcTextField(
                        label: 'Nome no Cartão',
                        hint: 'Como está no cartão',
                        icon: Icons.person_outline,
                        controller: _name,
                        errorText: _errors['name'],
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      PcTextField(
                        label: 'Número do Cartão',
                        hint: '0000 0000 0000 0000',
                        icon: Icons.credit_card,
                        controller: _number,
                        errorText: _errors['number'],
                        keyboardType: TextInputType.number,
                        maxLength: 19,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: PcTextField(
                              label: 'Validade',
                              hint: 'MM/AA',
                              icon: Icons.calendar_month_outlined,
                              controller: _expiry,
                              errorText: _errors['expiry'],
                              maxLength: 5,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PcTextField(
                              label: 'CVV',
                              hint: '•••',
                              icon: Icons.shield_outlined,
                              controller: _cvv,
                              errorText: _errors['cvv'],
                              obscureText: true,
                              maxLength: 4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_paymentError != null) ...[
                  const SizedBox(height: 12),
                  DangerNotice(message: _paymentError!),
                ],
                const SizedBox(height: 16),
                PcButton(
                  label: 'Pagar ${formatMoney(widget.draft.creditCardTotal)}',
                  icon: Icons.arrow_forward,
                  full: true,
                  onPressed: _submit,
                ),
                const SizedBox(height: 10),
                PcButton(
                  label: 'Informar problema no pagamento',
                  full: true,
                  variant: PcButtonVariant.outline,
                  onPressed: () => widget.nav(AppScreen.rejected),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  const _CardLabel({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _ProcessingPaymentScreen extends StatelessWidget {
  const _ProcessingPaymentScreen();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colors.primary),
            const SizedBox(height: 18),
            const Text(
              'Processando pagamento...',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              'Aguarde, estamos verificando seus dados.',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
