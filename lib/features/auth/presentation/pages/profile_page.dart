import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/routes/app_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withOpacity(0.9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PROFILE',
          style: GoogleFonts.notoSerif(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.surfaceContainerHigh,
              child: Icon(Icons.person, size: 50, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Text(
              'Fashion Enthusiast',
              style: GoogleFonts.notoSerif(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await authState.logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRouter.login, (route) => false);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    child: Text(
                      'LOG OUT',
                      style: GoogleFonts.manrope(
                        color: Colors.red.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
