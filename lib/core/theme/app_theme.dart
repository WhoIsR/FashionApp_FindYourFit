import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
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
          letterSpacing: -0.5, // Tighter letter spacing sesuai guideline
        ),
      ),
    );
  }
}
