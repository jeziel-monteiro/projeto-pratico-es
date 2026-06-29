import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light({bool highContrast = false}) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: highContrast ? Colors.yellow : AppColors.primary,
        primary: highContrast ? Colors.yellow : AppColors.primary,
        secondary: highContrast ? Colors.white : AppColors.secondary,
        surface: highContrast ? Colors.black : AppColors.surface,
        brightness: highContrast ? Brightness.dark : Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: highContrast ? Colors.black : AppColors.surface,
      fontFamily: 'Roboto',
    );

    final textColor = highContrast ? Colors.white : const Color(0xFF1F2937);
    final displayColor = highContrast ? Colors.yellow : const Color(0xFF111827);

    return base.copyWith(
      textTheme: base.textTheme
          .apply(
            bodyColor: textColor,
            displayColor: displayColor,
            fontFamily: 'Roboto',
          )
          .copyWith(
            titleLarge: base.textTheme.titleLarge?.copyWith(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w900,
              color: displayColor,
            ),
            titleMedium: base.textTheme.titleMedium?.copyWith(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w900,
              color: displayColor,
            ),
            titleSmall: base.textTheme.titleSmall?.copyWith(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              color: displayColor,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: highContrast ? Colors.black : AppColors.card,
        foregroundColor: highContrast ? Colors.yellow : const Color(0xFF111827),
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: highContrast ? Colors.black : Colors.white,
        labelStyle: TextStyle(
          color: highContrast ? Colors.yellow : AppColors.muted,
        ),
        hintStyle: TextStyle(
          color: highContrast ? Colors.white70 : AppColors.muted,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: highContrast ? Colors.yellow : AppColors.border,
            width: highContrast ? 2 : 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: highContrast ? Colors.yellow : AppColors.border,
            width: highContrast ? 2 : 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: highContrast ? Colors.yellow : AppColors.primary,
            width: 2,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: highContrast ? Colors.black : Colors.white,
        selectedItemColor: highContrast ? Colors.yellow : AppColors.primary,
        unselectedItemColor: highContrast
            ? Colors.white70
            : const Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
