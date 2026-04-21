import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AUTHENTICATION',
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.notoSerif(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
            color: AppColors.onSurface,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

