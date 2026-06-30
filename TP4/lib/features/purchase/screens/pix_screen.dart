import 'dart:async';

import 'package:flutter/material.dart';
import 'package:porto_certo_tp4/app/app_state.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_badge.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../data/booking_repository.dart';
import '../data/purchase_draft.dart';
import '../widgets/purchase_widgets.dart';

class PixScreen extends StatefulWidget {
  const PixScreen({
    super.key,
    required this.nav,
    required this.draft,
    required this.onDraftChanged,
  });

  final AppNavigator nav;
  final PurchaseDraft draft;
  final ValueChanged<PurchaseDraft> onDraftChanged;

  @override
  State<PixScreen> createState() => _PixScreenState();
}

class _PixScreenState extends State<PixScreen> {
  final _bookingRepository = BookingRepository();
  Timer? _timer;
  int _seconds = 600;
  bool _copied = false;
  bool _confirming = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
        paymentMethod: BookingPaymentMethod.pix,
      );
      widget.onDraftChanged(
        draftWithConfirmation(
          widget.draft,
          confirmation,
          BookingPaymentMethod.pix,
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
    final expired = _seconds == 0;
    final mm = (_seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (_seconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          AppHeader(
            title: 'Pagar com PIX',
            backTo: AppScreen.payment,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: expired
                  ? [
                      PcCard(
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 36,
                              backgroundColor: Color(0xFFFFE4E9),
                              child: Icon(
                                Icons.cancel_outlined,
                                color: AppColors.danger,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'PIX Expirado',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'O tempo para pagamento expirou. Gere um novo código para continuar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.muted),
                            ),
                            const SizedBox(height: 16),
                            PcButton(
                              label: 'Gerar Novo PIX',
                              icon: Icons.refresh,
                              full: true,
                              onPressed: () => setState(() => _seconds = 600),
                            ),
                          ],
                        ),
                      ),
                    ]
                  : [
                      PcCard(
                        child: Column(
                          children: [
                            PcBadge(
                              label: '$mm:$ss',
                              tone: _seconds <= 60
                                  ? PcBadgeTone.red
                                  : PcBadgeTone.orange,
                            ),
                            const SizedBox(height: 18),
                            const _QrPlaceholder(size: 190),
                            const SizedBox(height: 14),
                            Text(
                              formatMoney(widget.draft.total),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: AppColors.primary),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Abra seu banco e escaneie o QR Code para pagar',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      PcCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Código Copia e Cola',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      '00020126330014BR.GOV.BCB.PIX011192837645152040000...',
                                      style: TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 11,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                  PcButton(
                                    label: _copied ? 'Copiado' : 'Copiar',
                                    icon: _copied ? Icons.check : Icons.copy,
                                    small: true,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const PaymentHint(
                        message:
                            'Após o pagamento, a confirmação é automática. Não feche este app.',
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        DangerNotice(message: _error!),
                      ],
                      const SizedBox(height: 14),
                      PcButton(
                        label: _confirming
                            ? 'Confirmando reserva...'
                            : 'Confirmar pagamento PIX',
                        full: true,
                        loading: _confirming,
                        variant: PcButtonVariant.ghost,
                        onPressed: _approve,
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: CustomPaint(painter: _QrPainter()),
    );
  }
}

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    const cells = 17;
    final cell = size.width / cells;
    for (var row = 0; row < cells; row++) {
      for (var col = 0; col < cells; col++) {
        final draw =
            (row * 31 + col * 17) % 5 < 2 ||
            (row < 5 && col < 5) ||
            (row < 5 && col > 11) ||
            (row > 11 && col < 5);
        if (draw) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(col * cell, row * cell, cell * 0.82, cell * 0.82),
              const Radius.circular(2),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
