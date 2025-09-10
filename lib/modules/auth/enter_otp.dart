// import 'dart:ffi';

// import 'package:flutter/services.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'package:tac/modules/auth/forget_password.dart';
// import 'package:tac/modules/auth/reset_password.dart';
// import 'package:tac/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../data/data/constants/app_assets.dart';
// import '../../dataproviders/api_service.dart';
// import '../../models/onboarding.dart';
// import '../../widhets/common widgets/buttons/custom_icon_button.dart';
// import '../../widhets/common widgets/buttons/primary_button.dart';
// import '../onboarding/components/custom_indicator.dart';
// import '../onboarding/components/onboarding_card.dart';

// class EnterOtpViewController extends GetxController {

//   // void updateOtp() {
//   //   controller.otpCode.value = otpControllers.map((controller) => controller.text).join();
//   // }

//   // void verifyOtp() {
//   //   if (otpCode.value.length == 4) {
//   //     print("Entered OTP: ${otpCode.value}");
//   //     // Call API or verification logic here
//   //   } else {
//   //     print("Please enter a valid 6-digit OTP");
//   //   }
//   // }

// }

// class EnterOtpView extends StatelessWidget {
//   final ForgetPasswordViewController controller = Get.find();

//   final List<FocusNode> focusNodes =
//   List.generate(4, (index) => FocusNode());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
//         child: Stack(
//           children: [
//             // Logo
//             Positioned(
//               top: Get.height * 0.08,
//               child: Image.asset(
//                 AppAssets.kTacLogo,
//                 height: Get.height * 0.07,
//                 width: Get.width * 0.25,
//                 fit: BoxFit.contain,
//               ),
//             ),

//             // OTP Entry Content
//             Padding(
//               padding: EdgeInsets.only(top: Get.height * 0.20),
//               child: Column(
//                 children: [
//                   // Back Button + Title
//                   Row(
//                     children: [
//                       SizedBox(width: AppSpacing.tenHorizontal),
//                       CustomIconButton(
//                         onTap: () {
//                           Get.back(canPop: true);
//                         },
//                       ),
//                       SizedBox(width: AppSpacing.twentyHorizontal),
//                       Text(
//                         "Enter OTP",
//                         style: AppTypography.kBold32.copyWith(
//                           color: AppColors.kWhite,
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: AppSpacing.tenVertical),

//                   // Description
//                   Row(
//                     children: [
//                       SizedBox(width: AppSpacing.tenHorizontal),
//                       Text(
//                         "Enter OTP received at your registered email",
//                         textAlign: TextAlign.start,
//                         style: AppTypography.kBold18.copyWith(
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: AppSpacing.fifteenVertical),

//                   // OTP Input Field (Custom)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(4, (index) {
//                       return Container(
//                         width: 40,
//                         height: 50,
//                         margin: EdgeInsets.symmetric(horizontal: 5),
//                         // decoration: BoxDecoration(
//                         //   border: Border.all(color: AppColors.kSkyBlue),
//                         //   borderRadius: BorderRadius.circular(8),
//                         // ),
//                         child: TextFormField(
//                           controller: controller.otpControllers[index],
//                           focusNode: focusNodes[index],
//                           keyboardType: TextInputType.number,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: AppColors.kWhite, fontSize: 18),
//                           maxLength: 1,
//                           decoration: const InputDecoration(
//                             counterText: "",
//                             border: UnderlineInputBorder(),
//                           ),
//                           onChanged: (value) {
//                             if (value.isNotEmpty && index < 4) {
//                               FocusScope.of(context).nextFocus();
//                             } else if (value.isEmpty && index > 0) {
//                               FocusScope.of(context).previousFocus();
//                             }
//                           },
//                         ),
//                       );
//                     }),
//                   ),

//                   SizedBox(height: AppSpacing.thirtyVertical),

//                   // Verify Account Button
//                   PrimaryButton(
//                     color: AppColors.kSkyBlue,
//                     onTap: () async {
//                       await controller.verifyOtp();
//                     },
//                     text: 'Verify Account',
//                   ),

