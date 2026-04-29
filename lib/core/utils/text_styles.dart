import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
 static var lexe = 'Lexend_Deca';
  static TextStyle titleText() {
    return TextStyle(
      fontFamily: lexe,
      color: AppColors.black,
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle onBoardingblackText() {
    return TextStyle(
      fontFamily: lexe,
      color: AppColors.black,
      fontSize: 24.sp,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle onBoardingGreyText() {
    return TextStyle(
      fontFamily: lexe,
      color: AppColors.grey,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }
   static TextStyle authWhiteText() {
    return TextStyle(
      fontFamily: lexe,
      color: AppColors.backgroundColor,
      fontSize: 34.sp,
      fontWeight: FontWeight.w600,
    );
  }
  static TextStyle authblackText() {
    return TextStyle(
      fontFamily: lexe,
      color: AppColors.black,
      fontSize: 36.sp,
      fontWeight: FontWeight.w700,
    );
}
}