import 'package:local_auth/local_auth.dart';

enum BiometricErrorCode {
  noBiometricHardware,
  notEnrolled,
  temporaryLockout,
  biometricLockout,
  userCanceled,
  systemCanceled,
  unknown,
}

class BiometricException implements Exception {
  final BiometricErrorCode code;
  final String message;
  final String userMessage;

  const BiometricException({
    required this.code,
    required this.message,
    required this.userMessage,
  });

  factory BiometricException.fromLocalAuthException(LocalAuthException e) {
    switch (e.code) {
      case LocalAuthExceptionCode.noBiometricHardware:
      case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
        return const BiometricException(
          code: BiometricErrorCode.noBiometricHardware,
          message: 'Biometric hardware is not available.',
          userMessage: 'Perangkat tidak memiliki sensor biometrik.',
        );
      case LocalAuthExceptionCode.noBiometricsEnrolled:
      case LocalAuthExceptionCode.noCredentialsSet:
        return const BiometricException(
          code: BiometricErrorCode.notEnrolled,
          message: 'No biometric credential is enrolled.',
          userMessage:
              'Belum ada sidik jari atau face unlock tersimpan. Daftarkan di Pengaturan.',
        );
      case LocalAuthExceptionCode.temporaryLockout:
        return const BiometricException(
          code: BiometricErrorCode.temporaryLockout,
          message: 'Biometric authentication is temporarily locked.',
          userMessage:
              'Autentikasi biometrik terkunci sementara. Coba lagi nanti.',
        );
      case LocalAuthExceptionCode.biometricLockout:
        return const BiometricException(
          code: BiometricErrorCode.biometricLockout,
          message: 'Biometric authentication is permanently locked.',
          userMessage:
              'Biometrik terkunci. Buka kunci perangkat dengan PIN terlebih dahulu.',
        );
      case LocalAuthExceptionCode.userCanceled:
      case LocalAuthExceptionCode.userRequestedFallback:
        return const BiometricException(
          code: BiometricErrorCode.userCanceled,
          message: 'User canceled biometric authentication.',
          userMessage: 'Autentikasi dibatalkan.',
        );
      case LocalAuthExceptionCode.systemCanceled:
      case LocalAuthExceptionCode.timeout:
        return const BiometricException(
          code: BiometricErrorCode.systemCanceled,
          message: 'System canceled biometric authentication.',
          userMessage: 'Autentikasi dibatalkan oleh sistem.',
        );
      default:
        return BiometricException(
          code: BiometricErrorCode.unknown,
          message: e.description ?? e.toString(),
          userMessage: 'Autentikasi biometrik belum bisa digunakan.',
        );
    }
  }

  bool get isRetryable =>
      code == BiometricErrorCode.userCanceled ||
      code == BiometricErrorCode.systemCanceled ||
      code == BiometricErrorCode.unknown;

  bool get requiresSettings => code == BiometricErrorCode.notEnrolled;

  bool get requiresFallback =>
      code == BiometricErrorCode.noBiometricHardware ||
      code == BiometricErrorCode.biometricLockout;

  @override
  String toString() => userMessage;
}
