import 'package:flutter/material.dart';

import '../app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.forest,
      brightness: Brightness.light,
      surface: AppColors.paper,
    );

    return ThemeData(
      colorScheme: scheme.copyWith(
        primary: AppColors.forest,
        onPrimary: Colors.white,
        secondary: AppColors.brass,
        surface: AppColors.paper,
        onSurface: AppColors.ink,
      ),
      scaffoldBackgroundColor: AppColors.canvas,
      useMaterial3: true,
      fontFamily: 'Georgia',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 62,
          height: 1.04,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        displayMedium: TextStyle(
          fontSize: 48,
          height: 1.05,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 30,
          height: 1.1,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'sans-serif',
          fontSize: 16,
          height: 1.55,
          color: AppColors.mutedInk,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'sans-serif',
          fontSize: 14,
          height: 1.45,
          color: AppColors.mutedInk,
        ),
        labelLarge: TextStyle(
          fontFamily: 'sans-serif',
          fontSize: 12,
          letterSpacing: 1.4,
          fontWeight: FontWeight.w700,
          color: AppColors.forest,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColors.line),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.forest,
          side: const BorderSide(color: AppColors.line),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.forest,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
