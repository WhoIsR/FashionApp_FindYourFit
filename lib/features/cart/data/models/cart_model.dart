class CartProductModel {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  const CartProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: _readInt(json['ID'] ?? json['id']),
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}

class CartItemModel {
  final int id;
  final int productId;
  final CartProductModel product;
  final int quantity;
  final double subtotal;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.product,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = CartProductModel.fromJson(
      json['product'] as Map<String, dynamic>? ?? {},
    );
    final quantity = _readInt(json['quantity'] ?? json['quantit']);
    final apiSubtotal = (json['subtotal'] as num?)?.toDouble() ?? 0.0;
    final subtotal = apiSubtotal > 0 ? apiSubtotal : product.price * quantity;

    return CartItemModel(
      id: _readInt(json['ID'] ?? json['id']),
      productId: _readInt(json['product_id'], fallback: product.id),
      product: product,
      quantity: quantity,
      subtotal: subtotal,
    );
  }
}

int _readInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

class CartModel {
  final List<CartItemModel> items;
  final double total;
  final int itemCount;

  const CartModel({
    required this.items,
    required this.total,
    required this.itemCount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final total = items.fold<double>(0.0, (sum, item) => sum + item.subtotal);
    final itemCount = items.fold<int>(0, (sum, item) => sum + item.quantity);

    return CartModel(items: items, total: total, itemCount: itemCount);
  }
}
