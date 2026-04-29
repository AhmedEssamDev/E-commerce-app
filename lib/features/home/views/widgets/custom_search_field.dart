import 'package:flutter/material.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomSearchField({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // لون الخلفية
        borderRadius: BorderRadius.circular(15), // انحناء الحواف
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "search_products".tr(),
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: const Icon(Icons.search, color: AppColors.deepgrey), // أيقونة البحث
          border: InputBorder.none, // إخفاء الخط السفلي الافتراضي
          contentPadding: const EdgeInsets.symmetric(vertical: 15), // ضبط المسافات الداخلية
        ),
      ),
    );
  }
}