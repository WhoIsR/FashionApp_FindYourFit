import 'package:fashion_app/core/routes/app_router.dart';
import 'package:fashion_app/core/theme/app_theme.dart';
import 'package:fashion_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:fashion_app/features/catalog/presentation/providers/product_provider.dart';
import 'package:fashion_app/features/cart/presentation/providers/cart_provider.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ), // <-- Tambahin ini
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindYourFit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
    );
  }
}
