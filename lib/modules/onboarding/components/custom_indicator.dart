import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../data/data/constants/app_colors.dart';

class CustomIndicator extends StatelessWidget {
  final PageController controller;
  final int dotsLength;
  final double? height;
  final double? width;
  final bool? isExpanding;
  const CustomIndicator({
    required this.controller,
    required this.dotsLength,
    this.height,
    this.width,
    this.isExpanding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode(BuildContext context) =>
        Theme.of(context).brightness == Brightness.dark;

    if(isExpanding == true) {
      return SmoothPageIndicator(
        controller: controller,
        count: dotsLength,
        effect: ExpandingDotsEffect(
          dotColor: AppColors.kSkyBlue,
          activeDotColor: AppColors.kSkyBlue,
          dotHeight: height ?? Get.height * 0.0002,
          dotWidth: width ?? Get.height * 0.0002,
        ),
      );
    } else {
      return SmoothPageIndicator(
        controller: controller,
        count: dotsLength,
        effect: ExpandingDotsEffect(
          dotColor: AppColors.kSkyBlue,
          activeDotColor: AppColors.kPrimary,
          dotHeight: height ?? Get.height * 0.015,
          dotWidth: width ?? Get.width * 0.035,
        ),
      );
    }

  }
}
