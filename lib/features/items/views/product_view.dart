import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shop/core/utils/app_assets.dart';
import 'package:shop/core/utils/text_styles.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
      padding: REdgeInsets.only(top: 50, left: 24, right: 24),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  child: SvgPicture.asset(AppIcons.back, matchTextDirection: true),
                ),
                SizedBox(width: 125.w),
                Text('Product', style: AppTextStyles.titleText()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}