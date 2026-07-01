import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../app/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/network_image_box.dart';
import '../../core/widgets/pc_badge.dart';
import '../../core/widgets/pc_button.dart';
import '../../core/widgets/pc_card.dart';
import '../../data/mock_data.dart';

enum OwnerTab { dashboard, trips, vessels, revenue, customers, settings }

class OwnerPanelScreen extends StatefulWidget {
  const OwnerPanelScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<OwnerPanelScreen> createState() => _OwnerPanelScreenState();
}

class _OwnerPanelScreenState extends State<OwnerPanelScreen> {
  OwnerTab _tab = OwnerTab.dashboard;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 820;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          if (wide)
            _OwnerSidebar(
              active: _tab,
              onSelect: (tab) => setState(() => _tab = tab),
              nav: widget.nav,
            ),
          Expanded(
            child: Column(
              children: [
                if (!wide)
                  SafeArea(
                    bottom: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                      color: AppColors.deepNavy,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => widget.nav(AppScreen.profile),
                                icon: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.white,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Painel do Proprietário',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: OwnerTab.values.map((tab) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(_tabLabel(tab)),
                                    selected: _tab == tab,
                                    onSelected: (_) =>
                                        setState(() => _tab = tab),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(child: _OwnerContent(tab: _tab)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerSidebar extends StatelessWidget {
  const _OwnerSidebar({
    required this.active,
    required this.onSelect,
    required this.nav,
  });

  final OwnerTab active;
  final ValueChanged<OwnerTab> onSelect;
  final AppNavigator nav;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      color: AppColors.deepNavy,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.waves, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PORTO CERTO',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(color: Colors.white),
                        ),
                        const Text(
                          'Painel do Proprietário',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: OwnerTab.values.map((tab) {
                  final selected = tab == active;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Material(
                      color: selected
                          ? AppColors.secondary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: ListTile(
                        selected: selected,
                        onTap: () => onSelect(tab),
                        leading: Icon(
                          _tabIcon(tab),
                          color: selected ? Colors.white : Colors.white60,
                        ),
                        title: Text(
                          _tabLabel(tab),
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        trailing: tab == OwnerTab.trips
                            ? const PcBadge(
                                label: '5',
                                tone: PcBadgeTone.orange,
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: const Text(
                'Carlos Mendes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              subtitle: const Text(
                'Proprietário',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
              trailing: IconButton(
                onPressed: () => nav(AppScreen.profile),
                icon: const Icon(Icons.logout, color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OwnerContent extends StatelessWidget {
  const _OwnerContent({required this.tab});

  final OwnerTab tab;

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      OwnerTab.dashboard => const _OwnerDashboard(),
      OwnerTab.trips => const _OwnerTrips(),
      OwnerTab.vessels => const _OwnerVessels(),
      OwnerTab.revenue => const _OwnerRevenue(),
      OwnerTab.customers => const _OwnerCustomers(),
      OwnerTab.settings => const _OwnerSettings(),
    };
  }
}

class _OwnerDashboard extends StatelessWidget {
  const _OwnerDashboard();

  @override
  Widget build(BuildContext context) {
    return _OwnerPage(
      title: 'Dashboard',
      subtitle: 'Bem-vindo, Carlos. Aqui está o resumo de hoje.',
      trailing: const PcButton(
        label: 'Nova Viagem',
        icon: Icons.add,
        small: true,
      ),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 900
                ? 4
                : constraints.maxWidth > 620
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _Kpi(
                  label: 'Receita Mensal',
                  value: 'R\$ 58.400',
                  sub: '+24% vs. mês anterior',
                  icon: Icons.attach_money,
                  color: AppColors.primary,
                ),
                _Kpi(
                  label: 'Passageiros',
                  value: '445',
                  sub: 'este mês',
                  icon: Icons.groups_outlined,
                  color: AppColors.secondary,
                ),
                _Kpi(
                  label: 'Viagens Realizadas',
                  value: '62',
                  sub: 'em junho',
                  icon: Icons.directions_boat,
                  color: AppColors.teal,
                ),
                _Kpi(
                  label: 'Taxa de Ocupação',
                  value: '87%',
                  sub: 'média da frota',
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.accent,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 760;
            return Flex(
              direction: wide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: wide ? 2 : 0, child: const _RevenueChart()),
                SizedBox(width: wide ? 14 : 0, height: wide ? 0 : 14),
                Expanded(flex: wide ? 1 : 0, child: const _PaymentShare()),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        const _OwnerTripsTable(compact: true),
      ],
    );
  }
}

class _OwnerTrips extends StatelessWidget {
  const _OwnerTrips();

  @override
  Widget build(BuildContext context) {
    return const _OwnerPage(
      title: 'Viagens',
      subtitle: 'Gerencie todas as viagens da frota',
      trailing: PcButton(label: 'Nova Viagem', icon: Icons.add, small: true),
      children: [_OwnerTripsTable(compact: false)],
    );
  }
}

class _OwnerVessels extends StatelessWidget {
  const _OwnerVessels();

  @override
  Widget build(BuildContext context) {
    return _OwnerPage(
      title: 'Embarcações',
      subtitle: 'Gerencie sua frota',
      trailing: const PcButton(
        label: 'Cadastrar Embarcação',
        icon: Icons.add,
        small: true,
      ),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 850 ? 2 : 1;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: constraints.maxWidth > 850 ? 2.2 : 1.55,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: MockData.trips.map((trip) {
                return PcCard(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              NetworkImageBox(
                                url: trip.imageUrl,
                                borderRadius: 0,
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.65),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 14,
                                bottom: 12,
                                child: Text(
                                  trip.vessel,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: PcBadge(
                                  label: trip.seats > 0 ? 'Ativa' : 'Esgotada',
                                  tone: trip.seats > 0
                                      ? PcBadgeTone.teal
                                      : PcBadgeTone.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: _MiniData(
                                  label: 'Registro',
                                  value: trip.registration,
                                ),
                              ),
                              Expanded(
                                child: _MiniData(
                                  label: 'Capacidade',
                                  value: '${trip.capacity} pass.',
                                ),
                              ),
                              Expanded(
                                child: _MiniData(
                                  label: 'Velocidade',
                                  value: trip.speed,
                                ),
                              ),
                              Expanded(
                                child: _MiniData(
                                  label: 'Avaliação',
                                  value: '${trip.rating}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _OwnerRevenue extends StatelessWidget {
  const _OwnerRevenue();

  @override
  Widget build(BuildContext context) {
    return const _OwnerPage(
      title: 'Receitas',
      subtitle: 'Análise financeira detalhada',
      trailing: PcButton(
        label: 'Exportar Relatório',
        icon: Icons.download_outlined,
        small: true,
        variant: PcButtonVariant.outline,
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: _Kpi(
                label: 'Receita Total',
                value: 'R\$ 299.500',
                sub: 'jan-jun 2026',
                icon: Icons.attach_money,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _Kpi(
                label: 'Ticket Médio',
                value: 'R\$ 164',
                sub: 'por passageiro',
                icon: Icons.trending_up,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _Kpi(
                label: 'Passageiros',
                value: '1.825',
                sub: 'no semestre',
                icon: Icons.groups_outlined,
                color: AppColors.teal,
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        _RevenueChart(),
        SizedBox(height: 14),
        _RouteRevenue(),
      ],
    );
  }
}

class _OwnerCustomers extends StatelessWidget {
  const _OwnerCustomers();

  @override
  Widget build(BuildContext context) {
    final customers = const [
      (
        'Ana Carolina Souza',
        '***.***.***-45',
        'ana.carol@email.com',
        '3',
        'R\$ 555',
        'Ativo',
      ),
      (
        'Pedro Henrique Lima',
        '***.***.***-78',
        'pedro.lima@gmail.com',
        '7',
        'R\$ 1.330',
        'Ativo',
      ),
      (
        'Juliana Ferreira',
        '***.***.***-12',
        'ju.ferreira@hotmail.com',
        '2',
        'R\$ 390',
        'Ativo',
      ),
      (
        'Roberto Costa',
        '***.***.***-90',
        'roberto@empresa.com',
        '1',
        'R\$ 220',
        'Inativo',
      ),
    ];

    return _OwnerPage(
      title: 'Passageiros',
      subtitle: 'Base de 1.825 passageiros cadastrados',
      trailing: const PcButton(
        label: 'Exportar CSV',
        icon: Icons.download_outlined,
        small: true,
        variant: PcButtonVariant.outline,
      ),
      children: [
        PcCard(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Passageiro')),
                DataColumn(label: Text('CPF')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Viagens')),
                DataColumn(label: Text('Gasto Total')),
                DataColumn(label: Text('Status')),
              ],
              rows: customers.map((c) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              c.$1[0],
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(c.$1),
                        ],
                      ),
                    ),
                    DataCell(Text(c.$2)),
                    DataCell(Text(c.$3)),
                    DataCell(Text(c.$4)),
                    DataCell(Text(c.$5)),
                    DataCell(
                      PcBadge(
                        label: c.$6,
                        tone: c.$6 == 'Ativo'
                            ? PcBadgeTone.teal
                            : PcBadgeTone.gray,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _OwnerSettings extends StatelessWidget {
  const _OwnerSettings();

  @override
  Widget build(BuildContext context) {
    return const _OwnerPage(
      title: 'Configurações da Conta',
      subtitle: 'Dados da empresa e preferências operacionais',
      children: [_OwnerSettingsContent()],
    );
  }
}

class _OwnerPage extends StatelessWidget {
  const _OwnerPage({
    required this.title,
    required this.subtitle,
    required this.children,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PcCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color),
          ),
        ],
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  const _RevenueChart();

  @override
  Widget build(BuildContext context) {
    final data = const [
      ('Jan', 42),
      ('Fev', 38),
      ('Mar', 51),
      ('Abr', 47),
      ('Mai', 63),
      ('Jun', 58),
    ];
    return PcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Receita Mensal (R\$ mil)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((point) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: point.$2 / 70,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          point.$1,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentShare extends StatelessWidget {
  const _PaymentShare();

  @override
  Widget build(BuildContext context) {
    return PcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Formas de Pagamento',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          _ShareLine(label: 'PIX', value: 55, color: AppColors.primary),
          _ShareLine(label: 'Cartão', value: 30, color: AppColors.secondary),
          _ShareLine(label: 'Boleto', value: 15, color: AppColors.teal),
        ],
      ),
    );
  }
}

class _ShareLine extends StatelessWidget {
  const _ShareLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '$value%',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 9,
              color: color,
              backgroundColor: AppColors.border,
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerTripsTable extends StatelessWidget {
  const _OwnerTripsTable({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PcCard(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Rota')),
            DataColumn(label: Text('Embarcação')),
            DataColumn(label: Text('Data')),
            DataColumn(label: Text('Passageiros')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Receita')),
          ],
          rows: MockData.ownerTrips.map((trip) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    trip.id,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                DataCell(Text(trip.route)),
                DataCell(Text(trip.vessel)),
                DataCell(Text(trip.date)),
                DataCell(
                  SizedBox(
                    width: 110,
                    child: Row(
                      children: [
                        Text(
                          '${trip.passengers}/${trip.capacity}',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: trip.passengers / trip.capacity,
                            color: AppColors.primary,
                            backgroundColor: AppColors.border,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(_StatusDot(status: trip.status)),
                DataCell(
                  Text(
                    'R\$ ${trip.revenue}',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'confirmada' => AppColors.success,
      'embarcando' => AppColors.accent,
      'pendente' => AppColors.muted,
      _ => AppColors.primary,
    };
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(status, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _MiniData extends StatelessWidget {
  const _MiniData({required this.label, required this.value});

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
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
        ),
      ],
    );
  }
}

class _RouteRevenue extends StatelessWidget {
  const _RouteRevenue();

  @override
  Widget build(BuildContext context) {
    final routes = const [
      ('Manaus -> Santarem', 42, 'R\$ 125.000'),
      ('Manaus -> Parintins', 28, 'R\$ 78.000'),
      ('Manaus -> Tefe', 18, 'R\$ 64.000'),
      ('Santarem -> Belem', 12, 'R\$ 32.500'),
    ];
    return PcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Receita por Rota',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 14),
          ...routes.map(
            (route) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          route.$1,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        route.$3,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: route.$2 / 50,
                      minHeight: 8,
                      color: AppColors.primary,
                      backgroundColor: AppColors.border,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerSettingsContent extends StatelessWidget {
  const _OwnerSettingsContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 760;
        return Flex(
          direction: wide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: wide ? 1 : 0,
              child: const PcCard(
                child: Column(
                  children: [
                    Text(
                      'Dados da Empresa',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 14),
                    _SettingsLine(
                      label: 'Nome da Empresa',
                      value: 'Porto Certo Viagens LTDA',
                    ),
                    _SettingsLine(label: 'CNPJ', value: '12.345.678/0001-90'),
                    _SettingsLine(
                      label: 'Email Comercial',
                      value: 'contato@portocerto.com.br',
                    ),
                    _SettingsLine(label: 'Telefone', value: '(92) 3000-0000'),
                  ],
                ),
              ),
            ),
            SizedBox(width: wide ? 14 : 0, height: wide ? 0 : 14),
            Expanded(
              flex: wide ? 1 : 0,
              child: const PcCard(
                child: Column(
                  children: [
                    Text(
                      'Notificações',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 12),
                    SwitchListTile(
                      value: true,
                      onChanged: null,
                      title: Text('Nova reserva confirmada'),
                    ),
                    SwitchListTile(
                      value: true,
                      onChanged: null,
                      title: Text('Cancelamento de reserva'),
                    ),
                    SwitchListTile(
                      value: false,
                      onChanged: null,
                      title: Text('Relatório diário'),
                    ),
                    SwitchListTile(
                      value: true,
                      onChanged: null,
                      title: Text('Alerta de capacidade mínima'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsLine extends StatelessWidget {
  const _SettingsLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.muted)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

String _tabLabel(OwnerTab tab) {
  return switch (tab) {
    OwnerTab.dashboard => 'Dashboard',
    OwnerTab.trips => 'Viagens',
    OwnerTab.vessels => 'Embarcações',
    OwnerTab.revenue => 'Receitas',
    OwnerTab.customers => 'Passageiros',
    OwnerTab.settings => 'Configurações',
  };
}

IconData _tabIcon(OwnerTab tab) {
  return switch (tab) {
    OwnerTab.dashboard => Icons.dashboard_outlined,
    OwnerTab.trips => Icons.directions_boat,
    OwnerTab.vessels => Icons.anchor,
    OwnerTab.revenue => Icons.attach_money,
    OwnerTab.customers => Icons.groups_outlined,
    OwnerTab.settings => Icons.settings_outlined,
  };
}
