import 'package:flutter/material.dart';
import 'package:porto_certo_tp4/app/app_state.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_badge.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../models/my_trip.dart';
import '../../travel/data/my_trips_repository.dart';
import '../data/purchase_draft.dart';
import '../widgets/purchase_widgets.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        InfoLine(
                          label: 'Protocolo',
                          value: _cancellationProtocol,
                        ),
                        InfoLine(
                          label: 'Reserva',
                          value: widget.draft.reservationCode,
                        ),
                        InfoLine(
                          label: 'Passageiro',
                          value: widget.draft.passengerName,
                        ),
                        InfoLine(label: 'Retenção', value: policy.feeLabel),
                        InfoLine(
                          label: 'Valor a estornar',
                          value: policy.refund,
                        ),
                        InfoLine(
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  DangerNotice(message: _cancelError!),
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
                        onPressed: () => showFeaturePending(
                          context,
                          'PDF do bilhete será disponibilizado em breve.',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PcButton(
                        label: 'Compartilhar',
                        icon: Icons.share_outlined,
                        variant: PcButtonVariant.teal,
                        onPressed: () => showFeaturePending(
                          context,
                          'Compartilhamento do bilhete será disponibilizado em breve.',
                        ),
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
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
              InfoLine(
                label: 'Valor pago',
                value: formatMoney(widget.draft.paidTotal),
              ),
              InfoLine(label: 'Multa aplicada', value: policy.feeLabel),
              InfoLine(label: 'Você recebe', value: policy.refund),
              InfoLine(label: 'Prazo de estorno', value: policy.deadline),
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
        _cancelError = reservationActionErrorMessage(error);
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  DangerNotice(message: _error!),
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
                              InfoLine(
                                label: 'Passageiro',
                                value: booking.passengerName!,
                              ),
                            if (booking.passengerCpf != null)
                              InfoLine(
                                label: 'CPF',
                                value: maskedCpf(booking.passengerCpf!),
                              ),
                            InfoLine(
                              label: 'Embarcação',
                              value: booking.vessel,
                            ),
                            InfoLine(label: 'Bilhete', value: booking.id),
                            if (booking.bookingId != null)
                              InfoLine(
                                label: 'Reserva',
                                value: booking.bookingId!,
                              ),
                            if (booking.paymentMethod != null)
                              InfoLine(
                                label: 'Pagamento',
                                value: booking.paymentMethod!,
                              ),
                            if (booking.paymentStatus != null)
                              InfoLine(
                                label: 'Status pagamento',
                                value: booking.paymentStatus!,
                              ),
                            InfoLine(
                              label: 'Total',
                              value: formatMoney(booking.price),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              width: 128,
                              height: 128,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.qr_code,
                                size: 100,
                                color: AppColors.primary,
                              ),
                            ),
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
                        onPressed: () => showFeaturePending(
                          context,
                          'PDF do bilhete será disponibilizado em breve.',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PcButton(
                        label: 'Compartilhar',
                        icon: Icons.share_outlined,
                        variant: PcButtonVariant.teal,
                        onPressed: () => showFeaturePending(
                          context,
                          'Compartilhamento do bilhete será disponibilizado em breve.',
                        ),
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
        _error = reservationActionErrorMessage(error);
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
                InfoLine(label: 'Passageiro', value: draft.passengerName),
                InfoLine(label: 'CPF', value: maskedCpf(draft.passengerCpf)),
                InfoLine(label: 'Embarcação', value: draft.trip.vessel),
                InfoLine(label: 'Reserva', value: draft.reservationCode),
                InfoLine(label: 'Pagamento', value: payment),
                const SizedBox(height: 14),
                Container(
                  width: 128,
                  height: 128,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.qr_code,
                    size: 100,
                    color: AppColors.primary,
                  ),
                ),
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
