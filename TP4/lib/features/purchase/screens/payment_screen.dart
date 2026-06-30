import 'dart:async';

import 'package:flutter/material.dart';
import 'package:porto_certo_tp4/app/app_state.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/progress_steps.dart';
import '../../../core/widgets/section_title.dart';
import '../data/purchase_draft.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.nav, required this.draft});

  final AppNavigator nav;
  final PurchaseDraft draft;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'pix';
  bool _loading = false;

  void _go() {
    setState(() => _loading = true);
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      widget.nav(switch (_method) {
        'credit' => AppScreen.creditCard,
        'boleto' => AppScreen.boleto,
        _ => AppScreen.pix,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final methods = const [
      _PaymentMethod(
        id: 'pix',
        title: 'PIX',
        subtitle: 'Aprovação instantânea - Sem taxas',
        icon: Icons.qr_code_2,
      ),
      _PaymentMethod(
        id: 'credit',
        title: 'Cartão de Crédito',
        subtitle: 'Taxa de 2% sobre o valor total',
        icon: Icons.credit_card,
      ),
      _PaymentMethod(
        id: 'boleto',
        title: 'Boleto Bancário',
        subtitle: 'Vencimento em 1 dia útil - Sem taxas',
        icon: Icons.description_outlined,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Forma de Pagamento',
            backTo: AppScreen.summary,
            nav: widget.nav,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: ProgressSteps(
              labels: ['Passageiro', 'Acomodação', 'Pagamento'],
              current: 2,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Total a pagar',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            formatMoney(widget.draft.total),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      const Divider(height: 26),
                      const SectionTitle(title: 'Selecione o método'),
                      const SizedBox(height: 8),
                      ...methods.map((method) {
                        final active = method.id == _method;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _PaymentTile(
                            method: method,
                            active: active,
                            onTap: () => setState(() => _method = method.id),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PcButton(
                  label: _loading ? 'Processando...' : 'Confirmar Pagamento',
                  full: true,
                  loading: _loading,
                  onPressed: _go,
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.muted,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Ambiente seguro - dados protegidos com SSL',
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
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

class _PaymentMethod {
  const _PaymentMethod({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.method,
    required this.active,
    required this.onTap,
  });

  final _PaymentMethod method;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: active ? AppColors.primary : AppColors.border,
          width: active ? 1.8 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: active
                    ? AppColors.primary
                    : const Color(0xFFF3F4F6),
                child: Icon(
                  method.icon,
                  color: active ? Colors.white : AppColors.muted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      method.subtitle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                active ? Icons.radio_button_checked : Icons.radio_button_off,
                color: active ? AppColors.primary : AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
