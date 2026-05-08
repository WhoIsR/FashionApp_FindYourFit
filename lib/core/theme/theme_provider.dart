import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // 1. Memori Saklar: Mengatur posisi awal saklar ke Light Mode
  ThemeMode _themeMode = ThemeMode.light;

  // 2. Fungsi untuk membaca status saklar saat ini
  ThemeMode get themeMode => _themeMode;

  // 3. Fungsi bantuan untuk mengecek apakah mode gelap sedang aktif
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // 4. Aksi Utama: Tombol untuk menekan saklar
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark; // Jika terang, ubah ke gelap
    } else {
      _themeMode = ThemeMode.light; // Jika gelap, ubah ke terang
    }

    // 5. Toa Pengumuman: Memberi tahu seluruh aplikasi bahwa saklar telah ditekan
    notifyListeners();
  }
}
