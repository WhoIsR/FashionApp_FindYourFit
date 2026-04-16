import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Penjelasan: Fungsi main adalah gerbang utama saat aplikasi dijalankan
void main() async {
  // Memastikan jembatan antara Flutter dan mesin utama HP sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // Menghidupkan Firebase sebelum aplikasi menggambar tampilan (runApp)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fashion App',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(child: Text('Fase 1 Selesai nih cuy! Firebase cihuy.')),
      ),
    );
  }
}
