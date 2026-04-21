class ApiConstants {
  // Base URL untuk API
  // Jangan pakai localhost atau 127.0.0.1 kalau ngetes di HP/Emulator
  static const String baseUrl = 'http://10.0.2.2:8080/v1';

  // Auth endpoints
  static const String verifyToken = '/auth/verify-token';

  // Product endpoints
  static const String products = '/products';

  // Timeout (Batas waktu nunggu loading, 15 detik)
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
