// ملف: features/cart/data/models/cart_model.dart
import 'package:shop/features/home/data/models/category_model.dart';

class CartItem {
  final Products product;
  int quantity;
  final double totalPrice;

  CartItem({
    required this.product,
    this.quantity = 1,
    double? totalPrice,
  }) : totalPrice = totalPrice ?? (product.price ?? 0) * quantity;

  // تحديث الكمية
  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
    // totalPrice هيتحسب تلقائي من الـ getter
  }

  // تحويل لـ JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': quantity,
      'image': product.imagePath,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json, Products product) {
    return CartItem(
      product: product,
      quantity: json['quantity'] ?? 1,
    );
  }
}