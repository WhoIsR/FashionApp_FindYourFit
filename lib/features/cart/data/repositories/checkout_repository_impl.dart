import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  @override
  Future<void> processCheckout(double totalPrice, List<CartItem> items) async {
    try {
      // Susun data sesuai format yang diharapkan backend Golang
      final payload = {
        'total_price': totalPrice,
        'items': items
            .map(
              (item) => {
                'product_id': item.product.id,
                'quantity': item.quantity,
                'price': item.product.price,
              },
            )
            .toList(),
      };

      await DioClient.instance.post(ApiConstants.checkout, data: payload);
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? 'Gagal mengirim pesanan ke server';
    } catch (e) {
      throw 'Terjadi kesalahan saat checkout: $e';
    }
  }
}
