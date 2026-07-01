import 'dart:async';

import 'package:flutter/material.dart';
import 'package:porto_certo_tp4/app/app_state.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../data/booking_repository.dart';
import '../data/purchase_draft.dart';
import '../widgets/purchase_widgets.dart';

class BoletoScreen extends StatefulWidget {
  const BoletoScreen({
    super.key,
    required this.nav,
    required this.draft,
    required this.onDraftChanged,
  });

  final AppNavigator nav;
  final PurchaseDraft draft;
  final ValueChanged<PurchaseDraft> onDraftChanged;

  @override
  State<BoletoScreen> createState() => _BoletoScreenState();
}

class _BoletoScreenState extends State<BoletoScreen> {
  final _bookingRepository = BookingRepository();
  bool _copied = false;
  bool _confirming = false;
  String? _error;

  @override
  void dispose() {
    _bookingRepository.close();
    super.dispose();
  }

  Future<void> _approve() async {
    if (_confirming) return;
    setState(() {
      _confirming = true;
      _error = null;
    });

    try {
      final confirmation = await _bookingRepository.createBooking(
        draft: widget.draft,
        paymentMethod: BookingPaymentMethod.boleto,
      );
      widget.onDraftChanged(
        draftWithConfirmation(
          widget.draft,
          confirmation,
          BookingPaymentMethod.boleto,
        ),
      );
      if (mounted) widget.nav(AppScreen.approved);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = bookingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Boleto Bancário',
            backTo: AppScreen.payment,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  child: Column(
                    children: [
                      Text(
                        formatMoney(widget.draft.total),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Vencimento: 26/06/2026',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _BarcodePlaceholder(amount: widget.draft.total),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: PcButton(
                              label: _copied ? 'Copiado' : 'Copiar código',
                              icon: _copied ? Icons.check : Icons.copy,
                              variant: PcButtonVariant.outline,
                              onPressed: () {
                                setState(() => _copied = true);
                                Future<void>.delayed(
                                  const Duration(seconds: 2),
                                  () {
                                    if (mounted) {
                                      setState(() => _copied = false);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: PcButton(
                              label: 'PDF',
                              icon: Icons.download_outlined,
                              variant: PcButtonVariant.teal,
                              onPressed: () => showFeaturePending(
                                context,
                                'Boleto em PDF será disponibilizado em breve.',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const PcCard(
                  child: Column(
                    children: [
                      InfoLine(
                        label: 'Beneficiário',
                        value: 'Porto Certo Viagens LTDA',
                      ),
                      InfoLine(label: 'CNPJ', value: '12.345.678/0001-90'),
                      InfoLine(label: 'Banco', value: 'Banco do Brasil'),
                      InfoLine(label: 'Agência', value: '0001-9'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const PaymentHint(
                  message:
                      'O boleto vence em 1 dia útil. Após o vencimento, a reserva é cancelada automaticamente.',
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  DangerNotice(message: _error!),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: PcButton(
                        label: _confirming
                            ? 'Confirmando...'
                            : 'Confirmar pagamento do boleto',
                        small: true,
                        loading: _confirming,
                        variant: PcButtonVariant.ghost,
                        onPressed: _approve,
                      ),
                    ),
                    Expanded(
                      child: PcButton(
                        label: 'Outro método',
                        small: true,
                        variant: PcButtonVariant.ghost,
                        onPressed: () => widget.nav(AppScreen.payment),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BarcodePlaceholder extends StatelessWidget {
  const _BarcodePlaceholder({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 64,
            child: CustomPaint(
              painter: _BarcodePainter(),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '23793.38128 60007.827136 96000.063305 6 ${amount.toString().padLeft(10, '0')}00',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black87;
    var x = 0.0;
    for (var i = 0; i < 78; i++) {
      final width = (i % 3 == 0) ? 3.0 : 1.5;
      final height = (i % 4 == 0) ? size.height * 0.78 : size.height;
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - height, width, height),
        paint,
      );
      x += width + 1.8;
      if (x > size.width) break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
