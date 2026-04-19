import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> verifyFirebaseTokenToBackend(String firebaseToken) async {
    try {
      final response = await DioClient.instance.post(
        ApiConstants.verifyToken,
        data: {'firebase_token': firebaseToken},
      );

      final result = AuthResponseModel.fromJson(response.data);
      return result.accessToken;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Gagal menghubungi server';
    }
  }
}
