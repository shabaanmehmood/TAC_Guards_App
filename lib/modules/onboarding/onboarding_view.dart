import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';

import '../../data/data/constants/app_theme.dart';
import '../../models/onboarding.dart';
import '../../routes/app_routes.dart';
import '../../widhets/common widgets/buttons/custom_text_button.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import 'components/custom_indicator.dart';
import 'components/onboarding_card.dart';

// class OnboardingView extends StatefulWidget {
//   const OnboardingView({super.key});
//
//   @override
//   State<OnboardingView> createState() => _OnboardingViewState();
// }
//
// class _OnboardingViewState extends State<OnboardingView> {
//   final PageController _pageController = PageController();
//   int _currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     // bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;
//     // SystemChrome.setSystemUIOverlayStyle(
//     //   isDarkMode(context) ? defaultOverlay : customOverlay,
//     // );
//
//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           /// **Top-left logo using GetX**
//           Positioned(
//             top: Get.height * 0.08, // Adjust spacing for status bar
//             left: Get.width * 0.08, // Adjust spacing from left
//             child: Image.asset(
//               AppAssets.kTacLogo,
//               height: Get.height * 0.07, // Adjust size
//               width: Get.width * 0.25,
//               fit: BoxFit.contain,
//             ),
//           ),
//           /// **Main Content**
//           Column(
//             children: [
//               const Spacer(),
//               Expanded(
//                 flex: 4,
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: onboardingList.length,
//                   onPageChanged: (index) {
//                     setState(() {
//                       _currentIndex = index;
//                     });
//                   },
//                   itemBuilder: (context, index) {
//                     return OnboardingCard(
//                       onboarding: onboardingList[index],
//                     );
//                   },
//                 ),
//               ),
//               CustomIndicator(
//                 controller: _pageController,
//                 dotsLength: onboardingList.length,
//               ),
//               SizedBox(height: AppSpacing.twentyFiveVertical),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: CustomTextButton(
//                       onPressed: () {
//                         if (_currentIndex == (onboardingList.length - 1)) {
//                           Get.offAllNamed<dynamic>(AppRoutes.getSignInRoute());
//                         } else {
//                           Get.offAllNamed<dynamic>(AppRoutes.getWelcomeRoute());
//                         }
//                       },
//                       text: _currentIndex == (onboardingList.length - 1) ? '' : 'Skip Now',
//                     ),
//                   ),
//                   const Spacer(),
//                   Expanded(
//                     flex: 2,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: AppSpacing.tenHorizontal),
//                       child: PrimaryButton(
//                         onTap: () {
//                           if (_currentIndex == (onboardingList.length - 1)) {
//                             Get.offAllNamed<dynamic>(AppRoutes.getWelcomeRoute());
//                           } else {
//                             _pageController.nextPage(
//                               duration: const Duration(milliseconds: 500),
//                               curve: Curves.ease,
//                             );
//                           }
//                         },
//                         text: _currentIndex == (onboardingList.length - 1) ? 'Get Started' : '>',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSpacing.thirtyVertical),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentIndex = 0.obs; // ✅ Make it reactive

  void onPageChanged(int index) {
    currentIndex.value = index; // ✅ Update the reactive state
  }

  void onSkip() {
    Get.offAllNamed<dynamic>(AppRoutes.getSignInRoute());
  }

  void onNextPage() {
    if (currentIndex.value == onboardingList.length - 1) {
      Get.offAllNamed<dynamic>(AppRoutes.getSignInRoute());
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  // void onSkip() {
  //   if (currentIndex.value == onboardingList.length - 1) {
  //     Get.offAllNamed<dynamic>(AppRoutes.getSignInRoute());
  //   } else {
  //     Get.offAllNamed<dynamic>(AppRoutes.getWelcomeRoute());
  //   }
  // }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: Padding(
        padding: EdgeInsets.only(right: AppSpacing.twentyHorizontal,
            left: AppSpacing.twentyHorizontal, bottom: AppSpacing.twentyVertical),
        child: Stack(
          children: [
            /// **Top-left logo**
            Positioned(
              top: Get.height * 0.08,
              child: Image.asset(
                AppAssets.kTacHomeScreenLogo,
                height: Get.height * 0.07,
                width: Get.width * 0.25,
                fit: BoxFit.contain,
              ),
            ),
            Column(
              children: [
                const Spacer(),
                Expanded(
                  flex: 4,
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: onboardingList.length,
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (context, index) {
                      return OnboardingCard(
                        onboarding: onboardingList[index],
                      );
                    },
                  ),
                ),
                CustomIndicator(
                  controller: controller.pageController,
                  dotsLength: onboardingList.length,
                ),
                SizedBox(height: AppSpacing.twentyFiveVertical),
                /// **Dynamic Buttons Row**
                Obx(() {
                  bool isLastPage = controller.currentIndex.value == onboardingList.length - 1;
                  return Row(
                    children: [
                      if (!isLastPage) // **Hide "Skip Now" if last page**
                        Expanded(
                          flex: 1,
                          child: CustomTextButton(
                            onPressed: controller.onSkip,
                            text: 'Skip Now',
                          ),
                        ),

                      if (!isLastPage) const Spacer(),
                      Expanded(
                        flex: isLastPage ? 3 : 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.tenHorizontal),
                          child: PrimaryButton(
                            width: Get.width * 0.15,
                            onTap: controller.onNextPage,
                            text: isLastPage ? 'Get Started >' : '>',
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
