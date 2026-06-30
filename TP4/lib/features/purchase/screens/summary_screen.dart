import 'package:flutter/material.dart';
import 'package:porto_certo_tp4/app/app_state.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/section_title.dart';
import '../data/purchase_draft.dart';
import '../widgets/purchase_widgets.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key, required this.nav, required this.draft});

  final AppNavigator nav;
  final PurchaseDraft draft;

  @override
  Widget build(BuildContext context) {
    final trip = draft.trip;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          AppHeader(
            title: 'Resumo da Compra',
            backTo: AppScreen.accommodation,
            nav: nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Detalhes da Viagem'),
                      InfoLine(label: 'Embarcação', value: trip.vessel),
                      InfoLine(label: 'Rota', value: draft.routeLabel),
                      InfoLine(label: 'Data', value: trip.date),
                      InfoLine(label: 'Horário', value: trip.time),
                      InfoLine(label: 'Duração', value: trip.duration),
                      InfoLine(
                        label: 'Acomodação',
                        value: draft.accommodationLabel,
                      ),
                      InfoLine(label: 'Embarque', value: draft.departureName),
                      InfoLine(label: 'Desembarque', value: draft.arrivalName),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Passageiro'),
                      InfoLine(label: 'Nome', value: draft.passengerName),
                      InfoLine(
                        label: 'CPF',
                        value: maskedCpf(draft.passengerCpf),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Valores'),
                      InfoLine(
                        label: 'Passagem',
                        value: formatMoney(draft.fare),
                      ),
                      InfoLine(
                        label: 'Acomodação',
                        value: draft.accommodationPrice == 0
                            ? 'Incluso'
                            : formatMoney(draft.accommodationPrice),
                      ),
                      InfoLine(
                        label: 'Taxa de serviço',
                        value: formatMoney(draft.serviceFee),
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          Text(
                            formatMoney(draft.total),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PcButton(
                  label: 'Ir para Pagamento',
                  icon: Icons.arrow_forward,
                  full: true,
                  onPressed: () => nav(AppScreen.payment),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
