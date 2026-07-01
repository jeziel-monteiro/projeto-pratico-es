import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';
import '../../../app/app_state.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../auth/data/auth_service.dart';
import '../../travel/data/favorites_repository.dart';
import '../../travel/data/my_trips_repository.dart';
import '../../travelers/data/traveler_profile.dart';
import '../../travelers/data/traveler_repository.dart';
import '../widgets/profile_widgets.dart';

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
                      ProfileMenuRow(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Minhas Viagens',
                        onTap: () => widget.nav(AppScreen.myTrips),
                      ),
                      ProfileMenuRow(
                        icon: Icons.favorite_border,
                        label: 'Favoritos',
                        onTap: () => widget.nav(AppScreen.favorites),
                      ),
                      ProfileMenuRow(
                        icon: Icons.notifications_outlined,
                        label: 'Notificações',
                        onTap: () => widget.nav(AppScreen.notifications),
                      ),
                      ProfileMenuRow(
                        icon: Icons.settings_outlined,
                        label: 'Configurações',
                        onTap: () => widget.nav(AppScreen.settings),
                      ),
                      ProfileMenuRow(
                        icon: Icons.accessibility_new,
                        label: 'Acessibilidade',
                        onTap: () => widget.nav(AppScreen.accessibility),
                      ),
                      ProfileMenuRow(
                        icon: Icons.help_outline,
                        label: 'Central de Ajuda',
                        onTap: () => widget.nav(AppScreen.help),
                      ),
                      ProfileMenuRow(
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
