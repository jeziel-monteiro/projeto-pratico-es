import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:porto_certo_tp4/app/app_state.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/network_image_box.dart';
import '../../../core/widgets/pc_badge.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/pc_text_field.dart';
import '../../../core/widgets/progress_steps.dart';
import '../../../core/widgets/section_title.dart';
import '../../../models/route_stop.dart';
import '../data/purchase_draft.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({
    super.key,
    required this.nav,
    required this.draft,
    required this.onDraftChanged,
  });

  final AppNavigator nav;
  final PurchaseDraft draft;
  final ValueChanged<PurchaseDraft> onDraftChanged;

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final _name = TextEditingController();
  final _cpf = TextEditingController();
  final _errors = <String, String>{};
  int _departureIndex = 0;
  late int _arrivalIndex = _routeStops.length - 1;

  List<RouteStop> get _routeStops {
    final tripStops = widget.draft.trip.stops;
    if (tripStops.isEmpty) {
      return [
        RouteStop(
          name: widget.draft.trip.origin,
          priceMultiplier: 0,
          etaFromStart: 'Partida',
        ),
        RouteStop(
          name: widget.draft.trip.destination,
          priceMultiplier: 1,
          etaFromStart: widget.draft.trip.duration,
        ),
      ];
    }

    return tripStops
        .map(
          (stop) => RouteStop(
            id: stop.id,
            name: stop.label,
            priceMultiplier: stop.priceMultiplier,
            etaFromStart: stop.etaFromStart,
          ),
        )
        .toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _name.text = widget.draft.passengerName;
    _cpf.text = formatCpf(widget.draft.passengerCpf);
    _syncStopIndexesFromDraft();
  }

  @override
  void didUpdateWidget(covariant PurchaseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.draft.trip.id != widget.draft.trip.id) {
      _syncStopIndexesFromDraft();
      _name.text = widget.draft.passengerName;
      _cpf.text = formatCpf(widget.draft.passengerCpf);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _cpf.dispose();
    super.dispose();
  }

  int get _price {
    final trip = widget.draft.trip;
    final dep = _routeStops[_departureIndex];
    final arr = _routeStops[_arrivalIndex];
    return _priceFromStops(dep, arr, trip.price);
  }

  void _submit() {
    _errors.clear();
    if (_name.text.trim().isEmpty) _errors['name'] = 'Nome obrigatório.';
    if (onlyDigits(_cpf.text).length < 11) _errors['cpf'] = 'CPF inválido.';
    if (_errors.isNotEmpty) {
      setState(() {});
      return;
    }
    widget.onDraftChanged(
      widget.draft.copyWith(
        passengerName: _name.text.trim(),
        passengerCpf: onlyDigits(_cpf.text),
        departureStopId: _routeStops[_departureIndex].id,
        arrivalStopId: _routeStops[_arrivalIndex].id,
        departureName: _routeStops[_departureIndex].name,
        arrivalName: _routeStops[_arrivalIndex].name,
        fare: _price,
      ),
    );
    widget.nav(AppScreen.accommodation);
  }

  void _syncStopIndexesFromDraft() {
    final stops = _routeStops;
    final departureIndex = stops.indexWhere(
      (stop) => stop.id != null && stop.id == widget.draft.departureStopId,
    );
    final arrivalIndex = stops.indexWhere(
      (stop) => stop.id != null && stop.id == widget.draft.arrivalStopId,
    );

    _departureIndex = departureIndex >= 0 ? departureIndex : 0;
    _arrivalIndex = arrivalIndex > _departureIndex
        ? arrivalIndex
        : stops.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.draft.trip;
    final stops = _routeStops;
    final dep = stops[_departureIndex];
    final arr = stops[_arrivalIndex];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Dados da Viagem',
            backTo: AppScreen.results,
            nav: widget.nav,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: ProgressSteps(
              labels: ['Passageiro', 'Acomodação', 'Pagamento'],
              current: 0,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'Resumo da Viagem'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          NetworkImageBox(
                            url: trip.imageUrl,
                            width: 72,
                            height: 72,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trip.vessel,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${trip.origin} -> ${trip.destination}',
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    PcBadge(
                                      label: dep.name,
                                      tone: PcBadgeTone.blue,
                                    ),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.muted,
                                      size: 14,
                                    ),
                                    PcBadge(
                                      label: arr.name,
                                      tone: PcBadgeTone.green,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'R\$ $_price',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _StopTitle(
                        icon: Icons.place_outlined,
                        color: AppColors.primary,
                        title: 'Ponto de Embarque',
                        subtitle: 'Onde você entra na embarcação',
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(stops.length - 1, (index) {
                        return _StopButton(
                          stop: stops[index],
                          index: index,
                          selected: _departureIndex == index,
                          disabled: index >= _arrivalIndex,
                          onTap: () {
                            if (index >= _arrivalIndex) return;
                            setState(() => _departureIndex = index);
                          },
                        );
                      }),
                      const SizedBox(height: 18),
                      const _StopTitle(
                        icon: Icons.location_on_outlined,
                        color: AppColors.success,
                        title: 'Ponto de Desembarque',
                        subtitle: 'Onde você sai da embarcação',
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(stops.length - 1, (i) {
                        final index = i + 1;
                        return _StopButton(
                          stop: stops[index],
                          index: index,
                          selected: _arrivalIndex == index,
                          disabled: index <= _departureIndex,
                          price: index <= _departureIndex
                              ? null
                              : _priceFromStops(
                                  stops[_departureIndex],
                                  stops[index],
                                  trip.price,
                                ),
                          onTap: () {
                            if (index <= _departureIndex) return;
                            setState(() => _arrivalIndex = index);
                          },
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Dados do Passageiro'),
                      const SizedBox(height: 8),
                      PcTextField(
                        label: 'Nome Completo',
                        hint: 'Como no documento',
                        icon: Icons.person_outline,
                        controller: _name,
                        errorText: _errors['name'],
                      ),
                      const SizedBox(height: 14),
                      PcTextField(
                        label: 'CPF',
                        hint: '000.000.000-00',
                        icon: Icons.badge_outlined,
                        controller: _cpf,
                        maxLength: 14,
                        keyboardType: TextInputType.number,
                        errorText: _errors['cpf'],
                        onChanged: (value) {
                          final formatted = formatCpf(value);
                          if (formatted != value) {
                            _cpf.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(
                                offset: formatted.length,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PcButton(
                  label: 'Escolher Acomodação',
                  icon: Icons.arrow_forward,
                  full: true,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _priceFromStops(RouteStop dep, RouteStop arr, int basePrice) {
    final departureBasisPoints = (dep.priceMultiplier * 10000).round();
    final arrivalBasisPoints = (arr.priceMultiplier * 10000).round();
    final diffBasisPoints = math.max(
      0,
      arrivalBasisPoints - departureBasisPoints,
    );
    return math.max(
      ((basePrice * diffBasisPoints) / 10000).round(),
      (basePrice * 0.1).round(),
    );
  }
}

class _StopTitle extends StatelessWidget {
  const _StopTitle({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 13),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StopButton extends StatelessWidget {
  const _StopButton({
    required this.stop,
    required this.index,
    required this.selected,
    required this.disabled,
    required this.onTap,
    this.price,
  });

  final RouteStop stop;
  final int index;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;
  final int? price;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled ? 0.42 : 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.06)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.8 : 1,
            ),
          ),
          child: InkWell(
            onTap: disabled ? null : onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(11),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: selected
                        ? AppColors.primary
                        : const Color(0xFFF3F4F6),
                    child: selected
                        ? const Icon(Icons.check, size: 15, color: Colors.white)
                        : Text(
                            '$index',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          stop.etaFromStart == 'Partida'
                              ? 'Origem da rota'
                              : '${stop.etaFromStart} do início',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (price != null)
                    Text(
                      'R\$ $price',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
