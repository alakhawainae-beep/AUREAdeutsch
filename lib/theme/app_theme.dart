import 'package:flutter/material.dart';

/// Visual identity for AUREA Deutsch.
class AppTheme {
  static const Color ink = Color(0xFF1A1714);
  static const Color parchment = Color(0xFFF7F2E8);
  static const Color gold = Color(0xFFC4A35A);
  static const Color goldDeep = Color(0xFF9A7B3C);
  static const Color forest = Color(0xFF2F4A3C);

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: forest,
        primary: forest,
        secondary: goldDeep,
        surface: parchment,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: parchment,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: ink,
        displayColor: ink,
        fontFamily: 'Georgia',
      ).copyWith(
        displayLarge: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: 42,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: ink,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        headlineMedium: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 16,
          height: 1.45,
          color: ink,
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: 14,
          height: 1.4,
          color: Color(0xFF4A453E),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: ink,
        centerTitle: false,
      ),
    );
  }
}
