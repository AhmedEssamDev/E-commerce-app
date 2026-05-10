import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/core/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  CustomButton({super.key,
   required this.text,
   this.colortext,
   this.colorbutton,
   this.onTap,
   this.width = 279,
   this.fontsize= 23, 
  });
  String text;
  Color? colortext;
  Color? colorbutton;
  VoidCallback? onTap;
  double width;
  double fontsize;
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap ,
      child: Container(
        height: 55.h,
        width: width.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorbutton ,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child:
         Text(text,style: TextStyle(
          fontSize: fontsize.sp,
          color: colortext,
          fontFamily: 'Lexend-Deca',
          fontWeight: FontWeight.w600
         ),)
      ),
    );
  }
}