import 'package:flutter/material.dart';

import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';

enum OrderStatus { initial, loading, success, error }

enum PaymentCheckStatus { idle, checking, paid, error }

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository;

  OrderStatus _checkoutStatus = OrderStatus.initial;
  OrderStatus _ordersStatus = OrderStatus.initial;
  PaymentCheckStatus _payStatus = PaymentCheckStatus.idle;
  OrderModel? _lastOrder;
  List<OrderModel> _orders = [];
  String? _error;

  OrderProvider({OrderRepository? repository})
    : _repository = repository ?? OrderRepositoryImpl();

  OrderStatus get checkoutStatus => _checkoutStatus;
  OrderStatus get ordersStatus => _ordersStatus;
  PaymentCheckStatus get payStatus => _payStatus;
  OrderModel? get lastOrder => _lastOrder;
  List<OrderModel> get orders => _orders;
  String? get error => _error;
  bool get isCheckingOut => _checkoutStatus == OrderStatus.loading;

  Future<bool> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    _checkoutStatus = OrderStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _lastOrder = await _repository.checkout(
        shippingAddress: shippingAddress,
        notes: notes,
        paymentMethod: paymentMethod,
      );
      _checkoutStatus = OrderStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _checkoutStatus = OrderStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchMyOrders({int page = 1, int limit = 10}) async {
    _ordersStatus = OrderStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _orders = await _repository.getMyOrders(page: page, limit: limit);
      _ordersStatus = OrderStatus.success;
    } catch (e) {
      _error = e.toString();
      _ordersStatus = OrderStatus.error;
    }
    notifyListeners();
  }

  Future<void> checkPaymentStatus(int orderId) async {
    _payStatus = PaymentCheckStatus.checking;
    notifyListeners();

    try {
      _lastOrder = await _repository.getOrderDetail(orderId);
      _payStatus =
          _lastOrder?.status == 'paid' ||
              _lastOrder?.status == 'processing' ||
              _lastOrder?.status == 'delivered'
          ? PaymentCheckStatus.paid
          : PaymentCheckStatus.idle;
    } catch (e) {
      _error = e.toString();
      _payStatus = PaymentCheckStatus.error;
    }
    notifyListeners();
  }

  void resetPaymentStatus() {
    _payStatus = PaymentCheckStatus.idle;
    notifyListeners();
  }
}
