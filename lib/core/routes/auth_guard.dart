import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthProvider>().status;

    // Logika satpam: Cek tiket masuknya
    return switch (status) {
      AuthStatus.authenticated =>
        child, // Tiket valid, silakan masuk ke Katalog
      AuthStatus.emailNotVerified =>
        const VerifyEmailPage(), // Belum klik link email, lempar ke ruang tunggu
      _ => const LoginPage(), // Gak punya tiket, tendang ke halaman Login
    };
  }
}
