import 'package:fashion_app/features/catalog/data/models/product_model.dart';
import 'package:flutter/material.dart';
import '../../domain/models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

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

    // WAJIB: memanggil notifyListeners agar UI ter-update
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

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
