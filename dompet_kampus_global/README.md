# Dompet Kampus Global

Aplikasi E-Money Flutter untuk proyek UAS Aplikasi Mobile Lanjutan. Aplikasi
ini menerima permintaan pembayaran dari FindYourFit melalui Deep Link,
memverifikasi transaksi menggunakan PIN dan Two-Factor Authentication, lalu
mengirim hasil pembayaran kembali ke aplikasi merchant.

## Fitur

- Login dan registrasi menggunakan Firebase Authentication.
- Informasi saldo dan riwayat transaksi.
- Top up, transfer, dan pembayaran.
- Penerimaan Deep Link `dompetkampus://pay`.
- Konfirmasi detail pembayaran merchant.
- Verifikasi PIN dan 2FA menggunakan SMTP OTP, TOTP, atau notifikasi.
- Callback pembayaran ke `findyourfit://payment-callback`.
- Firebase Cloud Messaging untuk notifikasi transaksi.

## Arsitektur

```text
lib/
|-- core/
|-- data/
|-- domain/
|-- injection/
`-- presentation/
```

Project menggunakan Clean Architecture, BLoC, GetIt, GoRouter, Dio, Firebase,
App Links, dan URL Launcher.

## Menjalankan Aplikasi

```bash
flutter pub get
flutter run
```

Alamat Backend API dapat disesuaikan pada:

```text
lib/core/constants/app_constants.dart
```

## Pengujian

```bash
flutter analyze
flutter test
flutter build apk --debug
```

Hasil APK debug berada pada:

```text
build/app/outputs/flutter-apk/app-debug.apk
```
