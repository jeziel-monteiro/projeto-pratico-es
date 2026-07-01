import 'package:flutter/material.dart';
import 'package:porto_certo_tp4/app/app_state.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../data/purchase_draft.dart';
import '../widgets/purchase_widgets.dart';

class ApprovedScreen extends StatelessWidget {
  const ApprovedScreen({super.key, required this.nav, required this.draft});

  final AppNavigator nav;
  final PurchaseDraft draft;

  @override
  Widget build(BuildContext context) {
    return _PaymentResultScreen(
      icon: Icons.check_circle_outline,
      color: AppColors.success,
      title: 'Pagamento Aprovado!',
      message: 'Sua passagem foi confirmada. Boa viagem pela Amazônia!',
      nav: nav,
      primaryLabel: 'Ver Bilhete Digital',
      primaryTarget: AppScreen.ticket,
      draft: draft,
    );
  }
}

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  Widget build(BuildContext context) {
    return _PaymentResultScreen(
      icon: Icons.cancel_outlined,
      color: AppColors.danger,
      title: 'Pagamento Recusado',
      message:
          'Seu pagamento não foi processado. Verifique os dados ou escolha outra forma de pagamento.',
      nav: nav,
      primaryLabel: 'Tentar novamente',
      primaryTarget: AppScreen.payment,
    );
  }
}

class _PaymentResultScreen extends StatelessWidget {
  const _PaymentResultScreen({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.nav,
    required this.primaryLabel,
    required this.primaryTarget,
    this.draft,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final AppNavigator nav;
  final String primaryLabel;
  final AppScreen primaryTarget;
  final PurchaseDraft? draft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 52,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(icon, color: color, size: 58),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              if (draft != null)
                PcCard(
                  child: Column(
                    children: [
                      InfoLine(
                        label: 'Código de reserva',
                        value: draft!.reservationCode,
                      ),
                      InfoLine(label: 'Rota', value: draft!.routeLabel),
                      InfoLine(
                        label: 'Total pago',
                        value: formatMoney(draft!.paidTotal),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 18),
              PcButton(
                label: primaryLabel,
                icon: Icons.confirmation_number_outlined,
                full: true,
                onPressed: () => nav(primaryTarget),
              ),
              const SizedBox(height: 10),
              PcButton(
                label: 'Voltar para Início',
                full: true,
                variant: PcButtonVariant.outline,
                onPressed: () => nav(AppScreen.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
