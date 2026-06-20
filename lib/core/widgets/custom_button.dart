import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

enum ButtonVariant { primary, exclusive, outline, text }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final content = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.surface,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 12)],
              Text(
                label.toUpperCase(),
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0, // Tracking widets
                ),
              ),
            ],
          );

    // Style untuk tombol Exclusive (Gradient Emas)
    if (variant == ButtonVariant.exclusive) {
      return Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.secondary, AppColors.secondaryDim],
          ),
          borderRadius: BorderRadius.zero, // Wajib tajam 0px
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(color: AppColors.surface),
                child: content,
              ),
            ),
          ),
        ),
      );
    }

    // Style untuk tombol standar
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: switch (variant) {
        ButtonVariant.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.onSurface,
            foregroundColor: AppColors.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            elevation: 0,
          ),
          child: content,
        ),
        ButtonVariant.outline => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.onSurface,
            side: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: content,
        ),
        ButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(foregroundColor: AppColors.onSurface),
          child: content,
        ),
        _ => const SizedBox(),
      },
    );
  }
}
