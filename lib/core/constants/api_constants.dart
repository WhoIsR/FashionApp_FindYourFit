class ApiConstants {
  // Base URL untuk API
  // Jangan pake localhost atau 127.0.0.1 kalau ngetes di HP/Emulator
  static const String baseUrl = 'http://192.168.18.5:8080/v1';

  // Auth endpoints
  static const String verifyToken = '/auth/verify-token';

  // Product endpoints
  static const String products = '/products';

  // Cart endpoints
  static const String cart = '/cart';

  // Order endpoints
  static const String orders = '/orders';
  static const String checkout = '/orders/checkout';

  // Timeout (Batas waktu nunggu loading, 15 detik)
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
