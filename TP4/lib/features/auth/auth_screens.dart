import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../app/app_state.dart';
import '../../core/assets/app_assets.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/pc_button.dart';
import '../../core/widgets/pc_card.dart';
import '../../core/widgets/pc_text_field.dart';
import '../travelers/data/traveler_repository.dart';
import 'data/auth_error_mapper.dart';
import 'data/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.nav, this.setTravelerName});

  final AppNavigator nav;
  final TravelerNameSetter? setTravelerName;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _authService = AuthService();
  final _travelerRepository = TravelerRepository();
  bool _showPassword = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _travelerRepository.close();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty) {
      setState(() => _error = 'Email obrigatório.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _error = 'Email inválido. Verifique e tente novamente.');
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = 'Senha obrigatória.');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      final credential = await _authService.signIn(
        email: email,
        password: password,
      );
      final user = credential.user;
      final idToken = await user?.getIdToken();

      if (user == null || idToken == null) {
        throw const AuthServiceException('Sessao de autenticacao invalida.');
      }

      final profile = await _travelerRepository.fetchMe(
        firebaseUid: user.uid,
        idToken: idToken,
        email: user.email,
      );

      if (!mounted) return;
      widget.setTravelerName?.call(profile.fullName);
      widget.nav(AppScreen.home);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _friendlyAuthMessage(error);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.secondary],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 42),
                    child: Column(
                      children: [
                        Image.asset(
                          AppAssets.logo,
                          width: 142,
                          height: 142,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bem-vindo de volta',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.white, fontSize: 22),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Entre na sua conta para continuar',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    PcCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          if (_error != null) ...[
                            _InlineAlert(
                              message: _error!,
                              color: AppColors.danger,
                            ),
                            const SizedBox(height: 14),
                          ],
                          PcTextField(
                            label: 'Email',
                            hint: 'seu@email.com',
                            icon: Icons.mail_outline,
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 14),
                          PcTextField(
                            label: 'Senha',
                            hint: '••••••••',
                            icon: Icons.lock_outline,
                            controller: _password,
                            obscureText: !_showPassword,
                            suffix: IconButton(
                              onPressed: () => setState(
                                () => _showPassword = !_showPassword,
                              ),
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.muted,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => widget.nav(AppScreen.forgot),
                              child: const Text(
                                'Esqueci minha senha',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          PcButton(
                            label: 'Entrar',
                            full: true,
                            loading: _loading,
                            onPressed: _submit,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'ou',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 18),
                    PcButton(
                      label: 'Criar nova conta',
                      full: true,
                      variant: PcButtonVariant.outline,
                      onPressed: () => widget.nav(AppScreen.register),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          'Ao entrar você concorda com os ',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => widget.nav(AppScreen.terms),
                          child: const Text(
                            'Termos de Uso',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Text(
                          ' e a ',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => widget.nav(AppScreen.privacy),
                          child: const Text(
                            'Política de Privacidade',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
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
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.nav, this.setTravelerName});

  final AppNavigator nav;
  final TravelerNameSetter? setTravelerName;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _cpf = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _authService = AuthService();
  final _travelerRepository = TravelerRepository();
  final Map<String, String> _errors = {};
  String? _generalError;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _cpf.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _travelerRepository.close();
    super.dispose();
  }

  Future<void> _submit() async {
    _errors.clear();
    _generalError = null;
    if (_name.text.trim().isEmpty) _errors['name'] = 'Nome obrigatório.';
    if (onlyDigits(_cpf.text).length < 11) _errors['cpf'] = 'CPF inválido.';
    if (!_email.text.contains('@')) _errors['email'] = 'Email inválido.';
    if (_password.text.length < 8) {
      _errors['password'] = 'Senha deve ter no mínimo 8 caracteres.';
    }
    if (_password.text != _confirm.text) {
      _errors['confirm'] = 'As senhas não coincidem.';
    }

    if (_errors.isNotEmpty) {
      setState(() {});
      return;
    }
    setState(() => _loading = true);

    var createdFirebaseUser = false;

    try {
      final email = _email.text.trim();
      final fullName = _name.text.trim();
      final credential = await _authService.register(
        email: email,
        password: _password.text,
      );
      createdFirebaseUser = true;
      final user = credential.user;
      final idToken = await user?.getIdToken();

      if (user == null || idToken == null) {
        throw const AuthServiceException('Sessao de autenticacao invalida.');
      }

      await user.updateDisplayName(fullName);
      final phone = onlyDigits(_phone.text);
      await _travelerRepository.createProfile(
        firebaseUid: user.uid,
        idToken: idToken,
        fullName: fullName,
        cpf: onlyDigits(_cpf.text),
        email: email,
        phone: phone.isEmpty ? null : phone,
      );

      if (!mounted) return;
      widget.setTravelerName?.call(fullName);
      widget.nav(AppScreen.home);
    } catch (error) {
      if (createdFirebaseUser) {
        try {
          await _authService.deleteCurrentUser();
        } catch (_) {
          // A conta pode precisar ser removida manualmente no Firebase.
        }
      }
      if (!mounted) return;
      setState(() {
        _generalError = _friendlyAuthMessage(error);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Criar Conta',
            backTo: AppScreen.login,
            nav: widget.nav,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                PcCard(
                  child: Column(
                    children: [
                      if (_generalError != null) ...[
                        _InlineAlert(
                          message: _generalError!,
                          color: AppColors.danger,
                        ),
                        const SizedBox(height: 14),
                      ],
                      PcTextField(
                        label: 'Nome Completo',
                        hint: 'João da Silva',
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
                        errorText: _errors['cpf'],
                        keyboardType: TextInputType.number,
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
                      const SizedBox(height: 14),
                      PcTextField(
                        label: 'Telefone',
                        hint: '(92) 99999-9999',
                        icon: Icons.phone_outlined,
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                      PcTextField(
                        label: 'Email',
                        hint: 'seu@email.com',
                        icon: Icons.mail_outline,
                        controller: _email,
                        errorText: _errors['email'],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      PcTextField(
                        label: 'Senha',
                        hint: 'Mín. 8 caracteres',
                        icon: Icons.lock_outline,
                        controller: _password,
                        errorText: _errors['password'],
                        obscureText: true,
                      ),
                      const SizedBox(height: 14),
                      PcTextField(
                        label: 'Confirmar Senha',
                        hint: 'Repita a senha',
                        icon: Icons.lock_outline,
                        controller: _confirm,
                        errorText: _errors['confirm'],
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PcButton(
                  label: 'Criar Minha Conta',
                  full: true,
                  loading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 14),
                Text(
                  'Ao criar uma conta, você concorda com os Termos de Uso e a Política de Privacidade.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    height: 1.35,
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

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key, required this.nav});

  final AppNavigator nav;

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _email = TextEditingController();
  final _authService = AuthService();
  bool _sent = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AppHeader(
            title: 'Recuperar Senha',
            backTo: AppScreen.login,
            nav: widget.nav,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: _sent
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 42,
                          backgroundColor: Color(0xFFDFF7EC),
                          child: Icon(
                            Icons.check_circle_outline,
                            color: AppColors.success,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Email enviado!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Verifique sua caixa de entrada em ${_email.text} e siga as instruções para redefinir sua senha.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.muted,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        PcButton(
                          label: 'Voltar para Login',
                          full: true,
                          onPressed: () => widget.nav(AppScreen.login),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 42,
                          backgroundColor: Color(0xFFE8F1FF),
                          child: Icon(
                            Icons.lock_reset,
                            color: AppColors.primary,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Esqueceu a senha?',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Informe seu email e enviaremos um link para redefinir sua senha.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.muted, height: 1.4),
                        ),
                        const SizedBox(height: 24),
                        if (_error != null) ...[
                          _InlineAlert(
                            message: _error!,
                            color: AppColors.danger,
                          ),
                          const SizedBox(height: 14),
                        ],
                        PcTextField(
                          label: 'Email cadastrado',
                          hint: 'seu@email.com',
                          icon: Icons.mail_outline,
                          controller: _email,
                        ),
                        const SizedBox(height: 18),
                        PcButton(
                          label: 'Enviar Instruções',
                          full: true,
                          loading: _loading,
                          onPressed: _sendPasswordReset,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendPasswordReset() async {
    final email = _email.text.trim();
    if (!email.contains('@')) {
      setState(() => _error = 'Email inválido.');
      return;
    }

    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      await _authService.sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() => _sent = true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _friendlyAuthMessage(error);
        _loading = false;
      });
    }
  }
}

String _friendlyAuthMessage(Object error) {
  if (error is ApiException) return error.message;
  if (error is AuthServiceException) return error.message;
  return mapAuthError(error);
}

class _InlineAlert extends StatelessWidget {
  const _InlineAlert({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: color, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
