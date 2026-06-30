import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/pc_button.dart';
import '../../../core/widgets/pc_card.dart';
import '../../../core/widgets/pc_text_field.dart';
import '../../auth/data/auth_service.dart';

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
      backgroundColor: AppColors.surface,
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
                        Icon(Icons.check_circle_outline, color: AppColors.success),
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
                        const Icon(Icons.error_outline, color: AppColors.danger),
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
                      const SizedBox(height: 14),
                      PcTextField(
                        label: 'Nova senha',
                        controller: _newPassword,
                        icon: Icons.lock_reset,
                        obscureText: true,
                      ),
                      const SizedBox(height: 14),
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