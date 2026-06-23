import 'package:fashion_app/features/cart/data/models/cart_model.dart';
import 'package:fashion_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:fashion_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCartRepository implements CartRepository {
  CartModel cart;
  bool shouldThrow;
  int addedProductId = 0;
  int addedQuantity = 0;

  FakeCartRepository({
    required this.cart,
    this.shouldThrow = false,
  });

  @override
  Future<CartModel> getCart() async {
    if (shouldThrow) throw 'Gagal mengambil cart';
    return cart;
  }

  @override
  Future<void> addToCart(int productId, int quantity) async {
    addedProductId = productId;
    addedQuantity = quantity;
  }

  @override
  Future<void> updateCartItem(int cartItemId, int quantity) async {}

  @override
  Future<void> removeCartItem(int cartItemId) async {}

  @override
  Future<void> clearCart() async {
    cart = const CartModel(items: [], total: 0, itemCount: 0);
  }
}

void main() {
  test('fetchCart loads cart data from repository', () async {
    final repository = FakeCartRepository(
      cart: const CartModel(items: [], total: 0, itemCount: 0),
    );
    final provider = CartProvider(repository: repository);

    await provider.fetchCart();

    expect(provider.status, CartStatus.loaded);
    expect(provider.totalItems, 0);
    expect(provider.items, isEmpty);
  });

  test('addToCart sends product id and refreshes cart', () async {
    final repository = FakeCartRepository(
      cart: const CartModel(items: [], total: 0, itemCount: 0),
    );
    final provider = CartProvider(repository: repository);

    final success = await provider.addToCart(7, 2);

    expect(success, isTrue);
    expect(repository.addedProductId, 7);
    expect(repository.addedQuantity, 2);
    expect(provider.isAdding, isFalse);
  });
}
