import 'dart:math' as math;

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
import '../widgets/purchase_widgets.dart';

class AccommodationScreen extends StatefulWidget {
  const AccommodationScreen({
    super.key,
    required this.nav,
    required this.draft,
    required this.onDraftChanged,
  });

  final AppNavigator nav;
  final PurchaseDraft draft;
  final ValueChanged<PurchaseDraft> onDraftChanged;

  @override
  State<AccommodationScreen> createState() => _AccommodationScreenState();
}

class _AccommodationScreenState extends State<AccommodationScreen> {
  late String _selected = widget.draft.accommodationId;

  @override
  void didUpdateWidget(covariant AccommodationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.draft.trip.id != widget.draft.trip.id) {
      _selected = widget.draft.accommodationId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final types = _accommodationTypes();
    final selected = types.any((item) => item.id == _selected)
        ? types.firstWhere((item) => item.id == _selected)
        : types.first;
    final total = widget.draft.fare + selected.price + widget.draft.serviceFee;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Escolher Acomodação',
            backTo: AppScreen.purchase,
            nav: widget.nav,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: ProgressSteps(
              labels: ['Passageiro', 'Acomodação', 'Pagamento'],
              current: 1,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Viagem Selecionada'),
                      InfoLine(
                        label: 'Embarcação',
                        value: widget.draft.trip.vessel,
                      ),
                      InfoLine(label: 'Rota', value: widget.draft.routeLabel),
                      InfoLine(
                        label: 'Vagas',
                        value: '${widget.draft.trip.seats} disponíveis',
                      ),
                    ],
                  ),
                ),
                ...types.map((item) {
                  final active = item.id == _selected;
                  return PcCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    border: Border.all(
                      color: active ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                    child: InkWell(
                      onTap: () => setState(() => _selected = item.id),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                item.icon,
                                color: AppColors.primary,
                                size: 34,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.label,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 12,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item.price == 0
                                        ? 'Incluso'
                                        : '+${formatMoney(item.price)}',
                                    style: TextStyle(
                                      color: item.price == 0
                                          ? AppColors.success
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    '${item.available} disponíveis',
                                    style: const TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (active) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.primary,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${item.label} selecionado - Total: ${formatMoney(total)}',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
                PcButton(
                  label: 'Confirmar - ${formatMoney(total)}',
                  icon: Icons.arrow_forward,
                  full: true,
                  onPressed: () {
                    widget.onDraftChanged(
                      widget.draft.copyWith(
                        accommodationId: selected.id,
                        accommodationLabel: selected.label,
                        accommodationPrice: selected.price,
                      ),
                    );
                    widget.nav(AppScreen.summary);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_AccommodationType> _accommodationTypes() {
    final amenities = widget.draft.trip.amenities
        .map((item) => item.toLowerCase())
        .toList();
    final seats = widget.draft.trip.seats;
    final types = <_AccommodationType>[
      _AccommodationType(
        id: 'rede',
        label: 'Rede',
        description:
            'Rede confortável no convés. Ventilação natural e visão privilegiada do rio.',
        price: 0,
        available: seats,
        icon: Icons.airline_seat_flat_angled,
      ),
    ];

    if (amenities.any((item) => item.contains('poltrona'))) {
      types.add(
        _AccommodationType(
          id: 'poltrona',
          label: 'Poltrona',
          description:
              'Assento numerado com encosto reclinável para viagens rápidas ou noturnas.',
          price: 40,
          available: math.max(1, seats ~/ 3),
          icon: Icons.airline_seat_recline_extra,
        ),
      );
    }

    if (amenities.any((item) => item.contains('camarote'))) {
      types.add(
        _AccommodationType(
          id: 'camarote',
          label: 'Camarote',
          description:
              'Cabine privativa com mais conforto para trajetos longos pela Amazônia.',
          price: 120,
          available: math.max(1, math.min(4, seats ~/ 8)),
          icon: Icons.meeting_room_outlined,
        ),
      );
    }

    return types;
  }
}

class _AccommodationType {
  const _AccommodationType({
    required this.id,
    required this.label,
    required this.description,
    required this.price,
    required this.available,
    required this.icon,
  });

  final String id;
  final String label;
  final String description;
  final int price;
  final int available;
  final IconData icon;
}
