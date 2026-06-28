import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/repositories/cart_repository.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  String _errorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          fallback;
    }
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          fallback;
    }
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }

  @override
  Future<CartModel> getCart() async {
    try {
      final response = await DioClient.instance.get(ApiConstants.cart);
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return CartModel.fromJson(data);
    } on DioException catch (e) {
      throw _errorMessage(e, 'Gagal mengambil data cart');
    }
  }

  @override
  Future<void> addToCart(int productId, int quantity) async {
    try {
      await DioClient.instance.post(
        ApiConstants.cart,
        data: {'product_id': productId, 'quantity': quantity},
      );
    } on DioException catch (e) {
      throw _errorMessage(e, 'Gagal menambahkan produk ke cart');
    }
  }

  @override
  Future<void> updateCartItem(int cartItemId, int quantity) async {
    try {
      await DioClient.instance.put(
        '${ApiConstants.cart}/$cartItemId',
        data: {'quantity': quantity},
      );
    } on DioException catch (e) {
      throw _errorMessage(e, 'Gagal mengubah quantity cart');
    }
  }

  @override
  Future<void> removeCartItem(int cartItemId) async {
    try {
      await DioClient.instance.delete('${ApiConstants.cart}/$cartItemId');
    } on DioException catch (e) {
      throw _errorMessage(e, 'Gagal menghapus item cart');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await DioClient.instance.delete(ApiConstants.cart);
    } on DioException catch (e) {
      throw _errorMessage(e, 'Gagal mengosongkan cart');
    }
  }
}
