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
  Timer? _pollingTimer;
  Timer? _countdownTimer;
  bool _resendCooldown = true; // Langsung cooldown pas halaman dibuka
  int _countdown = 60;

  @override
  void initState() {
    super.initState();
    _startPolling();
    _startResendCooldown(); // Mulai hitung mundur 60 detik
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // 1. Fungsi ngecek status verifikasi tiap 3 detik
  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!mounted) return;

      final auth = context.read<AuthProvider>();
      final success = await auth.checkEmailVerified();

      if (success && mounted) {
        _pollingTimer?.cancel();
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      }
    });
  }

  // 2. Fungsi ngitung mundur 60 detik buat tombol Kirim Ulang
  void _startResendCooldown() {
    setState(() {
      _resendCooldown = true;
      _countdown = 60;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _resendCooldown = false; // Buka gembok tombol kalau udah 0
          timer.cancel();
        }
      });
    });
  }

  // 3. Fungsi buat ngirim ulang email verifikasi ke inbox
  Future<void> _resendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      _startResendCooldown(); // Mulai hitung mundur lagi

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email verifikasi ulang berhasil dikirim! Cek inbox/spam kamu.',
            ),
            backgroundColor: Colors.black87,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tunggu sebentar sebelum mengirim ulang email.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
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
              const SizedBox(height: 48),

              // Tombol Kirim Ulang (Resend Email)
              TextButton(
                onPressed: _resendCooldown ? null : _resendVerificationEmail,
                child: Text(
                  _resendCooldown
                      ? 'Kirim Ulang Email ($_countdown s)'
                      : 'Kirim Ulang Email',
                  style: TextStyle(
                    color: _resendCooldown ? Colors.grey : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Cancel / Logout
              CustomButton(
                label: 'CANCEL / BACK TO LOGIN',
                variant: ButtonVariant.text,
                onPressed: () {
                  context.read<AuthProvider>().logout();
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