//                   SizedBox(height: AppSpacing.twentyVertical),

//                   // Login Option
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Remember your password?',
//                         style: AppTypography.kBold16.copyWith(
//                           color: Colors.grey,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Get.offAllNamed<dynamic>(AppRoutes.getSignInRoute());
//                         },
//                         child: Text(
//                           'Login',
//                           style: AppTypography.kBold18.copyWith(
//                             color: AppColors.kSkyBlue,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const Spacer(),

//                   // Footer Text
//                   Text(
//                     'Powered by TAC Solutions',
//                     style: AppTypography.kLight14.copyWith(
//                       color: Colors.grey,
//                     ),
//                   ),

//                   SizedBox(height: AppSpacing.twentyVertical),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/auth/forget_password.dart';
import 'package:tac/modules/auth/reset_password.dart';
import 'package:tac/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/data/constants/app_assets.dart';
import '../../dataproviders/api_service.dart';
import '../../models/onboarding.dart';
import '../../widhets/common widgets/buttons/custom_icon_button.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import '../onboarding/components/custom_indicator.dart';
import '../onboarding/components/onboarding_card.dart';

class EnterOtpViewController extends GetxController {

}

class EnterOtpView extends StatelessWidget {
  final ForgetPasswordViewController controller = Get.find();

  final List<FocusNode> focusNodes =
  List.generate(4, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent layout changes when keyboard appears
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea( // Use SafeArea to respect device safe areas
        child: Column(
          children: [
            // Main scrollable content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: Get.height * 0.08),
                      // Logo section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          AppAssets.kTacLogo,
                          height: Get.height * 0.07,
                          width: Get.width * 0.25,
                          fit: BoxFit.contain,
                        ),
                      ),
                      
                      SizedBox(height: Get.height * 0.05),
                      
                      // OTP Entry Content
                      Column(
                        children: [
                          // Back Button + Title
                          Row(
                            children: [
                              SizedBox(width: AppSpacing.tenHorizontal),
                              CustomIconButton(
                                onTap: () {
                                  Get.back(canPop: true);
                                },
                              ),
                              SizedBox(width: AppSpacing.twentyHorizontal),
                              Text(
                                "Enter OTP",
                                style: AppTypography.kBold32.copyWith(
                                  color: AppColors.kWhite,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: AppSpacing.tenVertical),

                          // Description
                          Row(
                            children: [
                              SizedBox(width: AppSpacing.tenHorizontal),
                              Expanded(
                                child: Text(
                                  "Enter OTP received at your registered email",
                                  textAlign: TextAlign.start,
                                  style: AppTypography.kBold18.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: AppSpacing.fifteenVertical),

                          // OTP Input Field (Custom)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Container(
                                width: 40,
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: TextFormField(
                                  controller: controller.otpControllers[index],
                                  focusNode: focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.kWhite, fontSize: 18),
                                  maxLength: 1,
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: UnderlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 3) {
                                      FocusScope.of(context).nextFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      FocusScope.of(context).previousFocus();
                                    }
                                  },
                                ),
                              );
                            }),
                          ),

                          SizedBox(height: AppSpacing.thirtyVertical),

                          // Verify Account Button
                          PrimaryButton(
                            color: AppColors.kSkyBlue,
                            onTap: () async {
                              await controller.verifyOtp();
                            },
                            text: 'Verify Account',
                          ),

                          SizedBox(height: AppSpacing.twentyVertical),

                          // Login Option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Remember your password?',
                                style: AppTypography.kBold16.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.offAllNamed<dynamic>(AppRoutes.getSignInRoute());
                                },
                                child: Text(
                                  'Login',
                                  style: AppTypography.kBold18.copyWith(
                                    color: AppColors.kSkyBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: AppSpacing.twentyVertical),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // "Powered by TAC Solutions" - Fixed at bottom of safe area
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                bottom: AppSpacing.tenVertical,
                top: AppSpacing.fiveVertical,
              ),
              child: Center(
                child: Text(
                  'Powered by TAC Solutions',
                  style: AppTypography.kLight14.copyWith(
                    color: Colors.grey
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}