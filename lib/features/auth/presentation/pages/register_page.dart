import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:fashion_app/core/widgets/auth_header.dart';
import 'package:fashion_app/core/widgets/custom_button.dart';
import 'package:fashion_app/core/widgets/custom_text_field.dart';
import 'package:fashion_app/core/widgets/loading_overlay.dart';
import 'package:fashion_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'verify_email_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;
    if (success) {
      // Lempar ke halaman tunggu email
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerifyEmailPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Gagal daftar cuy'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    title: 'Create Account',
                    subtitle: 'Join our exclusive fashion community.',
                  ),
                  const SizedBox(height: 48),
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'John Doe',
                    controller: _nameCtrl,
                    validator: (v) =>
                        (v?.isEmpty ?? true) ? 'Nama jangan kosong' : null,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Email Address',
                    hint: 'name@couture.com',
                    controller: _emailCtrl,
                    validator: (v) =>
                        (v?.isEmpty ?? true) ? 'Email wajib diisi' : null,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Password',
                    hint: 'Minimal 8 karakter',
                    controller: _passCtrl,
                    obscureText: !_showPass,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPass ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                    validator: (v) =>
                        (v?.length ?? 0) < 8 ? 'Password kerendahan bro' : null,
                  ),
                  const SizedBox(height: 48),
                  CustomButton(
                    label: 'CREATE ACCOUNT',
                    onPressed: _register,
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.manrope(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.secondary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
