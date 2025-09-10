// import 'dart:ffi';

// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'package:tac/modules/auth/enter_otp.dart';
// import 'package:tac/modules/auth/reset_password.dart';
// import 'package:tac/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/widhets/common%20widgets/buttons/TextFormFieldWidget.dart';

// import '../../data/data/constants/app_assets.dart';
// import '../../dataproviders/api_service.dart';
// import '../../models/onboarding.dart';
// import '../../widhets/common widgets/buttons/custom_icon_button.dart';
// import '../../widhets/common widgets/buttons/primary_button.dart';
// import '../onboarding/components/custom_indicator.dart';
// import '../onboarding/components/onboarding_card.dart';

// class ForgetPasswordViewController extends GetxController {

//   TextEditingController emailController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   //send OTP
//   Future<void> submitForgetPassword() async {
//     if (formKey.currentState!.validate()) {
//       final apiService = MyApIService(); // create instance
//       try{
//         final response = await apiService.sendOtp(
//           emailController.text.toString(),
//         );

//         if (response.statusCode == 200) {
//           debugPrint("data from API ${response.body}");
//           Get.to(() => EnterOtpView());
//         } else {
//           debugPrint("data from API ${response.body}");
//           debugPrint('Error login failed: ${response.body}');
//         }
//       }
//       catch(e){
//         debugPrint('Error Network error: ${e.toString()}');
//       }
//     }
//   }

//   //Enter OTP Screen usage things
//   var otpCode = ''.obs; // Holds the entered OTP
//   List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());
//   GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

//   //verify OTP
//   Future<void> verifyOtp() async {
//     if (formKey.currentState!.validate()) {
//       final apiService = MyApIService(); // create instance
//       try{
//         final response = await apiService.verifyOtp(
//           emailController.text.toString(),
//           otpControllers.map((controller) => controller.text).join().toString(),
//         );

//         if (response.statusCode == 200) {
//           debugPrint("data from API ${response.body}");
//           Get.to(() => ResetPasswordView());
//         } else {
//           debugPrint("data from API ${response.body}");
//           debugPrint('Error verify Otp failed: ${response.body}');
//         }
//       }
//       catch(e){
//         debugPrint('Error Network error: ${e.toString()}');
//       }
//     }
//   }

//   //Reset Password Screen usage things
//   var setPasswordVisible = false.obs;
//   var setConfirmPasswordVisible = false.obs;
//   GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

//   void togglePasswordView() {
//     setPasswordVisible.value = !setPasswordVisible.value;
//   }
//   void toggleConfirmPasswordView() {
//     setConfirmPasswordVisible.value = !setConfirmPasswordVisible.value;
//   }

//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();

//   //reset Password
//   Future<void> resetPassword() async {
//     if (formKey.currentState!.validate()) {
//       final apiService = MyApIService(); // create instance
//       try{
//         final response = await apiService.resetPassword(
//           emailController.text.toString(),
//           passwordController.text.toString(),
//           confirmPasswordController.text.toString(),
//         );

//         if (response.statusCode == 200) {
//           debugPrint("data from API ${response.body}");
//           Get.offAndToNamed(AppRoutes.getLandingPageRoute());
//         } else {
//           debugPrint("data from API ${response.body}");
//           debugPrint('Error Reset Password failed: ${response.body}');
//         }
//       }
//       catch(e){
//         debugPrint('Error Network error: ${e.toString()}');
//       }
//     }
//   }

// }

// class ForgetPasswordView extends StatelessWidget {
//   final ForgetPasswordViewController controller = Get.put(ForgetPasswordViewController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: AppColors.kDarkBlue,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
//         child: Stack(
//           children: [
//             Positioned(
//               top: Get.height * 0.08,
//               child: Image.asset(
//                 AppAssets.kTacLogo,
//                 height: Get.height * 0.07,
//                 width: Get.width * 0.25,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: Get.height * 0.20),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: controller.formKey,
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           SizedBox(width: AppSpacing.tenHorizontal,),
//                           CustomIconButton(
//                             onTap: (){
//                               Get.back(canPop: true);
//                             },
//                           ),
//                           SizedBox(width: AppSpacing.twentyHorizontal,),
//                           Text(
//                               "Forget Password",
//                               style: AppTypography.kBold32.copyWith(
//                                   color: AppColors.kWhite
//                               )
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: AppSpacing.tenVertical,),
//                       Row(
//                         children: [
//                           SizedBox(width: AppSpacing.tenHorizontal,),
//                           Text(
//                               "Reset your password.",
//                               textAlign: TextAlign.start,
//                               style: AppTypography.kBold18.copyWith(
//                                   color: Colors.grey
//                               )
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: AppSpacing.fifteenVertical,),
//                       CustomTextField(
//                         hintText: "Email",
//                         iconPath: AppAssets.kEmail,
//                         controller: controller.emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(320)
//                         ],
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Email is required';
//                           }
//                           if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
//                             return 'Enter a valid email';
//                           }
//                           return null;
//                         },
//                         onChanged: (value) {
//                           controller.formKey.currentState!.validate();
//                         },
//                       ),
//                       SizedBox(height: AppSpacing.thirtyVertical),
//                       PrimaryButton(
//                         color: AppColors.kSkyBlue,
//                         onTap: ()async  {
//                           await controller.submitForgetPassword();
//                         },
//                         text: 'Continue',
//                       ),
//                       SizedBox(height: AppSpacing.twentyVertical,),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Remember your password?',
//                             style: AppTypography.kBold16.copyWith(
//                                 color: Colors.grey
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: (){
//                               Get.offAllNamed<dynamic>(AppRoutes.getSignInRoute());
//                             },
//                             child: Text(
//                               'Login',
//                               style: AppTypography.kBold18.copyWith(
//                                   color: AppColors.kSkyBlue
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: AppSpacing.fifteenVertical,),
//                       Text(
//                         'Powered by TAC Solutions',
//                         style: AppTypography.kLight14.copyWith(
//                             color: Colors.grey
//                         ),
//                       ),
//                       SizedBox(height: AppSpacing.twentyVertical,)
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// FIXED FORGET PASSWORD SCREEN
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/auth/enter_otp.dart';
import 'package:tac/modules/auth/reset_password.dart';
import 'package:tac/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/widhets/common%20widgets/buttons/TextFormFieldWidget.dart';

