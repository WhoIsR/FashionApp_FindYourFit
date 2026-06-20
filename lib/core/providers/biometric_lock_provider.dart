import 'package:flutter/foundation.dart';

import '../services/biometric_exception.dart';
import '../services/biometric_service.dart';

class BiometricLockProvider extends ChangeNotifier {
  final BiometricAuthService _service;

  bool _isLocked = false;
  bool _isBiometricAvailable = false;
  String? _errorMessage;

  BiometricLockProvider({BiometricAuthService? service})
      : _service = service ?? BiometricService();

  bool get isLocked => _isLocked;
  bool get isBiometricAvailable => _isBiometricAvailable;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _isBiometricAvailable = await _service.isBiometricAvailable();
    notifyListeners();
  }

  void lock() {
    if (_isBiometricAvailable) {
      _isLocked = true;
      notifyListeners();
    }
  }

  Future<void> unlock() async {
    if (!_isBiometricAvailable) {
      _isLocked = false;
      notifyListeners();
      return;
    }

    try {
      await _service.authenticate();
      _isLocked = false;
      _errorMessage = null;
    } on BiometricException catch (e) {
      _errorMessage = e.userMessage;
    } finally {
      notifyListeners();
    }
  }
}
