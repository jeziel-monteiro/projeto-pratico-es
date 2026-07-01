import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:porto_certo_tp4/core/theme/app_colors.dart';
import 'package:porto_certo_tp4/core/theme/app_theme.dart';

void main() {
  test('tema padrão preserva a paleta clara', () {
    final theme = AppTheme.light();

    expect(theme.brightness, Brightness.light);
    expect(theme.scaffoldBackgroundColor, AppColors.surface);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.bottomNavigationBarTheme.backgroundColor, Colors.white);
  });

  test('tema de alto contraste usa preto, branco e amarelo', () {
    final theme = AppTheme.light(highContrast: true);

    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, Colors.black);
    expect(theme.colorScheme.primary, Colors.yellow);
    expect(theme.colorScheme.onSurface, Colors.white);
    expect(theme.appBarTheme.backgroundColor, Colors.black);
    expect(theme.appBarTheme.foregroundColor, Colors.yellow);
    expect(theme.inputDecorationTheme.fillColor, Colors.black);
    expect(theme.bottomNavigationBarTheme.backgroundColor, Colors.black);
    expect(theme.bottomNavigationBarTheme.selectedItemColor, Colors.yellow);
  });
}
