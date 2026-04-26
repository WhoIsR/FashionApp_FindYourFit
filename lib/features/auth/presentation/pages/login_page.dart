import 'package:fashion_app/core/constants/app_colors.dart';
import 'package:fashion_app/core/widgets/auth_header.dart';
import 'package:fashion_app/core/widgets/custom_button.dart';
import 'package:fashion_app/core/widgets/custom_text_field.dart';
import 'package:fashion_app/core/widgets/divider_with_text.dart';
import 'package:fashion_app/core/widgets/google_sign_in_button.dart';
import 'package:fashion_app/core/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_page.dart';
import 'verify_email_page.dart';
import '../../../../core/routes/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _showPass = !_showPass);
  }

  void _goToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  void _handleLoginResult(bool success, AuthProvider auth) {
    if (success) {
      Navigator.pushReplacementNamed(context, AppRouter.dashboard);
    } else if (auth.status == AuthStatus.emailNotVerified) {
      Navigator.pushReplacementNamed(context, AppRouter.verifyEmail);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Gagal login bro'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loginEmail() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.loginWithEmail(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (mounted) _handleLoginResult(ok, auth);
  }

  Future<void> _loginGoogle() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.loginWithGoogle();
    if (mounted) _handleLoginResult(ok, auth);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final media = MediaQuery.of(context);
    final size = media.size;
    final keyboardOpen = media.viewInsets.bottom > 0;

    final isSmallHeight = size.height < 760;
    final horizontalPadding = size.width < 360 ? 20.0 : 32.0;
    final verticalPadding = isSmallHeight ? 20.0 : 32.0;
    final largeGap = isSmallHeight ? 28.0 : 48.0;
    final mediumGap = isSmallHeight ? 16.0 : 24.0;

    return LoadingOverlay(
      isLoading: auth.isLoading,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight =
                  (constraints.maxHeight - (verticalPadding * 2))
                      .clamp(0.0, double.infinity)
                      .toDouble();

              return SingleChildScrollView(
                physics: keyboardOpen
                    ? const ClampingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: availableHeight),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AuthHeader(
                          title: 'Welcome to FindYourFit',
                          subtitle:
                              'Access your personal wardrobe and curated collections.',
                        ),
                        SizedBox(height: largeGap),
                        _buildEmailField(),
                        SizedBox(height: mediumGap),
                        _buildPasswordField(),
                        SizedBox(height: largeGap),
                        CustomButton(
                          label: 'SIGN IN',
                          onPressed: _loginEmail,
                          isLoading: auth.isLoading,
                        ),
                        SizedBox(height: mediumGap),
                        const DividerWithText(text: 'OR'),
                        SizedBox(height: mediumGap),
                        GoogleSignInButton(
                          onPressed: _loginGoogle,
                          isLoading: auth.isLoading,
                        ),
                        SizedBox(height: largeGap),
                        _buildRegisterSection(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      label: 'Email Address',
      hint: 'name@couture.com',
      controller: _emailCtrl,
      validator: (v) => (v?.isEmpty ?? true) ? 'Isi emailnya bro' : null,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      label: 'Password',
      hint: '••••••••',
      controller: _passCtrl,
      obscureText: !_showPass,
      suffixIcon: IconButton(
        icon: Icon(
          _showPass ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: _togglePasswordVisibility,
      ),
      validator: (v) => (v?.isEmpty ?? true) ? 'Password jangan lupa' : null,
    );
  }

  Widget _buildRegisterSection() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        runSpacing: 2,
        children: [
          Text(
            'New to FindYourFit?',
            style: GoogleFonts.manrope(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: _goToRegister,
            child: Text(
              'Create an account',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.secondary.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
