import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/auth_header.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/routes/app_router.dart';
import '../providers/auth_provider.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    // Mengecek ke Firebase setiap 3 detik
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!mounted) return;

      // 1. Panggil Otak aplikasi (AuthProvider)
      final auth = context.read<AuthProvider>();

      // 2. Suruh dia ngecek ke Firebase DAN ngabarin Satpam (AuthGuard)
      final success = await auth.checkEmailVerified();

      // 3. Kalau udah sukses dan Satpam udah dikabarin
      if (success && mounted) {
        _timer?.cancel(); // Matiin timernya

        // Langsung gas masuk ke etalase fashion lu!
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuthHeader(
                title: 'Check Your Inbox',
                subtitle:
                    'Kami udah mengirim link verifikasi ke email kamu. Tolong di-klik ya biar bisa lanjut.',
              ),
              const SizedBox(height: 32),
              Text(
                user?.email ?? '-',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.black),
              const SizedBox(height: 16),
              const Text(
                'menunggu kamu klik link nih...',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 64),
              CustomButton(
                label: 'CANCEL / BACK TO LOGIN',
                variant: ButtonVariant.text,
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  // Ini juga diganti pakai sistem routing buku peta kita
                  Navigator.pushReplacementNamed(context, AppRouter.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
