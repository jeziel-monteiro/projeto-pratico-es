import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../app/app_state.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/pc_button.dart';
import '../../core/widgets/pc_card.dart';
import '../../core/widgets/pc_text_field.dart';
import '../../core/widgets/section_title.dart';
import '../auth/data/auth_service.dart';
import '../travel/data/favorites_repository.dart';
import '../travel/data/my_trips_repository.dart';
import '../travelers/data/traveler_profile.dart';
import '../travelers/data/traveler_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.nav,
    this.applyHighContrast,
    this.setTravelerName,
  });

  final AppNavigator nav;
  final ContrastSetter? applyHighContrast;
  final TravelerNameSetter? setTravelerName;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  final _travelerRepository = TravelerRepository();
  final _favoritesRepository = FavoritesRepository();
  final _myTripsRepository = MyTripsRepository();
  TravelerProfile? _profile;
  int? _activeTripsCount;
  int? _favoriteTripsCount;
  bool _loading = true;
  bool _signingOut = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _travelerRepository.close();
    _favoritesRepository.close();
    _myTripsRepository.close();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = _authService.currentUser;
      final idToken = await user?.getIdToken();

      if (user == null || idToken == null) {
        throw const AuthServiceException('Sessão de autenticação inválida.');
      }

      final profile = await _travelerRepository.fetchMe(
        firebaseUid: user.uid,
        idToken: idToken,
        email: user.email,
      );
      final summary = await _loadProfileSummary();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _activeTripsCount = summary.activeTripsCount;
        _favoriteTripsCount = summary.favoriteTripsCount;
        _loading = false;
      });
      widget.applyHighContrast?.call(profile.highContrast);
      widget.setTravelerName?.call(profile.fullName);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _profileErrorMessage(error);
        _loading = false;
      });
    }
  }

  Future<_ProfileSummary> _loadProfileSummary() async {
    var activeTripsCount = _activeTripsCount;
    var favoriteTripsCount = _favoriteTripsCount;

    try {
      final trips = await _myTripsRepository.listMyTrips();
      activeTripsCount = trips
          .where((trip) => trip.status == 'confirmada')
          .length;
    } catch (_) {
      activeTripsCount = null;
    }

    try {
      final favorites = await _favoritesRepository.listFavorites();
      favoriteTripsCount = favorites.length;
    } catch (_) {
      favoriteTripsCount = null;
    }

    return _ProfileSummary(
      activeTripsCount: activeTripsCount,
      favoriteTripsCount: favoriteTripsCount,
    );
  }

  Future<void> _signOut() async {
    setState(() => _signingOut = true);
    await _authService.signOut();
    if (!mounted) return;
    widget.nav(AppScreen.login);
  }

  String _profileErrorMessage(Object error) {
    if (error is ApiException) return error.message;
    if (error is AuthServiceException) return error.message;
    return 'Não foi possível carregar seu perfil.';
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    final name = profile?.fullName ?? 'Viajante Porto Certo';
    final email = profile?.email ?? _authService.currentUser?.email ?? '';
    final highContrast = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: PortoBottomNav(
        active: AppScreen.profile,
        nav: widget.nav,
      ),
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: highContrast
                    ? [Colors.black, Colors.black]
                    : [AppColors.navy, AppColors.primary],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white24,
                      child: Text(
                        _initials(name),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.white, fontSize: 19),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email.isEmpty ? 'Email não informado' : email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _ProfileStat(
                                label: 'Viagens',
                                value: _activeTripsCount?.toString() ?? '--',
                              ),
                              const SizedBox(width: 12),
                              _ProfileStat(
                                label: 'Favoritos',
                                value: _favoriteTripsCount?.toString() ?? '--',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_loading) ...[
                  const LinearProgressIndicator(minHeight: 3),
                  const SizedBox(height: 14),
                ],
                if (_error != null) ...[
                  _ProfileMessage(
                    icon: Icons.cloud_off_outlined,
                    message: _error!,
                    onRetry: _loadProfile,
                  ),
                  const SizedBox(height: 14),
                ],
                if (profile != null) ...[
                  PcCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Dados do Viajante'),
                        const SizedBox(height: 8),
                        _ProfileInfoRow(
                          icon: Icons.badge_outlined,
                          label: 'CPF',
                          value: formatCpf(profile.cpf),
                        ),
                        _ProfileInfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Telefone',
                          value: _formatPhone(profile.phone),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                PcCard(
                  child: Column(
                    children: [
                      _MenuRow(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Minhas Viagens',
                        onTap: () => widget.nav(AppScreen.myTrips),
                      ),
                      _MenuRow(
                        icon: Icons.favorite_border,
                        label: 'Favoritos',
                        onTap: () => widget.nav(AppScreen.favorites),
                      ),
                      _MenuRow(
                        icon: Icons.notifications_outlined,
                        label: 'Notificações',
                        onTap: () => widget.nav(AppScreen.notifications),
                      ),
                      _MenuRow(
                        icon: Icons.settings_outlined,
                        label: 'Configurações',
                        onTap: () => widget.nav(AppScreen.settings),
                      ),
                      _MenuRow(
                        icon: Icons.accessibility_new,
                        label: 'Acessibilidade',
                        onTap: () => widget.nav(AppScreen.accessibility),
                      ),
                      _MenuRow(
                        icon: Icons.help_outline,
                        label: 'Central de Ajuda',
                        onTap: () => widget.nav(AppScreen.help),
                      ),
                      _MenuRow(
                        icon: Icons.dashboard_outlined,
                        label: 'Painel do Proprietário',
                        onTap: () => widget.nav(AppScreen.ownerPanel),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcButton(
                  label: 'Sair da Conta',
                  icon: Icons.logout,
                  full: true,
                  variant: PcButtonVariant.danger,
                  loading: _signingOut,
                  onPressed: _signOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSummary {
  const _ProfileSummary({
    required this.activeTripsCount,
    required this.favoriteTripsCount,
  });

  final int? activeTripsCount;
  final int? favoriteTripsCount;
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return 'V';
  final first = _firstLetter(parts.first);
  final second = parts.length > 1 ? _firstLetter(parts.last) : '';
  return '$first$second'.toUpperCase();
}

String _firstLetter(String value) {
  if (value.isEmpty) return '';
  return value.substring(0, 1);
}

String _formatPhone(String? value) {
  final digits = value == null ? '' : onlyDigits(value);
  if (digits.length == 11) {
    return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
  }
  if (digits.length == 10) {
    return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
  }
  return 'Não informado';
}

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      _MenuRow(
                        icon: Icons.lock_outline,
                        label: 'Alterar Senha',
                        onTap: () => widget.nav(AppScreen.changePassword),
                      ),
                      _MenuRow(
                        icon: Icons.description_outlined,
                        label: 'Termos de Uso',
                        onTap: () => widget.nav(AppScreen.terms),
                      ),
                      _MenuRow(
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
                      _SwitchRow(
                        title: 'Notificações push',
                        subtitle: 'Alertas de compra, embarque e atrasos',
                        value: _push,
                        onChanged: (v) => setState(() => _push = v),
                      ),
                      _SwitchRow(
                        title: 'Emails transacionais',
                        subtitle: 'Comprovantes e avisos importantes',
                        value: _email,
                        onChanged: (v) => setState(() => _email = v),
                      ),
                      _SwitchRow(
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

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _authService = AuthService();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _saved = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final currentPassword = _currentPassword.text;
    final newPassword = _newPassword.text;
    final confirmPassword = _confirmPassword.text;

    if (currentPassword.isEmpty) {
      setState(() {
        _saved = false;
        _error = 'Informe sua senha atual.';
      });
      return;
    }

    if (newPassword.length < 6) {
      setState(() {
        _saved = false;
        _error = 'A nova senha deve ter pelo menos 6 caracteres.';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _saved = false;
        _error = 'A confirmação da nova senha não confere.';
      });
      return;
    }

    setState(() {
      _saved = false;
      _error = null;
      _loading = true;
    });

    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _currentPassword.clear();
      _newPassword.clear();
      _confirmPassword.clear();
      if (!mounted) return;
      setState(() {
        _saved = true;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _changePasswordErrorMessage(error);
        _loading = false;
      });
    }
  }

  String _changePasswordErrorMessage(Object error) {
    if (error is AuthServiceException) return error.message;
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-credential' || 'wrong-password' => 'Senha atual incorreta.',
        'weak-password' => 'A nova senha é muito fraca.',
        'requires-recent-login' =>
          'Entre novamente na conta antes de alterar a senha.',
        'network-request-failed' => 'Falha de conexão. Verifique a internet.',
        'too-many-requests' =>
          'Muitas tentativas em sequência. Aguarde um pouco e tente novamente.',
        _ => 'Não foi possível alterar a senha. Tente novamente.',
      };
    }

    return 'Não foi possível alterar a senha. Tente novamente.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Alterar Senha',
            backTo: AppScreen.settings,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_saved) ...[
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
                            'Senha atualizada com sucesso.',
                            style: TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                if (_error != null) ...[
                  PcCard(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                PcCard(
                  child: Column(
                    children: [
                      PcTextField(
                        label: 'Senha atual',
                        controller: _currentPassword,
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      SizedBox(height: 14),
                      PcTextField(
                        label: 'Nova senha',
                        controller: _newPassword,
                        icon: Icons.lock_reset,
                        obscureText: true,
                      ),
                      SizedBox(height: 14),
                      PcTextField(
                        label: 'Confirmar nova senha',
                        controller: _confirmPassword,
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PcButton(
                  label: _loading ? 'Salvando...' : 'Salvar Nova Senha',
                  full: true,
                  loading: _loading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      _SwitchRow(
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
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
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
                      _SwitchRow(
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
                      _SwitchRow(
                        title: 'Navegação Assistiva',
                        subtitle: 'Foco de teclado e atalhos aprimorados',
                        value: _assistiveNav,
                        onChanged: (v) => setState(() => _assistiveNav = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Este app segue WCAG 2.1 Nível AA e é compatível com tecnologias assistivas.',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _search = TextEditingController();
  int? _openIndex;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faqs = const [
      (
        'Como compro uma passagem?',
        'Acesse Buscar, informe origem, destino e data. Escolha a viagem, preencha os dados do passageiro e conclua o pagamento.',
      ),
      (
        'Como cancelo minha reserva?',
        'Acesse Minhas Viagens, selecione a viagem e toque em Cancelar. O reembolso segue a política exibida no bilhete.',
      ),
      (
        'O bilhete digital funciona offline?',
        'Sim. O bilhete é salvo no dispositivo após a compra e fica disponível sem internet.',
      ),
      (
        'Quais formas de pagamento são aceitas?',
        'PIX, Cartão de Crédito e Boleto Bancário.',
      ),
      (
        'Qual a diferença entre Rede e Camarote?',
        'Rede é inclusa no bilhete. Camarote tem cabine privativa e custo adicional.',
      ),
    ];
    final filtered = faqs
        .where(
          (item) =>
              _search.text.isEmpty ||
              item.$1.toLowerCase().contains(_search.text.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Central de Ajuda',
            backTo: AppScreen.profile,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcTextField(
                  label: 'Buscar dúvidas',
                  hint: 'Buscar dúvidas...',
                  icon: Icons.search,
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _HelpAction(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat ao Vivo',
                      color: AppColors.teal,
                      onTap: () {},
                    ),
                    _HelpAction(
                      icon: Icons.phone_outlined,
                      label: 'Ligar Agora',
                      color: AppColors.primary,
                      onTap: () {},
                    ),
                    _HelpAction(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Bilhete Digital',
                      color: AppColors.accent,
                      onTap: () => widget.nav(AppScreen.ticket),
                    ),
                    _HelpAction(
                      icon: Icons.navigation_outlined,
                      label: 'Rastreamento',
                      color: AppColors.success,
                      onTap: () => widget.nav(AppScreen.tracking),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Orientações de Compra'),
                      _MenuRow(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Como comprar passagens',
                        onTap: () => widget.nav(AppScreen.guidePurchase),
                      ),
                      _MenuRow(
                        icon: Icons.credit_card,
                        label: 'Guia de Pagamentos',
                        onTap: () => widget.nav(AppScreen.guidePayment),
                      ),
                      _MenuRow(
                        icon: Icons.airline_seat_flat_angled,
                        label: 'Tipos de Acomodação',
                        onTap: () => widget.nav(AppScreen.guideAccommodation),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PcCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: 'Perguntas Frequentes'),
                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Nenhum resultado encontrado.',
                            style: TextStyle(color: AppColors.muted),
                          ),
                        )
                      else
                        ...List.generate(filtered.length, (index) {
                          final item = filtered[index];
                          final open = _openIndex == index;
                          return ExpansionTile(
                            initiallyExpanded: open,
                            onExpansionChanged: (value) => setState(
                              () => _openIndex = value ? index : null,
                            ),
                            tilePadding: EdgeInsets.zero,
                            title: Text(
                              item.$1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  item.$2,
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
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

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key, required this.nav, required this.topic});

  final AppNavigator nav;
  final GuideTopic topic;

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

enum GuideTopic { purchase, payment, accommodation }

class _GuideScreenState extends State<GuideScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final content = _guideContent(widget.topic);
    final step = content.steps[_index];
    final last = _index == content.steps.length - 1;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: content.title,
            backTo: AppScreen.help,
            nav: widget.nav,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      content.steps.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: i == _index ? 34 : 16,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: i <= _index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PcCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.10,
                            ),
                            child: Icon(
                              step.icon,
                              color: AppColors.primary,
                              size: 38,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            step.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            step.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.muted,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (_index > 0) ...[
                        Expanded(
                          child: PcButton(
                            label: 'Anterior',
                            variant: PcButtonVariant.outline,
                            onPressed: () => setState(() => _index--),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: PcButton(
                          label: last ? 'Concluir' : 'Próximo',
                          icon: last
                              ? Icons.check_circle_outline
                              : Icons.arrow_forward,
                          onPressed: () {
                            if (last) {
                              widget.nav(AppScreen.help);
                            } else {
                              setState(() => _index++);
                            }
                          },
                        ),
                      ),
                    ],
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

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  Widget build(BuildContext context) {
    return LegalScreen(
      nav: nav,
      title: 'Termos de Uso',
      subtitle: 'Última atualização: 01/06/2026',
      sections: const [
        (
          '1. Aceitação dos Termos',
          'Ao utilizar o aplicativo Porto Certo Viagens, você concorda integralmente com estes Termos de Uso.',
        ),
        (
          '2. Uso do Serviço',
          'O aplicativo destina-se à compra de passagens fluviais, consulta de itinerários e rastreamento de embarcações.',
        ),
        (
          '3. Cadastro e Responsabilidades',
          'O usuário é responsável pela veracidade das informações fornecidas no cadastro e no embarque.',
        ),
        (
          '4. Pagamentos e Cancelamentos',
          'Cancelamentos solicitados com mais de 24h de antecedência têm reembolso integral.',
        ),
        ('5. Contato', 'Dúvidas: suporte@portocerto.com.br - (92) 3000-0000.'),
      ],
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  Widget build(BuildContext context) {
    return LegalScreen(
      nav: nav,
      title: 'Política de Privacidade',
      subtitle: 'LGPD Conforme - Última atualização: 01/06/2026',
      sections: const [
        (
          '1. Dados Coletados',
          'Coletamos nome, CPF, email, telefone, dados de pagamento tokenizados, localização durante uso e histórico de viagens.',
        ),
        (
          '2. Finalidade',
          'Os dados são usados para reservas, bilhetes, rastreamento, recomendações e cumprimento de obrigações legais.',
        ),
        (
          '3. Compartilhamento',
          'Podemos compartilhar dados com operadores parceiros, gateways de pagamento e autoridades quando exigido por lei.',
        ),
        (
          '4. Seus Direitos',
          'Você pode acessar, corrigir, excluir ou solicitar portabilidade dos seus dados.',
        ),
        (
          '5. Segurança',
          'Utilizamos criptografia, autenticação segura e controles de acesso para proteger seus dados.',
        ),
      ],
    );
  }
}

class LegalScreen extends StatelessWidget {
  const LegalScreen({
    super.key,
    required this.nav,
    required this.title,
    required this.subtitle,
    required this.sections,
  });

  final AppNavigator nav;
  final String title;
  final String subtitle;
  final List<(String, String)> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(title: title, backTo: AppScreen.login, nav: nav),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PcCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...sections.map(
                        (section) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.$1,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                section.$2,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  height: 1.45,
                                ),
                              ),
                            ],
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

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$value $label',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
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

class _ProfileMessage extends StatelessWidget {
  const _ProfileMessage({
    required this.icon,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return PcCard(
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            tooltip: 'Tentar novamente',
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.10),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
      activeThumbColor: Theme.of(context).colorScheme.primary,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
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

class _HelpAction extends StatelessWidget {
  const _HelpAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideContent {
  const _GuideContent({required this.title, required this.steps});

  final String title;
  final List<_GuideStep> steps;
}

class _GuideStep {
  const _GuideStep({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

_GuideContent _guideContent(GuideTopic topic) {
  return switch (topic) {
    GuideTopic.purchase => const _GuideContent(
      title: 'Como Comprar uma Passagem',
      steps: [
        _GuideStep(
          icon: Icons.search,
          title: '1. Busque a viagem',
          description:
              'Informe origem, destino e data. Datas passadas são bloqueadas automaticamente.',
        ),
        _GuideStep(
          icon: Icons.directions_boat,
          title: '2. Escolha a embarcação',
          description:
              'Compare preços, horários, avaliações e comodidades antes de comprar.',
        ),
        _GuideStep(
          icon: Icons.place_outlined,
          title: '3. Selecione o trecho',
          description:
              'Escolha o ponto de embarque e desembarque. O preço é ajustado conforme a distância.',
        ),
        _GuideStep(
          icon: Icons.payment,
          title: '4. Confirme e pague',
          description:
              'Revise o resumo e escolha PIX, cartão ou boleto para concluir a compra.',
        ),
      ],
    ),
    GuideTopic.payment => const _GuideContent(
      title: 'Guia de Pagamentos',
      steps: [
        _GuideStep(
          icon: Icons.qr_code_2,
          title: 'PIX',
          description:
              'Pagamento instantâneo, sem taxa adicional e com confirmação em segundos.',
        ),
        _GuideStep(
          icon: Icons.credit_card,
          title: 'Cartão de Crédito',
          description:
              'Aceita cartões principais. Taxa de 2% sobre o valor total.',
        ),
        _GuideStep(
          icon: Icons.description_outlined,
          title: 'Boleto Bancário',
          description:
              'Vencimento em 1 dia útil. A confirmação pode levar algumas horas.',
        ),
        _GuideStep(
          icon: Icons.security,
          title: 'Segurança',
          description:
              'Transações protegidas com criptografia e dados sensíveis tokenizados.',
        ),
      ],
    ),
    GuideTopic.accommodation => const _GuideContent(
      title: 'Tipos de Acomodação',
      steps: [
        _GuideStep(
          icon: Icons.airline_seat_flat_angled,
          title: 'Rede',
          description:
              'Inclusa no bilhete, no convés da embarcação, com ventilação natural.',
        ),
        _GuideStep(
          icon: Icons.meeting_room_outlined,
          title: 'Camarote',
          description:
              'Cabine privativa com cama, ar-condicionado e tomada USB.',
        ),
        _GuideStep(
          icon: Icons.luggage_outlined,
          title: 'Bagagem',
          description:
              'Cada passageiro tem direito a 30kg de bagagem sem custo adicional.',
        ),
      ],
    ),
  };
}
