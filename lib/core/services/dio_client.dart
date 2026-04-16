import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'secure_storage.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        headers: {'Content-type': 'application/json'},
      ),
    );

    // Interceptor 1: Mencatat riwayat (Logging)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (option, handler) async {
          debugPrint('[REQUEST] ${option.method} ${option.path}');
          handler.next(option);
        },
        onResponse: (response, handler) {
          debugPrint('[RESPONSE] ${response.statusCode}');
          handler.next(response);
        },
        onError: (error, handler) async {
          debugPrint('[ERROR] ${error.response?.statusCode}');
          //kalau token kadalauarsa, otomatis hapus token isi storage
          if (error.response?.statusCode == 401) {
            await SecureStorage.clearAll();
          }
          handler.next(error);
        },
      ),
    );

    // Interceptor 2: Nyelipin bearer token di header Authorization otomatis
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
    return dio;
  }
}
