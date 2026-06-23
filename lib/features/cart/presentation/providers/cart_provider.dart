import 'package:flutter/material.dart';
import '../../data/models/cart_model.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';

enum CartStatus { initial, loading, loaded, error }

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;

  CartStatus _status = CartStatus.initial;
  CartModel? _cart;
  String? _error;
  bool _isAdding = false;

  CartProvider({CartRepository? repository})
      : _repository = repository ?? CartRepositoryImpl();

  CartStatus get status => _status;
  CartModel? get cart => _cart;
  List<CartItemModel> get items => _cart?.items ?? [];
  String? get error => _error;
  bool get isAdding => _isAdding;
  double get totalPrice => _cart?.total ?? 0;
  int get totalItems => _cart?.itemCount ?? 0;

  Future<void> fetchCart() async {
    _status = CartStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _cart = await _repository.getCart();
      _status = CartStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = CartStatus.error;
    }
    notifyListeners();
  }

  Future<bool> addToCart(int productId, int quantity) async {
    _isAdding = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.addToCart(productId, quantity);
      await fetchCart();
      _isAdding = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAdding = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateItem(int cartItemId, int quantity) async {
    await _repository.updateCartItem(cartItemId, quantity);
    await fetchCart();
  }

  Future<void> removeItem(int cartItemId) async {
    await _repository.removeCartItem(cartItemId);
    await fetchCart();
  }

  Future<void> clearCart() async {
    await _repository.clearCart();
    _cart = const CartModel(items: [], total: 0, itemCount: 0);
    _status = CartStatus.loaded;
    notifyListeners();
  }
}
