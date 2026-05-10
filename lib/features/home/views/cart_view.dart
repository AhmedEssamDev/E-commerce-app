// ملف: features/cart/views/cart_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/cart/cubit/cart_cubit.dart';
import 'package:shop/features/cart/cubit/cart_state.dart';
import 'package:easy_localization/easy_localization.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_cart'.tr()),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final cart = context.read<CartCubit>();
              if (cart.items.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    cart.clearCart();
                  },
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cart = context.read<CartCubit>();
          
          // ✅ اطبع عشان تتأكد
          print('📱 CartView build - items: ${cart.items.length}');
          
          // لو الكارت فاضي
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100.sp,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'empty_cart'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // ✅ لو فيه منتجات
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: REdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final product = item['product'];
                    final quantity = item['quantity'] as int;
                    
                    return Card(
                      margin: REdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: REdgeInsets.all(12),
                        child: Row(
                          children: [
                            // صورة المنتج
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                product.imagePath ?? '',
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, _) =>
                                    Icon(Icons.image_not_supported),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            
                            // بيانات المنتج
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${product.price * quantity} ${'egp'.tr()}',
                                    style: TextStyle(
                                      color: AppColors.pink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // الكمية
                            Text(
                              'x$quantity',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                            
                            // حذف
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                cart.removeFromCart(product.id!);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // المجموع
              Container(
                padding: REdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      '${'total'.tr()}: ',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Text(
                      '${cart.totalPrice.toStringAsFixed(2)} ${'egp'.tr()}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}