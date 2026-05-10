import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/core/custom_widget/custom_button.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/core/utils/text_styles.dart';
import 'package:shop/features/cart/cubit/cart_cubit.dart';
import 'package:shop/features/home/data/models/category_model.dart';
import 'package:shop/features/profile/favorite/cubit/fav_cubit.dart';
import 'package:shop/features/profile/favorite/cubit/fav_state.dart';
import 'package:shop/features/profile/favorite/data/fav_repo.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});
  final Products product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ✅ نوفر FavCubit هنا
      create: (context) => FavCubit(FavRepo()),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(widget.product.name ?? 'product_details'.tr()),
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // ✅ أيقونة المفضلة
            BlocBuilder<FavCubit, FavState>(
              builder: (context, state) {
                final favCubit = context.read<FavCubit>();
                final isLoading = state is FavLoading;
                
                return IconButton(
                  icon: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                      : Icon(
                          widget.product.isFavorite == true
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.product.isFavorite == true
                              ? Colors.red
                              : Colors.grey,
                        ),
                  onPressed: isLoading
                      ? null
                      : () {
                          // ✅ toggle favorite
                          favCubit.toggleFavorite(widget.product.id!);
                          setState(() {
                            widget.product.isFavorite = !(widget.product.isFavorite ?? false);
                          });
                        },
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: REdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المنتج
                Container(
                  width: double.infinity,
                  height: 308.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: widget.product.imagePath != null &&
                            widget.product.imagePath!.isNotEmpty
                        ? Image.network(
                            widget.product.imagePath!,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, _) =>
                                Icon(Icons.image_not_supported, size: 80),
                          )
                        : Icon(Icons.image_not_supported, size: 80),
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // اسم المنتج والتقييم
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.name ?? '',
                        style: AppTextStyles.titleText()?.copyWith(
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    if (widget.product.rating != null)
                      Column(
                        children: [
                          RatingBarIndicator(
                            rating: double.tryParse(
                                widget.product.rating.toString()) ?? 0.0,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 16.0,
                            direction: Axis.horizontal,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '(${widget.product.rating})',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                
                SizedBox(height: 16.h),
                
                // الوصف
                Text(
                  widget.product.description ?? 'no_description'.tr(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // السعر والكمية
                Container(
                  padding: REdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${widget.product.price !* quantity} ${'egp'.tr()}',
                        style: TextStyle(
                          color: AppColors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                      ),
                      Spacer(),
                      _buildQuantityControl(),
                    ],
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // ✅ رسالة نجاح/خطأ المفضلة
                BlocBuilder<FavCubit, FavState>(
                  builder: (context, state) {
                    if (state is FavSuccess) {
                      return Padding(
                        padding: REdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.product.isFavorite == true
                              ? 'added_to_favorites'.tr()
                              : 'removed_from_favorites'.tr(),
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.sp,
                          ),
                        ),
                      );
                    }
                    if (state is FavError) {
                      return Padding(
                        padding: REdgeInsets.only(bottom: 8),
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.sp,
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // ✅ زر الإضافة للعربة
                CustomButton(
                  width: double.infinity,
                  text: 'add_to_cart'.tr(),
                  colorbutton: AppColors.pink,
                  colortext: Colors.white,
                  onTap: () {
                    // ✅ إضافة للعربة
                    final cartCubit = context.read<CartCubit>();
                    cartCubit.addToCart(widget.product, quantity: quantity);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$quantity × ${widget.product.name} ${'added_to_cart'.tr()}'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControl() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (quantity > 1) {
                setState(() => quantity--);
              }
            },
            borderRadius: BorderRadius.circular(4.r),
            child: Container(
              padding: REdgeInsets.all(8),
              decoration: BoxDecoration(
                color: quantity > 1 ? AppColors.lightPink : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
              child: Icon(
                Icons.remove,
                size: 18.sp,
                color: quantity > 1 ? Colors.white : Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$quantity',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() => quantity++);
            },
            borderRadius: BorderRadius.circular(4.r),
            child: Container(
              padding: REdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
              ),
              child: Icon(
                Icons.add,
                size: 18.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}