import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
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

  static ThemeData get dark {
    final darkColorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.secondaryLight,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.secondaryLight,
          secondary: AppColors.secondary,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkOnSurface,
          outline: AppColors.darkOutline,
          outlineVariant: AppColors.darkOutlineVariant,
          inverseSurface: AppColors.darkInverseSurface,
          onInverseSurface: AppColors.darkInverseOnSurface,
        );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.secondaryLight,
      fontFamily: 'Manrope',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkOnSurface),
        titleTextStyle: TextStyle(
          fontFamily: 'Noto Serif',
          color: AppColors.darkOnSurface,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkOnSurface),
        bodyMedium: TextStyle(color: AppColors.darkOnSurface),
        bodySmall: TextStyle(color: AppColors.darkOnSurfaceVariant),
        titleLarge: TextStyle(color: AppColors.darkOnSurface),
        titleMedium: TextStyle(color: AppColors.darkOnSurface),
      ),
      hintColor: AppColors.darkOutline,
      dividerColor: AppColors.darkOutlineVariant,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryLight;
          }
          return AppColors.darkOutline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondaryLight.withOpacity(0.4);
          }
          return AppColors.darkOutlineVariant.withOpacity(0.6);
        }),
      ),
    );
  }
}
