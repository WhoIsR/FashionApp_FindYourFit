abstract class AuthRepository {
  Future<String> verifyFirebaseTokenToBackend(String firebaseToken);
}
