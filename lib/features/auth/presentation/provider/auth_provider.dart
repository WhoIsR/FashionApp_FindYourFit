import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/services/secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

// Status halaman
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  // Kita panggil implementasi repository disini
  final AuthRepository _repository = AuthRepositoryImpl();

  AuthStatus _status = AuthStatus.initial;
  User? _firebaseUser;
  String? _errorMessage;

  String? _tempEmail;
  String? _tempPassword;

  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  // 1. REGISTER
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = credential.user;

      await _firebaseUser?.updateDisplayName(name);
      await _firebaseUser?.sendEmailVerification();

      _tempEmail = email;
      _tempPassword = password;
      _status = AuthStatus.emailNotVerified;
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message ?? 'Gagal mendaftar');
      return false;
    }
  }

  // 2. CEK EMAIL VERIFICATION (POLLING)
  Future<bool> checkEmailVerified() async {
    await _firebaseUser?.reload();
    _firebaseUser = _auth.currentUser;

    if (_firebaseUser?.emailVerified ?? false) {
      // Re-login buat mancing token baru
      if (_tempEmail != null && _tempPassword != null) {
        await _auth.signInWithEmailAndPassword(
          email: _tempEmail!,
          password: _tempPassword!,
        );
        _tempEmail = null;
        _tempPassword = null;
      }
      return await _verifyTokenToBackend();
    }
    return false;
  }

  // 3. LOGIN EMAIL
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = credential.user;

      if (!(_firebaseUser?.emailVerified ?? false)) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }
      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Email atau password salah');
      return false;
    }
  }

  // 4. LOGIN GOOGLE
  Future<bool> loginWithGoogle() async {
    _setLoading();
    try {
      if (!_isGoogleSignInInitialized) {
        await _googleSignIn.initialize();
        _isGoogleSignInInitialized = true;
      }

      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      if (googleAuth.idToken == null) {
        _setError('Login Google dibatalkan');
        return false;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      _firebaseUser = userCred.user;

      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Gagal login dengan Google');
      return false;
    }
  }

  // 5. TUKAR TOKEN KE GOLANG (PRIVATE)
  Future<bool> _verifyTokenToBackend() async {
    try {
      final firebaseToken = await _firebaseUser?.getIdToken();
      if (firebaseToken == null) throw 'Token tidak valid';

      // Panggil repository buat nembak Golang
      final backendToken = await _repository.verifyFirebaseTokenToBackend(
        firebaseToken,
      );

      // Simpan JWT di brankas
      await SecureStorage.saveToken(backendToken);

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // 6. LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await SecureStorage.clearAll();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
