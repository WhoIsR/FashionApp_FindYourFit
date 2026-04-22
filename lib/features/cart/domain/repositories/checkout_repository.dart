import '../models/cart_item.dart';

abstract class CheckoutRepository {
  Future<void> processCheckout(double totalPrice, List<CartItem> items);
}
