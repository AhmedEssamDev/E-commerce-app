import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/core/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shop/features/home/cubit/category_cubit.dart';
import 'package:shop/features/home/cubit/category_state.dart';
import 'package:shop/features/home/cubit/slider/slider_cubit.dart';
import 'package:shop/features/home/cubit/slider/slider_state.dart';
import 'package:shop/features/home/data/repo/home_repo.dart';
import 'package:shop/features/home/views/widgets/custom_search_field.dart';
import 'package:shop/features/home/views/widgets/slider_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Widget categoryItem(CategoriesCubit cubit, int index) {
    return InkWell(
      onTap: () => cubit.onCategoryTapped(index),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: cubit.currentIndex == index
                    ? AppColors.pink
                    : Colors.transparent,
              ),
              image: DecorationImage(
                image: NetworkImage(cubit.categories![index].imagePath ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            cubit.categories![index].title ?? '',
            style: TextStyle(
              color: cubit.currentIndex == index
                  ? AppColors.pink
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesCubit(HomeRepo())..getCategories(),
        ),
        BlocProvider(
          create: (context) => SlidersCubit(SlidersRepo())..getSliders(),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            var cubit = CategoriesCubit.get(context);

            if (state is CategoriesLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.pink),
              );
            }
            if (state is CategoriesError) {
              return Center(child: Text('error_occurred'.tr()));
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: REdgeInsets.only(top: 50, left: 16, right: 16),
                    child: Column(
                      children: [
                        // ✅ Logo
                        Image.asset(AppImages.logo, height: 60.h, width: 111.w),
                        SizedBox(height: 16.h),

                        // ✅ Search
                        CustomSearchField(onChanged: (value) {}),
                        SizedBox(height: 16.h),

                        // ✅ All Featured
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'all_featured'.tr(),
                            style: AppTextStyles.titleText(),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ✅ Categories
                        SizedBox(
                          height: 100.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>
                                categoryItem(cubit, index),
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 10),
                            itemCount: cubit.categories!.length,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ✅ Sliders
                        BlocBuilder<SlidersCubit, SlidersState>(
                          builder: (context, slidersState) {
                            if (slidersState is SlidersLoading) {
                              return SizedBox(
                                height: 180.h,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.pink,
                                  ),
                                ),
                              );
                            }
                            if (slidersState is SlidersSuccess) {
                              return SlidersWidget(
                                sliders: slidersState.sliders,
                              );
                            }
                            return SizedBox();
                          },
                        ),
                        SizedBox(height: 16.h),

                        // ✅ Recommended
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'recommended'.tr(),
                            style: AppTextStyles.titleText(),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),

                // ✅ Products GridView
                SliverPadding(
                  padding: REdgeInsets.only(left: 16, right: 16, bottom: 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var product = cubit
                            .categories![cubit.currentIndex].products![index];
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
                                    Text(product.description ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.sp,
                                        )),
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
                                    RatingBarIndicator(
                                    rating: double.tryParse(product.rating.toString()) ?? 0.0,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18.0,
                                    direction: Axis.horizontal,
                                  ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: cubit
                          .categories![cubit.currentIndex].products!.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 0.75,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: AppColors.pink,
          onPressed: () {},
          child: SvgPicture.asset(
            AppIcons.bag,
            colorFilter: ColorFilter.mode(
              AppColors.backgroundColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}