import '../../data/data/constants/app_assets.dart';
import '../../dataproviders/api_service.dart';
import '../../models/onboarding.dart';
import '../../widhets/common widgets/buttons/custom_icon_button.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import '../onboarding/components/custom_indicator.dart';
import '../onboarding/components/onboarding_card.dart';

class ForgetPasswordViewController extends GetxController {

  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //send OTP
  Future<void> submitForgetPassword() async {
    if (formKey.currentState!.validate()) {
      final apiService = MyApIService(); // create instance
      try{
        final response = await apiService.sendOtp(
          emailController.text.toString(),
        );

        if (response.statusCode == 200) {
          debugPrint("data from API ${response.body}");
          Get.to(() => EnterOtpView());
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint('Error login failed: ${response.body}');
        }
      }
      catch(e){
        debugPrint('Error Network error: ${e.toString()}');
      }
    }
  }

  //Enter OTP Screen usage things
  var otpCode = ''.obs; // Holds the entered OTP
  List<TextEditingController> otpControllers = List.generate(4, (index) => TextEditingController());
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  //verify OTP
  Future<void> verifyOtp() async {
    if (formKey.currentState!.validate()) {
      final apiService = MyApIService(); // create instance
      try{
        final response = await apiService.verifyOtp(
          emailController.text.toString(),
          otpControllers.map((controller) => controller.text).join().toString(),
        );

        if (response.statusCode == 200) {
          debugPrint("data from API ${response.body}");
          Get.to(() => ResetPasswordView());
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint('Error verify Otp failed: ${response.body}');
        }
      }
      catch(e){
        debugPrint('Error Network error: ${e.toString()}');
      }
    }
  }

  //Reset Password Screen usage things
  var setPasswordVisible = false.obs;
  var setConfirmPasswordVisible = false.obs;
  GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  void togglePasswordView() {
    setPasswordVisible.value = !setPasswordVisible.value;
  }
  void toggleConfirmPasswordView() {
    setConfirmPasswordVisible.value = !setConfirmPasswordVisible.value;
  }

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //reset Password
  Future<void> resetPassword() async {
    if (formKey.currentState!.validate()) {
      final apiService = MyApIService(); // create instance
      try{
        final response = await apiService.resetPassword(
          emailController.text.toString(),
          passwordController.text.toString(),
          confirmPasswordController.text.toString(),
        );

        if (response.statusCode == 200) {
          debugPrint("data from API ${response.body}");
          Get.offAndToNamed(AppRoutes.getLandingPageRoute());
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint('Error Reset Password failed: ${response.body}');
        }
      }
      catch(e){
        debugPrint('Error Network error: ${e.toString()}');
      }
    }
  }

}

class ForgetPasswordView extends StatelessWidget {
  final ForgetPasswordViewController controller = Get.put(ForgetPasswordViewController());

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
                      
                      // Form section
                      Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: AppSpacing.tenHorizontal,),
                                CustomIconButton(
                                  onTap: (){
                                    Get.back(canPop: true);
                                  },
                                ),
                                SizedBox(width: AppSpacing.twentyHorizontal,),
                                Text(
                                    "Forget Password",
                                    style: AppTypography.kBold32.copyWith(
                                        color: AppColors.kWhite
                                    )
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.tenVertical,),
                            Row(
                              children: [
                                SizedBox(width: AppSpacing.tenHorizontal,),
                                Text(
                                    "Reset your password.",
                                    textAlign: TextAlign.start,
                                    style: AppTypography.kBold18.copyWith(
                                        color: Colors.grey
                                    )
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.fifteenVertical,),
                            CustomTextField(
                              hintText: "Email",
                              iconPath: AppAssets.kEmail,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(320)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                controller.formKey.currentState!.validate();
                              },
                            ),
                            SizedBox(height: AppSpacing.thirtyVertical),
                            PrimaryButton(
                              color: AppColors.kSkyBlue,
                              onTap: ()async  {
                                await controller.submitForgetPassword();
                              },
                              text: 'Continue',
                            ),
                            SizedBox(height: AppSpacing.twentyVertical,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Remember your password?',
                                  style: AppTypography.kBold16.copyWith(
                                      color: Colors.grey
                                  ),
                                ),
                                TextButton(
                                  onPressed: (){
                                    Get.offAllNamed<dynamic>(AppRoutes.getSignInRoute());
                                  },
                                  child: Text(
                                    'Login',
                                    style: AppTypography.kBold18.copyWith(
                                        color: AppColors.kSkyBlue
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: AppSpacing.twentyVertical),
                          ],
                        ),
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
