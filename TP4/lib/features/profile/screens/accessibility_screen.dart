import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';
import '../../../app/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/section_title.dart';
import '../widgets/profile_widgets.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({
    super.key,
    required this.nav,
    required this.highContrast,
    required this.setHighContrast,
  });

  final AppNavigator nav;
  final bool highContrast;
  final ContrastSetter setHighContrast;

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  double _fontSize = 16;
  bool _screenReader = false;
  bool _assistiveNav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          AppHeader(
            title: 'Acessibilidade',
            backTo: AppScreen.settings,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Visual'),
                      ProfileSwitchRow(
                        title: 'Alto Contraste',
                        subtitle: 'Aumenta contraste para melhor visibilidade',
                        value: widget.highContrast,
                        onChanged: (value) {
                          widget.setHighContrast(value);
                          if (value) widget.nav(AppScreen.highContrast);
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Tamanho da Fonte',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                          Text(
                            '${_fontSize.round()}px',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _fontSize,
                        min: 14,
                        max: 24,
                        divisions: 5,
                        onChanged: (value) => setState(() => _fontSize = value),
                      ),
                      Text(
                        'Texto de exemplo',
                        style: TextStyle(fontSize: _fontSize),
                      ),
                      ProfileSwitchRow(
                        title: 'Leitor de Tela',
                        subtitle: 'Compatível com TalkBack e VoiceOver',
                        value: _screenReader,
                        onChanged: (v) => setState(() => _screenReader = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Navegação'),
                      ProfileSwitchRow(
                        title: 'Navegação Assistiva',
                        subtitle: 'Foco de teclado e atalhos aprimorados',
                        value: _assistiveNav,
                        onChanged: (v) => setState(() => _assistiveNav = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const PcCard(
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Este app segue WCAG 2.1 Nível AA e é compatível com tecnologias assistivas.',
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
}

class HighContrastScreen extends StatelessWidget {
  const HighContrastScreen({
    super.key,
    required this.nav,
    required this.setHighContrast,
  });

  final AppNavigator nav;
  final ContrastSetter setHighContrast;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.yellow, width: 2),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => nav(AppScreen.accessibility),
                    icon: const Icon(Icons.chevron_left, color: Colors.yellow),
                  ),
                  const Expanded(
                    child: Text(
                      'Alto Contraste Ativado',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _ContrastCard(
                    title: 'Viagens Disponíveis',
                    child: Column(
                      children: [
                        _ContrastTrip(
                          name: 'Comandante Freitas',
                          route: 'Manaus -> Santarem',
                          price: 'R\$ 180',
                        ),
                        _ContrastTrip(
                          name: 'Ana Beatriz',
                          route: 'Manaus -> Parintins',
                          price: 'R\$ 95',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ContrastCard(
                    title: 'Menu Principal',
                    child: Column(
                      children: [
                        _ContrastMenu(
                          label: 'Buscar Viagem',
                          onTap: () => nav(AppScreen.search),
                        ),
                        _ContrastMenu(
                          label: 'Favoritos',
                          onTap: () => nav(AppScreen.favorites),
                        ),
                        _ContrastMenu(
                          label: 'Rastrear',
                          onTap: () => nav(AppScreen.tracking),
                        ),
                        _ContrastMenu(
                          label: 'Perfil',
                          onTap: () => nav(AppScreen.profile),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () {
                      setHighContrast(false);
                      nav(AppScreen.accessibility);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      padding: const EdgeInsets.all(14),
                    ),
                    child: const Text(
                      'Desativar Alto Contraste',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContrastCard extends StatelessWidget {
  const _ContrastCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow, width: 2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ContrastTrip extends StatelessWidget {
  const _ContrastTrip({
    required this.name,
    required this.route,
    required this.price,
  });

  final String name;
  final String route;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(route, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContrastMenu extends StatelessWidget {
  const _ContrastMenu({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.yellow),
    );
  }
}