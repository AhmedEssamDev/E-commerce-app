// ملف: features/home/views/search_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/home/cubit/search/search_cubit.dart';
import 'package:shop/features/home/cubit/search/search_state.dart';
import 'package:shop/features/home/data/repo/home_repo.dart';
import 'package:shop/features/home/views/widgets/custom_search_field.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(SearchRepo()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('search'.tr()),
          leading: IconButton(
            icon: SvgPicture.asset(AppIcons.back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            var cubit = SearchCubit.get(context);
            
            return Padding(
              padding: REdgeInsets.all(16),
              child: Column(
                children: [
                  // ✅ حقل البحث
                  CustomSearchField(
                    controller: _searchController,
                    onChanged: (value) {
                      cubit.search(value);
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        cubit.search(value);
                      }
                    },
                    autofocus: true, // يفتح الكيبورد تلقائياً
                  ),
                  
                  SizedBox(height: 16.h),
                  _buildResultsCount(state),
                  
                  SizedBox(height: 12.h),
                  // ✅ نتائج البحث
                  Expanded(
                    child: _buildSearchResults(state, cubit),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
Widget _buildResultsCount(SearchState state) {
    // لو لسه في البداية أو البحث فاضي
    if (state is SearchInitial) {
      return SizedBox.shrink(); // ما تظهرش حاجة
    }
    
    // لو جاري التحميل
    if (state is SearchLoading) {
      return Text(
        'searching'.tr(), // "جاري البحث..."
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey,
        ),
      );
    }
    
    // لو فيه خطأ
    if (state is SearchError) {
      return SizedBox.shrink(); // ما تظهرش حاجة
    }
    
    // لو نجح البحث
    if (state is SearchSuccess) {
      final count = state.products.length;
      
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          _getResultsText(count), // دالة بتجيب النص المناسب
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    
    return SizedBox.shrink();
  }

  // ✅ دالة ترجمة العدد
  String _getResultsText(int count) {
    if (count == 0) {
      return 'no_items_found'.tr(); // "لم يتم العثور على منتجات"
    } else if (count == 1) {
      return '1 ${'item'.tr()}'; // "1 منتج"
    } else if (count == 2) {
      return '2 ${'items'.tr()}'; // "2 منتجات"
    } else if (count >= 3 && count <= 10) {
      return '$count ${'items'.tr()}'; // "3-10 منتجات"
    } else {
      return '$count ${'items'.tr()}'; // "11+ منتج"
    }
  }
  Widget _buildSearchResults(SearchState state, SearchCubit cubit) {
    // حالة البداية (مفيش بحث)
    if (state is SearchInitial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80.sp,
              color: Colors.grey[300],
            ),
            SizedBox(height: 16.h),
            Text(
              'search_for_products'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // جاري البحث
    if (state is SearchLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.pink),
      );
    }

    // حدث خطأ
    if (state is SearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              state.message,
              style: TextStyle(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => cubit.search(_searchController.text),
              child: Text('retry'.tr()),
            ),
          ],
        ),
      );
    }

    // نجاح - عرض المنتجات
    if (state is SearchSuccess) {
      // لو مفيش نتائج
      if (state.products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80.sp,
                color: Colors.grey[300],
              ),
              SizedBox(height: 16.h),
              Text(
                'no_results_found'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      // عرض المنتجات في GridView
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 0.75,
        ),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
          return _buildProductCard(product);
        },
      );
    }

    return SizedBox();
  }

  // ✅ بطاقة المنتج
  Widget _buildProductCard(dynamic product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.r),
              ),
              child: product.imagePath != null && 
                     product.imagePath!.isNotEmpty
                  ? Image.network(
                      product.imagePath!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) =>
                          Icon(Icons.image_not_supported),
                    )
                  : Icon(Icons.image_not_supported),
            ),
          ),
          
          // بيانات المنتج
          Padding(
            padding: REdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  product.description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${product.price} ${'egp'.tr()}',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                // التقييم
                if (product.rating != null)
                  RatingBarIndicator(
                    rating: double.tryParse(product.rating.toString()) ?? 0.0,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 14.0,
                    direction: Axis.horizontal,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}