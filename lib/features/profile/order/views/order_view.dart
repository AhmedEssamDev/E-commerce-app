import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/core/utils/text_styles.dart';
import 'package:shop/features/profile/order/cubit/order_cubit.dart';
import 'package:shop/features/profile/order/cubit/order_state.dart';
import 'package:shop/features/profile/order/data/order_repo.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  int selectedTab = 0; // 0: Active, 1: Completed, 2: Cancelled

  final List<String> tabs = ['Active', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(OrdersRepo())..getOrders(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: REdgeInsets.only(top: 16, left: 24, right: 24),
            child: Column(
              children: [
                // ✅ Header
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios, size: 20),
                      ),
                    ),
                    Text('My Orders', style: AppTextStyles.titleText()),
                  ],
                ),
                SizedBox(height: 20.h),

                // ✅ Tabs
                Row(
                  children: List.generate(
                    tabs.length,
                    (index) => GestureDetector(
                      onTap: () => setState(() => selectedTab = index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.only(right: 8.w),
                        padding: REdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selectedTab == index
                              ? AppColors.pink
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: AppColors.pink),
                        ),
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: selectedTab == index
                                ? Colors.white
                                : AppColors.pink,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // ✅ Content
                Expanded(
                  child: BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) {
                      if (state is OrdersLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: AppColors.pink),
                        );
                      }
                      if (state is OrdersError) {
                        return Center(child: Text(state.error));
                      }
                      if (state is OrdersSuccess) {
                        // ✅ اختار الـ list بناءً على الـ tab
                        List<dynamic> currentList = selectedTab == 0
                            ? state.orders.active ?? []
                            : selectedTab == 1
                                ? state.orders.completed ?? []
                                : state.orders.canceled ?? [];

                        // ✅ لو الـ list فاضية
                        if (currentList.isEmpty) {
                          return _emptyWidget(tabs[selectedTab]);
                        }

                        // ✅ لو في orders
                        return ListView.separated(
                          itemCount: currentList.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: REdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(currentList[index].toString()),
                            );
                          },
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Empty Widget
  Widget _emptyWidget(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 120,
            color: AppColors.pink.withOpacity(0.3),
          ),
          SizedBox(height: 20.h),
          Text(
            "You don't have any\n${tabName.toLowerCase()} orders at this time",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.pink,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}