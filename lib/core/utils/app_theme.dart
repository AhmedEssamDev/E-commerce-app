import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/core/utils/app_colors.dart';

abstract class AppTheme{
  static ThemeData lightTheme = ThemeData(
    colorSchemeSeed: Colors.pink,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      centerTitle: true,
    ),
    useMaterial3: true,
    fontFamily: 'LexendDeca',
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: AppColors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w200,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: AppColors.grey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: AppColors.authgrey,
              width: 1
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: AppColors.pink,
              width: 1
          )
      ),
    ),
  );
}