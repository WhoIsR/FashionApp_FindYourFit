# FindYourFit

Aplikasi marketplace fashion berbasis mobile yang dibangun menggunakan **Flutter** sebagai frontend dan **Golang (Gin)** sebagai backend, dengan autentikasi melalui **Firebase Authentication** dan penyimpanan data di **MySQL**.

Proyek ini dikembangkan sebagai tugas mata kuliah **Pemrograman Mobile Lanjutan — Semester 6** dengan fokus pada penerapan Clean Architecture, State Management menggunakan Provider, serta integrasi frontend-backend secara penuh.

---

## Preview

| Splash Screen | Katalog (Dashboard) | Keranjang Belanja |
|---|---|---|
| Tampilan editorial dengan pengecekan sesi otomatis | Layout asimetris, hero banner, kategori filter, dan horizontal scroll | Daftar item dengan kontrol quantity dan checkout |

---

## Fitur Utama

### Autentikasi
- Registrasi akun baru dengan validasi email (wajib verifikasi lewat link email)
- Login menggunakan email & password
- Login menggunakan akun Google (Google Sign-In)
- Pengecekan sesi otomatis di splash screen — user yang sudah login tidak perlu login ulang
- Logout dari halaman profil

### Katalog Produk
- Data produk diambil langsung dari backend Golang via REST API
- Layout editorial premium dengan hero banner full-bleed dan grid asimetris
- Filter kategori produk (All Pieces, Outerwear, Knitwear, Accessories)
- Horizontal scroll katalog untuk eksplorasi produk tambahan
- Indikator stok otomatis:
  - Badge **"LOW STOCK"** muncul di pojok gambar saat stok ≤ 5
  - Banner **"SOLD OUT"** dengan efek darken saat stok habis
  - Tombol Add to Cart otomatis nonaktif untuk produk yang stoknya 0
- Pull-to-refresh untuk memuat ulang data dari server

### Keranjang Belanja
- Menambah produk ke keranjang langsung dari katalog (dengan Snackbar feedback)
- Badge dinamis di ikon keranjang yang menunjukkan jumlah item
- Halaman keranjang dengan:
  - Daftar item beserta gambar, nama, kategori, dan harga
  - Kontrol quantity (tambah/kurang) per item
  - Tombol hapus item
  - Kalkulasi subtotal secara real-time

### Checkout
- Tombol checkout mengirimkan data pesanan ke backend Golang (`POST /v1/checkout`)
- Loading spinner saat proses berlangsung
- Data pesanan tersimpan di tabel `orders` dan `order_items` di MySQL
- Stok produk otomatis berkurang setelah checkout berhasil (dikerjakan di sisi backend via database transaction)
- Dialog konfirmasi "ORDER CONFIRMED" setelah pembayaran berhasil
- Keranjang otomatis dikosongkan setelah checkout sukses
- Penanganan error: jika server tidak merespons atau stok tidak cukup, muncul Snackbar dengan pesan kesalahan

### UI/UX
- Desain editorial high-end terinspirasi dari brand fashion premium
- Efek glassmorphism (blur) pada App Bar dan Bottom Navigation Bar
- Tipografi ganda: **Noto Serif** untuk judul editorial, **Manrope** untuk label dan body text
- Palet warna terkurasi dengan aksen emas dan surface netral
- Navigasi bawah dengan empat tab: Discover, Search, Bag, Profile

---

## Arsitektur

Proyek ini menerapkan **Clean Architecture** dengan pembagian sebagai berikut:

```
lib/
├── main.dart
├── core/
│   ├── constants/        → Konfigurasi API dan palet warna
│   ├── routes/           → Routing terpusat dan AuthGuard
│   ├── services/         → HTTP client (Dio) dan encrypted storage
│   ├── theme/            → Tema global aplikasi
│   └── widgets/          → Widget reusable (ProductCard, CustomButton, dll)
│
└── features/
    ├── auth/             → Registrasi, login, verifikasi email, profil
    │   ├── data/         → Model response dan implementasi repository
    │   ├── domain/       → Kontrak abstrak repository
    │   └── presentation/ → Provider (state), halaman UI
    │
    ├── catalog/          → Pengambilan dan tampilan data produk
    │   ├── data/         → Model produk dan implementasi repository
    │   ├── domain/       → Kontrak abstrak repository
    │   └── presentation/ → Provider (state), halaman dashboard
    │
    └── cart/             → Keranjang belanja dan checkout
        ├── data/         → Implementasi repository checkout
        ├── domain/       → Model CartItem dan kontrak repository
        └── presentation/ → Provider (state), halaman cart, dialog checkout
```

Setiap modul fitur memiliki tiga layer:
- **Data** — Implementasi konkret (HTTP request, JSON parsing)
- **Domain** — Kontrak abstrak dan model bisnis (tidak bergantung pada framework)
- **Presentation** — UI dan state management (Provider + ChangeNotifier)

### State Management

Menggunakan **Provider** dengan `ChangeNotifier`. Terdapat tiga provider utama yang didaftarkan di `main.dart` via `MultiProvider`:

| Provider | Tanggung Jawab |
|---|---|
| `AuthProvider` | Status login, registrasi, verifikasi email, logout |
| `ProductProvider` | Daftar produk dari backend, status loading/error |
| `CartProvider` | Item keranjang, kalkulasi harga, proses checkout |

Setiap perubahan data memanggil `notifyListeners()` agar widget yang menggunakan `context.watch()` otomatis ter-rebuild.

---

## Tech Stack

| Komponen | Teknologi |
|---|---|
| Frontend | Flutter (Dart) |
| Backend | Golang (Gin Framework) |
| Database | MySQL (via GORM) |
| Autentikasi | Firebase Authentication |
| HTTP Client | Dio (dengan interceptor JWT otomatis) |
| State Management | Provider + ChangeNotifier |
| Penyimpanan Lokal | flutter_secure_storage (encrypted) |
| Font | Google Fonts (Noto Serif, Manrope) |

---

## Prasyarat

- Flutter SDK ≥ 3.9
- Dart SDK ≥ 3.9
- Android Studio / VS Code
- Golang ≥ 1.21 (untuk backend)
- MySQL (Laragon atau setara)
- Firebase project yang sudah dikonfigurasi

## Menjalankan Aplikasi

```bash
# 1. Clone repository
git clone https://github.com/WhoIsR/UTS_MobileApps_Fashion_Marketplace_1123150172.git

# 2. Install dependencies
flutter pub get

# 3. Pastikan backend Golang sudah berjalan
# (https://github.com/WhoIsR/bhaa_firebase_backend)

# 4. Jalankan aplikasi
flutter run
```

> **Catatan:** Jika menggunakan emulator Android, base URL backend sudah dikonfigurasi ke `10.0.2.2:8080` (alias untuk `localhost` dari dalam emulator). Jika menggunakan perangkat fisik, sesuaikan IP di `lib/core/constants/api_constants.dart`.

---

## Backend Repository

Backend Golang untuk proyek ini tersedia di repository terpisah:

🔗 [bhaa_firebase_backend](https://github.com/WhoIsR/bhaa_firebase_backend)

---

## Dibuat Oleh

**Radja Satrio Seftiano** — 1123150172  
Pemrograman Mobile Lanjutan, Semester 6  
© 2026
