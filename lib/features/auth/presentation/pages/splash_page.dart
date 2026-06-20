import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../core/constants/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    final token = await SecureStorage.getToken();
    if (!mounted) return;

    final nextRoute = token != null ? AppRouter.dashboard : AppRouter.login;
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inverseSurface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Foto Latar Belakang
          Image.asset(
            'assets/images/model_splash.jpg',
            fit: BoxFit.cover,
            cacheHeight: 1200,
          ),

          // 2. Gradasi gelap agar tulisan tetap terbaca jelas di atas foto
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.inverseSurface.withValues(alpha: 0.9),
                  AppColors.inverseSurface.withValues(alpha: 0.3),
                  AppColors.inverseSurface.withValues(alpha: 0.1),
                  AppColors.inverseSurface.withValues(alpha: 0.6),
                ],
                stops: const [0.0, 0.4, 0.6, 1.0],
              ),
            ),
          ),

          // 3. Konten Teks
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40.0,
                horizontal: 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- Teks Bagian Atas ---
                  Text(
                    'COLLECTION Nº 01',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      letterSpacing: 5.0,
                      color: AppColors.surface.withValues(
                        alpha: 0.7,
                      ), // Menggunakan warna tema
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // --- Teks Bagian Tengah ---
                  Column(
                    children: [
                      Text(
                        'FindYourFit',
                        style: GoogleFonts.notoSerif(
                          fontSize: 56,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1.5,
                          color: AppColors.surface, // Menggunakan warna tema
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Garis tipis sebagai pemanis visual
                      SizedBox(
                        width: 80,
                        height: 1,
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.surface.withValues(
                            alpha: 0.2,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.surface,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // --- Teks Bagian Bawah ---
                  Column(
                    children: [
                      Text(
                        'STYLE DE TENUE',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          letterSpacing: 4.0,
                          color: AppColors.surface.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '© 2026 Radja Satrio Seftiano',
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          letterSpacing: 2.0,
                          color: AppColors.surface.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "l'art de s'habiller",
                        style: GoogleFonts.notoSerif(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.5,
                          color: AppColors.surface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
