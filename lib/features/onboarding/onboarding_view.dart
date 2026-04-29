import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/core/app_router/app_router.dart';
import 'package:shop/core/app_router/app_router_keys.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/core/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class OnboardingData {
  final String title1;
  final String description;
  final String imageUrl;

  OnboardingData({
    required this.title1,
    required this.description,
    required this.imageUrl,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRouterKeys.auth);
    }
  }

  List<OnboardingData> get _pages => [
    OnboardingData(
      title1: 'choose_products'.tr(),
      description: 'onboarding_desc'.tr(),
      imageUrl: AppIcons.onBoarding1,
    ),
    OnboardingData(
      title1: 'make_payment'.tr(),
      description: 'onboarding_desc'.tr(),
      imageUrl: AppIcons.onBoarding2,
    ),
    OnboardingData(
      title1: 'get_your_order'.tr(),
      description: 'onboarding_desc'.tr(),
      imageUrl: AppIcons.onBoarding3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: 
                      () => context.go(AppRouterKeys.auth),
                      child: Text('skip'.tr(),style: AppTextStyles.titleText(),),
                    ),
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Stack(
                                children: [
                                 SvgPicture.asset(
                                    page.imageUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),
                          Text(
                            page.title1,
                            style: AppTextStyles.onBoardingblackText(),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Text(
                              page.description,
                              style: AppTextStyles.onBoardingGreyText(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 160.h),
                        ],
                      );
                    },
                  ),
                ),

                // Dots
                Row(
                  children: [
                    Spacer(flex: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          width: _currentPage == index ? 40 : 8,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.black
                                : AppColors.grey,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                        ),
                      ),
                    ),
                    Spacer(flex: 1,),
                    InkWell(
                      onTap: _nextPage,
                      child: Text( _currentPage == _pages.length - 1 ? 'get_started'.tr() : 'next'.tr(),
                      style:TextStyle(fontSize: 16.sp,color: AppColors.pink,fontFamily: 'Lexend-Deca',fontWeight: FontWeight.w800),)),
                    Spacer(flex: 1,),
                  ],
                ),

                SizedBox(height: 32.h),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
