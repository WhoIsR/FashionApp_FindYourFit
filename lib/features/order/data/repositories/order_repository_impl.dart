import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  Map<String, dynamic> _dataMap(dynamic responseData) {
    final body = responseData is Map
        ? Map<String, dynamic>.from(responseData)
        : <String, dynamic>{};
    final data = body['data'];
    return data is Map ? Map<String, dynamic>.from(data) : body;
  }

  List<dynamic> _dataList(dynamic responseData) {
    final body = responseData is Map
        ? Map<String, dynamic>.from(responseData)
        : <String, dynamic>{};
    final data = body['data'];
    if (data is List<dynamic>) return data;
    if (data is Map<String, dynamic>) {
      final orders = data['orders'];
      if (orders is List<dynamic>) return orders;
    }
    final orders = body['orders'];
    return orders is List<dynamic> ? orders : [];
  }

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
      return OrderModel.fromJson(_dataMap(response.data));
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
      return _dataList(response.data)
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
      return OrderModel.fromJson(_dataMap(response.data));
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Gagal mengambil detail order';
    }
  }
}
