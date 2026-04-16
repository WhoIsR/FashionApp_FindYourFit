import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

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
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            height: 1.6,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
