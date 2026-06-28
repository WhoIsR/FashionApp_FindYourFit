import 'package:fashion_app/features/cart/data/models/cart_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CartModel parses items and recalculates total from subtotal', () {
    final cart = CartModel.fromJson({
      'items': [
        {
          'id': 1,
          'product_id': 3,
          'product': {
            'ID': 3,
            'name': 'Sepatu Lari Pro',
            'price': 450000,
            'image_url': 'https://example.com/shoe.jpg',
            'category': 'Running',
          },
          'quantity': 2,
          'subtotal': 900000,
        },
        {
          'id': 2,
          'product_id': 4,
          'product': {
            'id': 4,
            'name': 'Jaket Linen',
            'price': 250000,
            'image_url': 'https://example.com/jacket.jpg',
            'category': 'Outerwear',
          },
          'quantity': 1,
          'subtotal': 0,
        },
      ],
      'total': 1,
      'item_count': 99,
    });

    expect(cart.items, hasLength(2));
    expect(cart.items.first.product.id, 3);
    expect(cart.items.first.subtotal, 900000);
    expect(cart.items.last.subtotal, 250000);
    expect(cart.total, 1150000);
    expect(cart.itemCount, 3);
  });
}
