import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../core/routes/app_router.dart';

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
    // Tahan layar selama 2 detik untuk menampilkan logo
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    String? token;
    try {
      // Hindari splash menunggu tanpa batas saat secure storage lambat/migrasi
      token = await SecureStorage.getToken().timeout(
        const Duration(seconds: 3),
      );
    } catch (_) {
      token = null;
    }

    // Nanti diarahkan ke Dashboard jika token ada.
    // Sementara kita arahkan ke halaman Login dulu.
    final nextRoute = token != null ? AppRouter.login : AppRouter.login;
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'FINDYOURFIT',
              style: TextStyle(
                fontFamily: 'Noto Serif',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.5,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.outlineVariant.withOpacity(0.2),
                color: AppColors.onSurface,
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
