import 'package:fashion_app/features/order/data/models/order_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('OrderModel parses order detail from API json', () {
    final order = OrderModel.fromJson({
      'id': 12,
      'total_amount': 150000,
      'status': 'pending',
      'shipping_address': 'Jl. Mawar No. 1',
      'notes': 'Simpan di pos satpam',
      'payment_method': 'bank_transfer',
      'va_number': '888123456789',
      'items': [
        {
          'product_id': 5,
          'product_name': 'Kemeja Oxford',
          'price': 75000,
          'quantity': 2,
          'subtotal': 150000,
        },
      ],
      'created_at': '2026-06-23T10:00:00Z',
    });

    expect(order.id, 12);
    expect(order.totalAmount, 150000);
    expect(order.status, 'pending');
    expect(order.paymentMethod, 'bank_transfer');
    expect(order.vaNumber, '888123456789');
    expect(order.items.single.productName, 'Kemeja Oxford');
  });
}
