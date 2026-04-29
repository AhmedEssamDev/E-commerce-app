import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/core/utils/app_colors.dart';
import 'package:shop/features/home/data/models/sliders_model.dart';

class SlidersWidget extends StatefulWidget {
  final List<SliderModel> sliders;
  const SlidersWidget({super.key, required this.sliders});

  @override
  State<SlidersWidget> createState() => _SlidersWidgetState();
}

class _SlidersWidgetState extends State<SlidersWidget> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180.h,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemCount: widget.sliders.length,
            itemBuilder: (context, index) {
              var slider = widget.sliders[index];
              return Padding(
                padding: REdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: slider.imagePath != null && slider.imagePath!.isNotEmpty
                      ? Image.network(
                          slider.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, _) =>
                              Icon(Icons.image_not_supported),
                        )
                      : Icon(Icons.image_not_supported),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.sliders.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: currentPage == index ? 10.w : 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: currentPage == index ? AppColors.lightPink : Colors.grey,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}