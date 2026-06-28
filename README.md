# FindYourFit

Proyek Ujian Akhir Semester mata kuliah Aplikasi Mobile Lanjutan. Repository ini
berisi aplikasi Flutter **FindYourFit** sebagai E-Commerce atau merchant.

Aplikasi ini **terintegrasi dengan EMoney** sebagai sistem pembayaran digital
(App-to-App via Deep Link). Repository EMoney terpisah:

➡️ [github.com/WhoIsR/EMoney-MobileApp.git](https://github.com/WhoIsR/EMoney-MobileApp.git)

FindYourFit tetap terhubung ke wallet tersebut melalui integrasi App-to-App
menggunakan Deep Link.

## Fitur Aplikasi

### FindYourFit

- Registrasi dan login menggunakan Firebase Authentication.
- Login menggunakan akun Google.
- Katalog dan pencarian produk fashion.
- Keranjang belanja yang terhubung ke Backend API.
- Checkout dan riwayat order.
- Pembayaran Virtual Account, GoPay, dan Dompet Kampus Global.
- Pengiriman permintaan pembayaran melalui `dompetkampus://pay`.
- Penerimaan callback melalui `findyourfit://payment-callback`.
- Pengecekan status pembayaran melalui Backend API.
- Dark mode dan pengamanan aplikasi menggunakan biometric.

## Alur Pembayaran

```text
FindYourFit Checkout
        |
        v
dompetkampus://pay
        |
        v
Dompet Kampus menampilkan detail transaksi
        |
        v
PIN dan verifikasi 2FA
        |
        v
Saldo diproses oleh Backend API
        |
        v
findyourfit://payment-callback
        |
        v
FindYourFit memeriksa status order
```

## Arsitektur

### FindYourFit

FindYourFit menggunakan pembagian fitur dengan layer data, domain, dan
presentation. State aplikasi dikelola menggunakan Provider dan
`ChangeNotifier`.

```text
lib/
|-- core/
|   |-- constants/
|   |-- providers/
|   |-- routes/
|   |-- services/
|   |-- theme/
|   `-- widgets/
`-- features/
    |-- auth/
    |-- cart/
    |-- catalog/
    `-- order/
```

## Deep Link

FindYourFit membuka wallet dengan format berikut:

```text
dompetkampus://pay?merchant_id=MCH_FINDYOURFIT
&merchant_name=FindYourFit
&amount=150000
&description=Pembayaran order FindYourFit
&reference=INV-10
&callback=findyourfit://payment-callback
```

Dompet Kampus mengembalikan hasil transaksi menggunakan callback:

```text
findyourfit://payment-callback
?status=success
&reference=INV-10
&transaction_id=TXN25
```

Status callback yang didukung adalah `success`, `failed`, dan `cancelled`.

## Two-Factor Authentication

Setelah PIN dimasukkan, Dompet Kampus meminta kode verifikasi sesuai metode
2FA yang dipilih pengguna:

- **SMTP OTP**: kode dikirim melalui email.
- **TOTP**: kode berasal dari aplikasi authenticator.
- **Firebase notification**: kode dikirim melalui notifikasi perangkat.

Kode verifikasi dan transaksi dikirim ke Backend API. Saldo hanya diproses
setelah verifikasi berhasil.

## Dependensi Utama

### FindYourFit

| Dependensi | Kegunaan |
| --- | --- |
| `provider` | State management |
| `dio` | Komunikasi REST API |
| `firebase_core` | Inisialisasi Firebase |
| `firebase_auth` | Autentikasi pengguna |
| `google_sign_in` | Login Google |
| `flutter_secure_storage` | Penyimpanan token |
| `local_auth` | Biometric authentication |
| `app_links` | Menerima callback Deep Link |
| `url_launcher` | Membuka aplikasi wallet |

## Konfigurasi Backend

Alamat Backend API FindYourFit terdapat pada:

```text
lib/core/constants/api_constants.dart
```

Gunakan alamat IP komputer yang dapat diakses perangkat Android. Jangan
menggunakan `localhost` ketika aplikasi dijalankan pada perangkat fisik.

## Menjalankan Project

### FindYourFit

```bash
flutter pub get
flutter run
```

Kedua aplikasi perlu dipasang pada perangkat atau emulator Android yang sama
agar perpindahan App-to-App dapat diuji.

## Build APK

### FindYourFit

```bash
flutter build apk --debug
```

Hasil build:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## Pengujian

```bash
flutter analyze
flutter test
```

## Screenshot Aplikasi

Screenshot FindYourFit, Dompet Kampus, dan alur pembayaran App-to-App akan
ditambahkan setelah pengujian pada perangkat Android.

## Video Presentasi

Link video presentasi UAS YouTube akan ditambahkan setelah proses demonstrasi
dan perekaman selesai.

## Identitas

**Radja Satrio Seftiano**

**NIM 1123150172**

Teknik Informatika - Semester 6

Institut Teknologi dan Bisnis Bina Sarana Global
