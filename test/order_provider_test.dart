import 'package:fashion_app/features/order/data/models/order_model.dart';
import 'package:fashion_app/features/order/domain/repositories/order_repository.dart';
import 'package:fashion_app/features/order/presentation/providers/order_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeOrderRepository implements OrderRepository {
  final OrderModel order;
  String? paymentMethod;

  FakeOrderRepository(this.order);

  @override
  Future<OrderModel> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    this.paymentMethod = paymentMethod;
    return order;
  }

  @override
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 10}) async {
    return [order];
  }

  @override
  Future<OrderModel> getOrderDetail(int orderId) async => order;
}

void main() {
  test('checkout stores last order and marks success', () async {
    const order = OrderModel(
      id: 10,
      totalAmount: 200000,
      status: 'pending',
      shippingAddress: 'Jl. Melati',
      notes: '',
      paymentMethod: 'gopay',
      vaNumber: null,
      items: [],
      createdAt: '2026-06-23',
    );
    final repository = FakeOrderRepository(order);
    final provider = OrderProvider(repository: repository);

    final success = await provider.checkout(
      shippingAddress: 'Jl. Melati',
      paymentMethod: 'gopay',
    );

    expect(success, isTrue);
    expect(provider.checkoutStatus, OrderStatus.success);
    expect(provider.lastOrder?.id, 10);
    expect(repository.paymentMethod, 'gopay');
  });
}
