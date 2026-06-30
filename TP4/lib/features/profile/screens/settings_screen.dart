import 'package:flutter/material.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/section_title.dart';
import '../widgets/profile_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _push = true;
  bool _email = true;
  bool _offline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          AppHeader(
            title: 'Configurações',
            backTo: AppScreen.profile,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  child: Column(
                    children: [
                      ProfileMenuRow(
                        icon: Icons.lock_outline,
                        label: 'Alterar Senha',
                        onTap: () => widget.nav(AppScreen.changePassword),
                      ),
                      ProfileMenuRow(
                        icon: Icons.description_outlined,
                        label: 'Termos de Uso',
                        onTap: () => widget.nav(AppScreen.terms),
                      ),
                      ProfileMenuRow(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Política de Privacidade',
                        onTap: () => widget.nav(AppScreen.privacy),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Preferências'),
                      ProfileSwitchRow(
                        title: 'Notificações push',
                        subtitle: 'Alertas de compra, embarque e atrasos',
                        value: _push,
                        onChanged: (v) => setState(() => _push = v),
                      ),
                      ProfileSwitchRow(
                        title: 'Emails transacionais',
                        subtitle: 'Comprovantes e avisos importantes',
                        value: _email,
                        onChanged: (v) => setState(() => _email = v),
                      ),
                      ProfileSwitchRow(
                        title: 'Bilhete offline',
                        subtitle: 'Salvar bilhetes no dispositivo',
                        value: _offline,
                        onChanged: (v) => setState(() => _offline = v),
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