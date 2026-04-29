import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/core/app_router/app_router_keys.dart';
import 'package:shop/core/custom_widget/custom_button.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/core/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AppImages.background,
          ), // Replace with your image path
          fit: BoxFit.cover, // Fills the entire container
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 400.h),
              Text(
                'auth_title'.tr(),
                style: AppTextStyles.authWhiteText(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Text(
                'auth_subtitle'.tr(),
                style: TextStyle(
                  color: Color(0xffF2F2F2),
                  fontSize: 14.sp,
                  fontFamily: 'Lexend-Deca',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              CustomButton(
                text: 'login'.tr(),
                colorbutton: AppColors.pink,
                colortext: AppColors.backgroundColor,
                onTap: () {
                  context.go(AppRouterKeys.login);
                },
              ),
              SizedBox(height: 15.h),
              CustomButton(
                text: 'register'.tr(),
                colorbutton: AppColors.backgroundColor,
                colortext: AppColors.pink,
                onTap: () {
                  context.go(AppRouterKeys.register);
                },
              ),
            ],
          ),
        ),
      ), // your content here
    );
  }
}
