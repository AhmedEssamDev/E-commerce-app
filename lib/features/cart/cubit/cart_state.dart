// ملف: features/cart/cubit/cart_state.dart
abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<Map<String, dynamic>> items;
  final double totalPrice;
  final int itemCount;

  CartUpdated({
    required this.items,
    required this.totalPrice,
    required this.itemCount,
  });
}

class CartCleared extends CartState {}