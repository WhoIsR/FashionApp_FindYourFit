import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  // ☀️ TEMA TERANG (Light Mode)
  static ThemeData get light {
    final lightColorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.secondary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.secondary,
          secondary: AppColors.secondaryDim,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      primaryColor: AppColors.onSurface,
      fontFamily: 'Manrope', // Font default untuk body
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.onSurface),
        titleTextStyle: TextStyle(
          fontFamily: 'Noto Serif', // Font judul
          color: AppColors.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  // 🌙 TEMA GELAP (Dark Mode)
  static ThemeData get dark {
    final darkColorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.darkSecondary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.darkPrimary,
          secondary: AppColors.darkSecondary,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkOnSurface,
          outline: AppColors.darkOutline,
          outlineVariant: AppColors.darkOutlineVariant,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.darkOnSurface,
      fontFamily: 'Manrope', //
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.darkOnSurface,
        ), // Ikon jadi terang
        titleTextStyle: TextStyle(
          fontFamily: 'Noto Serif',
          color: AppColors.darkOnSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}
