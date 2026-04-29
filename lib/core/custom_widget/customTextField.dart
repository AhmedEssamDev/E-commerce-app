

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/core/utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obSecure;
  final bool isDescription;
  final bool readOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function()? onTap;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.onTap,
    this.obSecure = false,
    this.isDescription = false,
    this.readOnly = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
 

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: AppColors.grey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextFormField(
        obscureText: widget.obSecure,
        controller: widget.controller,
        validator: widget.validator,
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        minLines: 1,
        maxLines: widget.isDescription ? null : 1,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          prefixStyle: TextStyle(
            color: AppColors.emailcolor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          suffixIcon: widget.suffixIcon,
          suffixStyle: TextStyle(
            color: AppColors.emailcolor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColors.emailcolor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: AppColors.authgrey,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        ),
        // style: AppTextStyles.bodyMediumText(),
      ),
    );
  }
}
