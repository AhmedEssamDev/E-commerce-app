import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/core/utils/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isArabic = context.locale.languageCode == 'ar';
    return Scaffold(
      body: Padding(
        padding: REdgeInsets.only(top: 70, left: 24, right: 24),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  child: SvgPicture.asset(AppIcons.back, matchTextDirection: true),
                ),
                SizedBox(width: 125.w),
                Text("settings".tr(), style: AppTextStyles.titleText()),
              ],
            ),
            SizedBox(height: 25.h),
            ListTile(
              title: Text("language".tr()),
              trailing: ToggleButtons(
                isSelected: [isArabic, !isArabic],
                onPressed: (int index) {
                  if (index == 0) {
                    context.setLocale(const Locale('ar'));
                  } else {
                    context.setLocale(const Locale('en'));
                  }
                },
                borderRadius: BorderRadius.circular(10),
                selectedColor: Colors.white,
                fillColor: AppColors.pink,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('AR'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('EN'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
