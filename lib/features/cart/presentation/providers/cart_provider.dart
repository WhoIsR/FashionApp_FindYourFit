import 'package:fashion_app/features/catalog/data/models/product_model.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/checkout_repository_impl.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/repositories/checkout_repository.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final CheckoutRepository _checkoutRepo = CheckoutRepositoryImpl();

  // Status checkout (untuk loading indicator)
  bool _isCheckingOut = false;
  String? _checkoutError;

  List<CartItem> get items => _items;
  bool get isCheckingOut => _isCheckingOut;
  String? get checkoutError => _checkoutError;

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addToCart(ProductModel product) {
    // Cek apakah barang sudah ada di keranjang
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // Jika ada, tambahkan quantity
      _items[index].quantity += 1;
    } else {
      // Jika belum ada, masukkan item baru
      _items.add(CartItem(product: product, quantity: 1));
    }

    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Kirim data checkout ke backend Golang
  /// Return true jika sukses, false jika gagal
  Future<bool> checkout() async {
    _isCheckingOut = true;
    _checkoutError = null;
    notifyListeners();

    try {
      await _checkoutRepo.processCheckout(totalPrice, _items);
      // Sukses! Bersihkan keranjang
      _items.clear();
      _isCheckingOut = false;
      notifyListeners();
      return true;
    } catch (e) {
      _checkoutError = e.toString();
      _isCheckingOut = false;
      notifyListeners();
      return false;
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
