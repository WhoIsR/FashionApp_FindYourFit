import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<OrderModel> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    try {
      final response = await DioClient.instance.post(
        ApiConstants.checkout,
        data: {
          'shipping_address': shippingAddress,
          'notes': notes ?? '',
          'payment_method': paymentMethod,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return OrderModel.fromJson(data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Checkout gagal';
    }
  }

  @override
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 10}) async {
    try {
      final response = await DioClient.instance.get(
        ApiConstants.orders,
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Gagal mengambil data order';
    }
  }

  @override
  Future<OrderModel> getOrderDetail(int orderId) async {
    try {
      final response = await DioClient.instance.get(
        '${ApiConstants.orders}/$orderId',
      );
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return OrderModel.fromJson(data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Gagal mengambil detail order';
    }
  }
}
