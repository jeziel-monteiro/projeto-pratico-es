import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light({bool highContrast = false}) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: highContrast ? Colors.yellow : AppColors.primary,
          primary: highContrast ? Colors.yellow : AppColors.primary,
          secondary: highContrast ? Colors.yellow : AppColors.secondary,
          surface: highContrast ? Colors.black : AppColors.surface,
          brightness: highContrast ? Brightness.dark : Brightness.light,
        ).copyWith(
          onPrimary: highContrast ? Colors.black : null,
          onSecondary: highContrast ? Colors.black : null,
          onSurface: highContrast ? Colors.white : null,
          onSurfaceVariant: highContrast ? Colors.white70 : null,
          outline: highContrast ? Colors.yellow : AppColors.border,
          outlineVariant: highContrast ? Colors.yellow : AppColors.border,
          surfaceContainer: highContrast ? Colors.black : Colors.white,
          surfaceContainerHighest: highContrast
              ? const Color(0xFF171717)
              : const Color(0xFFF3F4F6),
        );

    final base = ThemeData(
      colorScheme: colorScheme,
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
      cardTheme: CardThemeData(
        color: highContrast ? Colors.black : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: highContrast ? Colors.yellow : Colors.transparent,
            width: highContrast ? 2 : 0,
          ),
        ),
      ),
      dividerColor: highContrast ? Colors.yellow : AppColors.border,
      iconTheme: IconThemeData(
        color: highContrast ? Colors.yellow : const Color(0xFF374151),
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
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: highContrast ? Colors.yellow : AppColors.primary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: highContrast ? Colors.yellow : AppColors.primary,
          side: BorderSide(
            color: highContrast ? Colors.yellow : AppColors.primary,
            width: highContrast ? 2 : 1,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? (highContrast ? Colors.black : Colors.white)
              : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? (highContrast ? Colors.yellow : AppColors.primary)
              : null,
        ),
      ),
      sliderTheme: base.sliderTheme.copyWith(
        activeTrackColor: highContrast ? Colors.yellow : AppColors.primary,
        thumbColor: highContrast ? Colors.yellow : AppColors.primary,
        inactiveTrackColor: highContrast ? Colors.white54 : null,
      ),
    );
  }
}
