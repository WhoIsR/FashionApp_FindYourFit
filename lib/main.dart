import 'package:fashion_app/core/routes/app_router.dart';
import 'package:fashion_app/core/providers/biometric_lock_provider.dart';
import 'package:fashion_app/core/providers/theme_provider.dart';
import 'package:fashion_app/core/services/global_institute_pay_service.dart';
import 'package:fashion_app/core/theme/app_theme.dart';
import 'package:fashion_app/core/widgets/biometric_lock_screen.dart';
import 'package:fashion_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:fashion_app/features/catalog/presentation/providers/product_provider.dart';
import 'package:fashion_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:fashion_app/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Penjelasan: Fungsi main adalah gerbang utama saat aplikasi dijalankan
void main() async {
  // Memastikan jembatan antara Flutter dan mesin utama HP sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  // Menghidupkan Firebase sebelum aplikasi menggambar tampilan (runApp)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GlobalInstitutePayService.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(
          create: (_) => BiometricLockProvider()..initialize(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'FindYourFit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
      builder: (context, child) {
        return BiometricLockScreen(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
