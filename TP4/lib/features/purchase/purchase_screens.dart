import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../app/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/network/api_exception.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/network_image_box.dart';
import '../../core/widgets/pc_badge.dart';
import '../../core/widgets/pc_button.dart';
import '../../core/widgets/pc_card.dart';
import '../../core/widgets/pc_text_field.dart';
import '../../core/widgets/progress_steps.dart';
import '../../core/widgets/section_title.dart';
import '../../models/my_trip.dart';
import '../../models/route_stop.dart';
import 'data/booking_repository.dart';
import 'data/purchase_draft.dart';
import '../travel/data/my_trips_repository.dart';

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
      backgroundColor: AppColors.surface,
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
      backgroundColor: AppColors.surface,
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
                      _InfoLine(
                        label: 'Embarcação',
                        value: widget.draft.trip.vessel,
                      ),
                      _InfoLine(label: 'Rota', value: widget.draft.routeLabel),
                      _InfoLine(
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
                      _InfoLine(label: 'Embarcação', value: trip.vessel),
                      _InfoLine(label: 'Rota', value: draft.routeLabel),
                      _InfoLine(label: 'Data', value: trip.date),
                      _InfoLine(label: 'Horário', value: trip.time),
                      _InfoLine(label: 'Duração', value: trip.duration),
                      _InfoLine(
                        label: 'Acomodação',
                        value: draft.accommodationLabel,
                      ),
                      _InfoLine(label: 'Embarque', value: draft.departureName),
                      _InfoLine(label: 'Desembarque', value: draft.arrivalName),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Passageiro'),
                      _InfoLine(label: 'Nome', value: draft.passengerName),
                      _InfoLine(
                        label: 'CPF',
                        value: _maskedCpf(draft.passengerCpf),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Valores'),
                      _InfoLine(
                        label: 'Passagem',
                        value: formatMoney(draft.fare),
                      ),
                      _InfoLine(
                        label: 'Acomodação',
                        value: draft.accommodationPrice == 0
                            ? 'Incluso'
                            : formatMoney(draft.accommodationPrice),
                      ),
                      _InfoLine(
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
      backgroundColor: AppColors.surface,
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
        _draftWithConfirmation(
          widget.draft,
          confirmation,
          BookingPaymentMethod.pix,
        ),
      );
      if (mounted) widget.nav(AppScreen.approved);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _bookingErrorMessage(error));
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
                      const _PaymentHint(
                        message:
                            'Após o pagamento, a confirmação é automática. Não feche este app.',
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        _DangerNotice(message: _error!),
                      ],
                      const SizedBox(height: 14),
                      PcButton(
                        label: _confirming
                            ? 'Confirmando reserva...'
                            : 'Simular Pagamento Aprovado',
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
        _draftWithConfirmation(
          widget.draft,
          confirmation,
          BookingPaymentMethod.boleto,
        ),
      );
      if (mounted) widget.nav(AppScreen.approved);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = _bookingErrorMessage(error));
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
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
                              onPressed: () {},
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
                      _InfoLine(
                        label: 'Beneficiário',
                        value: 'Porto Certo Viagens LTDA',
                      ),
                      _InfoLine(label: 'CNPJ', value: '12.345.678/0001-90'),
                      _InfoLine(label: 'Banco', value: 'Banco do Brasil'),
                      _InfoLine(label: 'Agência', value: '0001-9'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const _PaymentHint(
                  message:
                      'O boleto vence em 1 dia útil. Após o vencimento, a reserva é cancelada automaticamente.',
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  _DangerNotice(message: _error!),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: PcButton(
                        label: _confirming
                            ? 'Confirmando...'
                            : 'Simular Aprovação',
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
        _draftWithConfirmation(
          widget.draft,
          confirmation,
          BookingPaymentMethod.creditCard,
        ),
      );
      if (mounted) widget.nav(AppScreen.approved);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _paymentError = _bookingErrorMessage(error);
        _processing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_processing) return const _ProcessingPaymentScreen();
    return Scaffold(
      backgroundColor: AppColors.surface,
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
                _PaymentHint(
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
                  _DangerNotice(message: _paymentError!),
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
                  label: 'Simular Recusa',
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

class TicketScreen extends StatefulWidget {
  const TicketScreen({
    super.key,
    required this.nav,
    required this.draft,
    this.booking,
  });

  final AppNavigator nav;
  final PurchaseDraft draft;
  final MyTrip? booking;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _myTripsRepository = MyTripsRepository();
  bool _cancelled = false;
  bool _cancelling = false;
  String? _cancelError;

  @override
  void dispose() {
    _myTripsRepository.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    if (booking != null) {
      return _BookingTicketScreen(nav: widget.nav, booking: booking);
    }

    final policy = _policyFor();

    if (_cancelled) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: Column(
          children: [
            AppHeader(
              title: 'Cancelamento Confirmado',
              backTo: AppScreen.home,
              nav: widget.nav,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  PcCard(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 38,
                          backgroundColor: Color(0xFFE8F8F1),
                          child: Icon(
                            Icons.check,
                            color: AppColors.success,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Reserva cancelada',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          policy.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.muted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  PcCard(
                    child: Column(
                      children: [
                        const SectionTitle(
                          title: 'Comprovante de Cancelamento',
                        ),
                        _InfoLine(
                          label: 'Protocolo',
                          value: _cancellationProtocol,
                        ),
                        _InfoLine(
                          label: 'Reserva',
                          value: widget.draft.reservationCode,
                        ),
                        _InfoLine(
                          label: 'Passageiro',
                          value: widget.draft.passengerName,
                        ),
                        _InfoLine(label: 'Retenção', value: policy.feeLabel),
                        _InfoLine(
                          label: 'Valor a estornar',
                          value: policy.refund,
                        ),
                        _InfoLine(
                          label: 'Prazo do estorno',
                          value: policy.deadline,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  PcButton(
                    label: 'Voltar para Início',
                    full: true,
                    onPressed: () => widget.nav(AppScreen.home),
                  ),
                  const SizedBox(height: 10),
                  PcButton(
                    label: 'Buscar nova viagem',
                    icon: Icons.search,
                    full: true,
                    variant: PcButtonVariant.outline,
                    onPressed: () => widget.nav(AppScreen.search),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          AppHeader(
            title: 'Bilhete Digital',
            backTo: AppScreen.home,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _TicketCard(
                  draft: widget.draft,
                  payment: widget.draft.paymentLabel,
                ),
                const SizedBox(height: 12),
                if (_cancelError != null) ...[
                  _DangerNotice(message: _cancelError!),
                  const SizedBox(height: 12),
                ],
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: policy.free
                        ? const Color(0xFFE8F8F1)
                        : AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: policy.free
                          ? AppColors.success.withValues(alpha: 0.35)
                          : AppColors.accent.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: policy.free
                            ? AppColors.success
                            : const Color(0xFFB77900),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          policy.description,
                          style: TextStyle(
                            color: policy.free
                                ? const Color(0xFF047857)
                                : const Color(0xFFB77900),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: PcButton(
                        label: 'Baixar PDF',
                        icon: Icons.download_outlined,
                        variant: PcButtonVariant.outline,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PcButton(
                        label: 'Compartilhar',
                        icon: Icons.share_outlined,
                        variant: PcButtonVariant.teal,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                PcButton(
                  label: 'Rastrear Embarcação em Tempo Real',
                  icon: Icons.navigation_outlined,
                  full: true,
                  variant: PcButtonVariant.secondary,
                  onPressed: () => widget.nav(AppScreen.tracking),
                ),
                const SizedBox(height: 10),
                PcButton(
                  label: _cancelling ? 'Cancelando...' : 'Cancelar Reserva',
                  icon: Icons.cancel_outlined,
                  full: true,
                  variant: PcButtonVariant.danger,
                  loading: _cancelling,
                  onPressed: () => _confirmCancel(policy),
                ),
                const SizedBox(height: 12),
                const PcCard(
                  child: Row(
                    children: [
                      Icon(Icons.wifi, color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bilhete disponível offline. Salvo automaticamente no seu dispositivo.',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(_CancelPolicy policy) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFFFE4E9),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.danger,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cancelar Reserva?',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Text(
                          'Esta ação não pode ser desfeita.',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _InfoLine(
                label: 'Valor pago',
                value: formatMoney(widget.draft.paidTotal),
              ),
              _InfoLine(label: 'Multa aplicada', value: policy.feeLabel),
              _InfoLine(label: 'Você recebe', value: policy.refund),
              _InfoLine(label: 'Prazo de estorno', value: policy.deadline),
              const SizedBox(height: 14),
              PcButton(
                label: _cancelling ? 'Cancelando...' : 'Confirmar Cancelamento',
                full: true,
                variant: PcButtonVariant.danger,
                loading: _cancelling,
                onPressed: () {
                  Navigator.pop(context);
                  _cancelDraftBooking();
                },
              ),
              const SizedBox(height: 10),
              PcButton(
                label: 'Manter minha reserva',
                full: true,
                variant: PcButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _cancelDraftBooking() async {
    final bookingId = widget.draft.bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      setState(() {
        _cancelError =
            'Não foi possível identificar a reserva para cancelamento.';
      });
      return;
    }

    setState(() {
      _cancelling = true;
      _cancelError = null;
    });

    try {
      await _myTripsRepository.cancelBooking(bookingId);
      if (!mounted) return;
      setState(() {
        _cancelled = true;
        _cancelling = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _cancelError = _reservationActionErrorMessage(error);
        _cancelling = false;
      });
    }
  }

  String get _cancellationProtocol {
    final source = widget.draft.bookingId ?? widget.draft.reservationCode;
    final normalized = source.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final suffix = normalized.length > 8
        ? normalized.substring(normalized.length - 8)
        : normalized.padLeft(8, '0');
    return '#CNC-${suffix.toUpperCase()}';
  }

  _CancelPolicy _policyFor() {
    final total = widget.draft.paidTotal;
    return _CancelPolicy(
      true,
      'Cancelamento disponível pelo app. Após confirmar, a reserva será cancelada e o pagamento ficará como reembolsado.',
      'Nenhuma',
      formatMoney(total),
      'até 5 dias úteis',
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

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

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

String _maskedCpf(String cpf) {
  final digits = onlyDigits(cpf);
  if (digits.length != 11) return '***.***.***-**';
  return '***.***.${digits.substring(6, 9)}-${digits.substring(9)}';
}

String _portCode(String city) {
  final normalized = city
      .replaceAll('/', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .join();
  final upper = normalized.toUpperCase();
  if (upper.length <= 3) return upper.padRight(3, 'X');
  return upper.substring(0, 3);
}

PurchaseDraft _draftWithConfirmation(
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

String _bookingErrorMessage(Object error) {
  if (error is BookingRepositoryException) return error.message;
  if (error is ApiException) return error.message;
  return 'Nao foi possivel confirmar a reserva. Tente novamente.';
}

String _reservationActionErrorMessage(Object error) {
  if (error is MyTripsRepositoryException) return error.message;
  if (error is ApiException) return error.message;
  return 'Não foi possível completar esta operação.';
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

class _PaymentHint extends StatelessWidget {
  const _PaymentHint({required this.message});

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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 18),
            Text(
              'Processando pagamento...',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 6),
            Text(
              'Aguarde, estamos verificando seus dados.',
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
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
      backgroundColor: Colors.white,
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
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 18),
              if (draft != null)
                PcCard(
                  child: Column(
                    children: [
                      _InfoLine(
                        label: 'Código de reserva',
                        value: draft!.reservationCode,
                      ),
                      _InfoLine(label: 'Rota', value: draft!.routeLabel),
                      _InfoLine(
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

class _BookingTicketScreen extends StatefulWidget {
  const _BookingTicketScreen({required this.nav, required this.booking});

  final AppNavigator nav;
  final MyTrip booking;

  @override
  State<_BookingTicketScreen> createState() => _BookingTicketScreenState();
}

class _BookingTicketScreenState extends State<_BookingTicketScreen> {
  final _repository = MyTripsRepository();
  late MyTrip _booking;
  bool _cancelling = false;
  bool _cancelledNow = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = _booking;
    final routeParts = booking.route.split(' -> ');
    final origin = routeParts.isNotEmpty ? routeParts.first : 'Origem';
    final destination = routeParts.length > 1 ? routeParts.last : 'Destino';
    final confirmed = booking.status == 'confirmada';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          AppHeader(
            title: 'Bilhete Digital',
            backTo: AppScreen.myTrips,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_error != null) ...[
                  _DangerNotice(message: _error!),
                  const SizedBox(height: 12),
                ],
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.navy, AppColors.primary],
                          ),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.waves, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PORTO CERTO VIAGENS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    'Bilhete Eletrônico',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PcBadge(
                              label: confirmed ? 'Confirmado' : 'Cancelado',
                              tone: confirmed
                                  ? PcBadgeTone.orange
                                  : PcBadgeTone.red,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _Airport(
                                    code: _portCode(origin),
                                    city: origin,
                                  ),
                                ),
                                const Column(
                                  children: [
                                    Divider(),
                                    Icon(
                                      Icons.anchor,
                                      color: AppColors.primary,
                                    ),
                                    Divider(),
                                  ],
                                ),
                                Expanded(
                                  child: _Airport(
                                    code: _portCode(destination),
                                    city: destination,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: _TicketInfo(
                                    label: 'Data',
                                    value: booking.date,
                                  ),
                                ),
                                Expanded(
                                  child: _TicketInfo(
                                    label: 'Embarque',
                                    value: booking.time,
                                  ),
                                ),
                                Expanded(
                                  child: _TicketInfo(
                                    label: 'Acomodação',
                                    value: booking.accommodationLabel ?? 'Rede',
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 28, color: AppColors.border),
                            if (booking.passengerName != null)
                              _InfoLine(
                                label: 'Passageiro',
                                value: booking.passengerName!,
                              ),
                            if (booking.passengerCpf != null)
                              _InfoLine(
                                label: 'CPF',
                                value: _maskedCpf(booking.passengerCpf!),
                              ),
                            _InfoLine(
                              label: 'Embarcação',
                              value: booking.vessel,
                            ),
                            _InfoLine(label: 'Bilhete', value: booking.id),
                            if (booking.bookingId != null)
                              _InfoLine(
                                label: 'Reserva',
                                value: booking.bookingId!,
                              ),
                            if (booking.paymentMethod != null)
                              _InfoLine(
                                label: 'Pagamento',
                                value: booking.paymentMethod!,
                              ),
                            if (booking.paymentStatus != null)
                              _InfoLine(
                                label: 'Status pagamento',
                                value: booking.paymentStatus!,
                              ),
                            _InfoLine(
                              label: 'Total',
                              value: formatMoney(booking.price),
                            ),
                            const SizedBox(height: 14),
                            const _QrPlaceholder(size: 128),
                            const SizedBox(height: 8),
                            const Text(
                              'Apresente este QR Code no embarque',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (_cancelledNow) ...[
                  const PcCard(
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Reserva cancelada com sucesso. O pagamento foi marcado como reembolsado.',
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Expanded(
                      child: PcButton(
                        label: 'Baixar PDF',
                        icon: Icons.download_outlined,
                        variant: PcButtonVariant.outline,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PcButton(
                        label: 'Compartilhar',
                        icon: Icons.share_outlined,
                        variant: PcButtonVariant.teal,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (confirmed) ...[
                  PcButton(
                    label: 'Rastrear Embarcação em Tempo Real',
                    icon: Icons.navigation_outlined,
                    full: true,
                    variant: PcButtonVariant.secondary,
                    onPressed: () => widget.nav(AppScreen.tracking),
                  ),
                  const SizedBox(height: 10),
                  PcButton(
                    label: _cancelling ? 'Cancelando...' : 'Cancelar Reserva',
                    icon: Icons.cancel_outlined,
                    full: true,
                    variant: PcButtonVariant.danger,
                    loading: _cancelling,
                    onPressed: _confirmCancel,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancelar reserva?'),
          content: const Text(
            'A reserva será cancelada e a vaga voltará a ficar disponível para outros passageiros.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Manter'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Cancelar reserva'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final bookingId = _booking.bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      setState(() {
        _error = 'Não foi possível identificar a reserva para cancelamento.';
      });
      return;
    }

    setState(() {
      _cancelling = true;
      _cancelledNow = false;
      _error = null;
    });

    try {
      final updated = await _repository.cancelBooking(bookingId);
      if (!mounted) return;
      setState(() {
        _booking = updated;
        _cancelling = false;
        _cancelledNow = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _reservationActionErrorMessage(error);
        _cancelling = false;
      });
    }
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.draft, required this.payment});

  final PurchaseDraft draft;
  final String payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.navy, AppColors.primary],
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.waves, color: Colors.white),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PORTO CERTO VIAGENS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Bilhete Eletrônico',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                PcBadge(label: 'Confirmado', tone: PcBadgeTone.orange),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Airport(
                        code: _portCode(draft.departureName),
                        city: draft.departureName,
                      ),
                    ),
                    const Column(
                      children: [
                        Divider(),
                        Icon(Icons.anchor, color: AppColors.primary),
                        Divider(),
                      ],
                    ),
                    Expanded(
                      child: _Airport(
                        code: _portCode(draft.arrivalName),
                        city: draft.arrivalName,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _TicketInfo(label: 'Data', value: draft.trip.date),
                    ),
                    Expanded(
                      child: _TicketInfo(
                        label: 'Embarque',
                        value: draft.trip.time,
                      ),
                    ),
                    Expanded(
                      child: _TicketInfo(
                        label: 'Acomodação',
                        value: draft.accommodationLabel,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 28, color: AppColors.border),
                _InfoLine(label: 'Passageiro', value: draft.passengerName),
                _InfoLine(label: 'CPF', value: _maskedCpf(draft.passengerCpf)),
                _InfoLine(label: 'Embarcação', value: draft.trip.vessel),
                _InfoLine(label: 'Reserva', value: draft.reservationCode),
                _InfoLine(label: 'Pagamento', value: payment),
                const SizedBox(height: 14),
                const _QrPlaceholder(size: 128),
                const SizedBox(height: 8),
                const Text(
                  'Apresente este QR Code no embarque',
                  style: TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Airport extends StatelessWidget {
  const _Airport({required this.code, required this.city});

  final String code;
  final String city;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          code,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28),
        ),
        Text(
          city,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ],
    );
  }
}

class _TicketInfo extends StatelessWidget {
  const _TicketInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _DangerNotice extends StatelessWidget {
  const _DangerNotice({required this.message});

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

class _CancelPolicy {
  const _CancelPolicy(
    this.free,
    this.description,
    this.feeLabel,
    this.refund,
    this.deadline,
  );

  final bool free;
  final String description;
  final String feeLabel;
  final String refund;
  final String deadline;
}
