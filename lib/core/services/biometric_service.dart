import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

import 'biometric_exception.dart';

abstract class BiometricAuthService {
  Future<bool> isBiometricAvailable();

  Future<bool> authenticate({
    String reason = 'Verifikasi untuk membuka aplikasi',
  });
}

class BiometricService implements BiometricAuthService {
  final LocalAuthentication _auth;

  BiometricService({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  @override
  Future<bool> isBiometricAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck && isSupported;
  }

  Future<List<BiometricType>> getAvailableBiometrics() {
    return _auth.getAvailableBiometrics();
  }

  @override
  Future<bool> authenticate({
    String reason = 'Verifikasi untuk membuka aplikasi',
  }) async {
    final available = await isBiometricAvailable();
    if (!available) {
      throw const BiometricException(
        code: BiometricErrorCode.noBiometricHardware,
        message: 'Biometric hardware is not available.',
        userMessage: 'Perangkat tidak memiliki sensor biometrik.',
      );
    }

    final types = await getAvailableBiometrics();
    if (types.isEmpty) {
      throw const BiometricException(
        code: BiometricErrorCode.notEnrolled,
        message: 'No biometric credential is enrolled.',
        userMessage:
            'Belum ada sidik jari atau face unlock tersimpan. Daftarkan di Pengaturan.',
      );
    }

    try {
      final result = await _auth.authenticate(
        localizedReason: reason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Verifikasi Diperlukan',
            cancelButton: 'Batal',
            signInHint: 'Tempelkan jari atau arahkan wajah',
          ),
        ],
        biometricOnly: false,
        sensitiveTransaction: true,
        persistAcrossBackgrounding: true,
      );

      if (!result) {
        throw const BiometricException(
          code: BiometricErrorCode.userCanceled,
          message: 'User canceled biometric authentication.',
          userMessage: 'Autentikasi dibatalkan.',
        );
      }

      return true;
    } on LocalAuthException catch (e) {
      throw BiometricException.fromLocalAuthException(e);
    }
  }
}
