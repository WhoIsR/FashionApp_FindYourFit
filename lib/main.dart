import 'package:fashion_app/core/routes/app_router.dart';
import 'package:fashion_app/core/theme/app_theme.dart';
import 'package:fashion_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Penjelasan: Fungsi main adalah gerbang utama saat aplikasi dijalankan
void main() async {
  // Memastikan jembatan antara Flutter dan mesin utama HP sudah siap
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Menghidupkan Firebase sebelum aplikasi menggambar tampilan (runApp)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
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
