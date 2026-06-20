import 'package:fashion_app/core/providers/biometric_lock_provider.dart';
import 'package:fashion_app/core/services/biometric_exception.dart';
import 'package:fashion_app/core/services/biometric_service.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeBiometricService implements BiometricAuthService {
  FakeBiometricService({
    required this.available,
    this.shouldThrow = false,
  });

  final bool available;
  final bool shouldThrow;
  int authenticateCalls = 0;

  @override
  Future<bool> isBiometricAvailable() async => available;

  @override
  Future<bool> authenticate({
    String reason = 'Verifikasi untuk membuka aplikasi',
  }) async {
    authenticateCalls++;
    if (shouldThrow) {
      throw const BiometricException(
        code: BiometricErrorCode.userCanceled,
        message: 'Canceled',
        userMessage: 'Autentikasi dibatalkan.',
      );
    }
    return true;
  }
}

void main() {
  test('initialize marks biometric availability from service', () async {
    final service = FakeBiometricService(available: true);
    final provider = BiometricLockProvider(service: service);

    await provider.initialize();

    expect(provider.isBiometricAvailable, isTrue);
    expect(provider.isLocked, isFalse);
  });

  test('lock only locks when biometric is available', () async {
    final service = FakeBiometricService(available: false);
    final provider = BiometricLockProvider(service: service);

    await provider.initialize();
    provider.lock();

    expect(provider.isLocked, isFalse);
  });

  test('unlock clears lock after successful authentication', () async {
    final service = FakeBiometricService(available: true);
    final provider = BiometricLockProvider(service: service);

    await provider.initialize();
    provider.lock();
    await provider.unlock();

    expect(provider.isLocked, isFalse);
    expect(provider.errorMessage, isNull);
    expect(service.authenticateCalls, 1);
  });

  test('unlock keeps lock and stores error message on biometric failure', () async {
    final service = FakeBiometricService(available: true, shouldThrow: true);
    final provider = BiometricLockProvider(service: service);

    await provider.initialize();
    provider.lock();
    await provider.unlock();

    expect(provider.isLocked, isTrue);
    expect(provider.errorMessage, 'Autentikasi dibatalkan.');
  });

  test('requireUnlock only locks once after session is unlocked', () async {
    final service = FakeBiometricService(available: true);
    final provider = BiometricLockProvider(service: service);

    await provider.initialize();
    provider.requireUnlock();

    expect(provider.isLocked, isTrue);

    await provider.unlock();
    provider.requireUnlock();

    expect(provider.isLocked, isFalse);

    provider.lock();

    expect(provider.isLocked, isTrue);
  });
}
