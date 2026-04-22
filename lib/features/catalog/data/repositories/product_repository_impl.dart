import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // Kurir ke server istilah kata mah. Token JWT otomatis nempel di sini!
      final response = await DioClient.instance.get(ApiConstants.products);

      final List<dynamic> data = response.data['data'];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw e.response?.data['message'] ??
          'Gagal mengambil data produk dari server';
    } catch (e) {
      throw 'Terjadi kesalahan sistem internal';
    }
  }
}
