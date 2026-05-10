// ملف: features/cart/cubit/cart_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/home/data/models/category_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  // ✅ القائمة اللي هتخزن المنتجات
  final List<Map<String, dynamic>> _cartItems = [];

  // ========== دوال الكارت ==========

  // ✅ إضافة منتج
  void addToCart(Products product, {int quantity = 1}) {
    // نشوف المنتج موجود قبل كده ولا لأ
    final existingIndex = _cartItems.indexWhere(
      (item) => item['product'].id == product.id,
    );

    if (existingIndex != -1) {
      // موجود → نزود الكمية
      _cartItems[existingIndex]['quantity'] += quantity;
    } else {
      // جديد → نضيفه
      _cartItems.add({
        'product': product,
        'quantity': quantity,
      });
    }

    // إشعار بالتحديث
    emit(CartUpdated(
      items: List.from(_cartItems),
      totalPrice: _calculateTotal(),
      itemCount: _getItemCount(),
    ));
    
    // طباعة عشان نتأكد
    print('✅ تمت الإضافة: ${product.name}');
    print('📦 عدد المنتجات: ${_cartItems.length}');
    print('🛒 المنتجات: ${_cartItems.map((e) => e['product'].name).toList()}');
  }

  // ✅ حذف منتج
  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item['product'].id == productId);
    
    emit(CartUpdated(
      items: List.from(_cartItems),
      totalPrice: _calculateTotal(),
      itemCount: _getItemCount(),
    ));
  }

  // ✅ تفريغ الكارت
  void clearCart() {
    _cartItems.clear();
    emit(CartCleared());
  }

  // ✅ حساب السعر الكلي
  double _calculateTotal() {
    return _cartItems.fold(0, (sum, item) {
      final product = item['product'] as Products;
      final quantity = item['quantity'] as int;
      return sum + ((product.price ?? 0) * quantity);
    });
  }

  // ✅ حساب عدد القطع
  int _getItemCount() {
    return _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  // ========== Getters ==========
  List<Map<String, dynamic>> get items => _cartItems;
  double get totalPrice => _calculateTotal();
  int get itemCount => _getItemCount();
}