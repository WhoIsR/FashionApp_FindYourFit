import 'package:flutter/material.dart';

class AppColors {
  // ===========================================================================
  // 🌟 BRAND COLORS (Dipakai untuk Light Mode)
  // ===========================================================================
  static const Color primary = Color(0xFF5F5E5E);
  static const Color secondary = Color(0xFF7C5900);
  static const Color secondaryDim = Color(0xFF6D4E00);

  // ===========================================================================
  // ☀️ LIGHT MODE PALETTE 
  // ===========================================================================
  static const Color background = Color(0xFFFAF9F6);
  static const Color surface = Color(0xFFFAF9F6);
  static const Color surfaceDim = Color(0xFFD6DBD5);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF4F4F0);
  static const Color surfaceContainer = Color(0xFFEDEEEA);
  static const Color surfaceContainerHigh = Color(0xFFE6E9E4);
  static const Color surfaceContainerHighest = Color(0xFFE0E4DE);

  static const Color onSurface = Color(0xFF2F3430);
  static const Color onSurfaceVariant = Color(0xFF5C605C);

  static const Color outline = Color(0xFF777C77);
  static const Color outlineVariant = Color(0xFFAFB3AE);

  static const Color inverseSurface = Color(0xFF0D0F0D);
  static const Color inverseOnSurface = Color(0xFF9D9D9A);


  // ===========================================================================
  // 🌙 DARK MODE PALETTE 
  // ===========================================================================
  // Brand color untuk dark mode (dibuat sedikit lebih terang biar pop-up di background hitam)
  static const Color darkPrimary = Color(0xFF9E9D9D); // Abu-abu lebih terang
  static const Color darkSecondary = Color(0xFFB58500); // Emas lebih nyala
  static const Color darkSecondaryDim = Color(0xFF8A6400);

  // Latar belakang pakai warna InverseSurface lu (Super Gelap)
  static const Color darkBackground = Color(0xFF0D0F0D);
  static const Color darkSurface = Color(0xFF0D0F0D);
  static const Color darkSurfaceDim = Color(0xFF141714); 

  // Container dibuat bertingkat gradasi abu-abunya (makin high, makin terang dikit)
  static const Color darkSurfaceContainerLowest = Color(0xFF000000);
  static const Color darkSurfaceContainerLow = Color(0xFF1A1D1A);
  static const Color darkSurfaceContainer = Color(0xFF212521);
  static const Color darkSurfaceContainerHigh = Color(0xFF2B302B);
  static const Color darkSurfaceContainerHighest = Color(0xFF363B36);

  // Warna teks diputar (pakai warna terang dari Light Mode)
  static const Color darkOnSurface = Color(0xFFE6E9E4); // Teks putih tulang
  static const Color darkOnSurfaceVariant = Color(0xFFAFB3AE); // Teks abu-abu

  static const Color darkOutline = Color(0xFF777C77); 
  static const Color darkOutlineVariant = Color(0xFF404440); // Border gelap

  static const Color darkInverseSurface = Color(0xFFFAF9F6); // Latar terang
  static const Color darkInverseOnSurface = Color(0xFF2F3430); // Teks gelap
}