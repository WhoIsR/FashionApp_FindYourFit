class AuthResponseModel {
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  AuthResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  // Jembatan dari JSON Golang ke Dart Object
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponseModel(
      accessToken: data['access_token'] as String,
      tokenType: data['token_type'] as String,
      expiresIn: data['expires_in'] as int,
    );
  }
}
