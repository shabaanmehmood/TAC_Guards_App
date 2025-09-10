// import 'dart:convert';
// import 'dart:ffi';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'package:tac/data/data/constants/constants.dart';
// import 'package:tac/modules/account/components/logoutConstant.dart';
// import 'package:tac/modules/auth/forget_password.dart';
// import 'package:tac/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../data/data/constants/app_assets.dart';
// import '../../dataproviders/api_service.dart';
// import '../../models/onboarding.dart';
// import '../../widhets/common widgets/buttons/TextFormFieldWidget.dart';
// import '../../widhets/common widgets/buttons/adaptive_dialogue.dart';
// import '../../widhets/common widgets/buttons/password_field.dart';
// import '../../widhets/common widgets/buttons/primary_button.dart';
// import '../../widhets/common widgets/buttons/primary_container.dart';
// import 'google_auth.dart';

// class SignInViewController extends GetxController {
//   String? fcmToken;
//   var passwordVisible = false.obs;
//   var rememberMe = false.obs;

//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   final String rememberEmailKey = AppConstants.rememberEmailKey;
//   final String rememberPasswordKey = AppConstants.rememberPasswordKey;
//   final String loginTimeKey = AppConstants.loginTimeKey;

//   void togglePasswordView() {
//     passwordVisible.value = !passwordVisible.value;
//   }

//   void toggleRememberMe(bool? value) {
//     rememberMe.value = value ?? false;
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     // _checkAutoLogin();
//     _initFCM();
//     _listenForTokenRefresh();
//   }

//   Future<void> _initFCM() async {
//     try {
//       fcmToken = await FirebaseMessaging.instance.getToken();
//       debugPrint('Initial FCM Token: $fcmToken');
//     } catch (e) {
//       debugPrint('Failed to get FCM Token: $e');
//     }
//   }

//   void _listenForTokenRefresh() {
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       debugPrint('Refreshed FCM Token: $newToken');
//       fcmToken = newToken;
//       // You may want to update your server/backend here if user is logged in
//     });
//   }

//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }

//   Future<void> _checkAutoLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     final loginTimestamp = prefs.getInt(loginTimeKey);
//     final now = DateTime.now().millisecondsSinceEpoch;

//     if (loginTimestamp != null && (now  - loginTimestamp <= 8 * 60 * 60 * 1000)) {
//       final rememberedEmail = prefs.getString(rememberEmailKey);
//       final rememberedPassword = prefs.getString(rememberPasswordKey);

//       if (rememberedEmail != null && rememberedPassword != null) {
//         emailController.text = rememberedEmail;
//         passwordController.text = rememberedPassword;

//         await submitSignIn(Get.context!, fcmToken, autoLogin: true);
//       }
//     } else {
//       await prefs.remove(rememberEmailKey);
//       await prefs.remove(rememberPasswordKey);
//       await prefs.remove(loginTimeKey);

//       emailController.clear();
//       passwordController.clear();
//       rememberMe.value = false;
//       return;
//     }
//   }


// // in SignInViewController class
// Future<bool> checkAutoLoginAndRedirect() async {
//   final prefs = await SharedPreferences.getInstance();
//   final loginTimestamp = prefs.getInt(loginTimeKey);
//   final now = DateTime.now().millisecondsSinceEpoch;

//   if (loginTimestamp != null && (now - loginTimestamp <= 8 * 60 * 60 * 1000)) {
//     final rememberedEmail = prefs.getString(rememberEmailKey);
//     final rememberedPassword = prefs.getString(rememberPasswordKey);

//     if (rememberedEmail != null && rememberedPassword != null) {
//       // Ensure FCM token is fetched before proceeding
//       if (fcmToken == null) {
//         await _initFCM();
//       }

//       if (fcmToken != null) {
//         final response = await MyApIService().login(
//           rememberedEmail.trim(),
//           rememberedPassword.trim(),
//           fcmToken!, // Use a non-null fcmToken here
//         );

//         if (response.statusCode == 200) {
//           await prefs.setInt(loginTimeKey, DateTime.now().millisecondsSinceEpoch);
//           // Get.offAllNamed(AppRoutes.getLandingPageRoute());
//            Get.offAllNamed(AppRoutes.getLandingPageRoute());
//           return true;
//         }
//       }
//     }
//   }

//   // Clear stale data and return false
//   await prefs.remove(rememberEmailKey);
//   await prefs.remove(rememberPasswordKey);
//   await prefs.remove(loginTimeKey);

//   return false;
// }


// Future<void> saveLoginSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', true);
//     await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);
//   }

// Future<void> submitSignIn(BuildContext context, String? fcmToken, {bool autoLogin = false}) async {
//     if (autoLogin || formKey.currentState!.validate()) {
//       final apiService = MyApIService(); // create instance
//       try{
//         final response = await apiService.login(
//           emailController.text.toString(),
//           passwordController.text.toString(),
//           fcmToken!,
//         );

//         if (response.statusCode == 200) {
//            if (rememberMe.value || autoLogin) {
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.setString(rememberEmailKey, emailController.text.trim());
//             await prefs.setString(rememberPasswordKey, passwordController.text.trim());
//             await prefs.setInt(loginTimeKey, DateTime.now().millisecondsSinceEpoch);
//           }

//           // Get.offAndToNamed(AppRoutes.getLandingPageRoute());
//            Get.offAllNamed(AppRoutes.getLandingPageRoute());
//           // debugPrint("data from API ${response.body}");
//           // Get.offAndToNamed(AppRoutes.getLandingPageRoute());
//           // // await saveLoginSession();
//         } else {
//           debugPrint("data from API ${response.body}");
//           debugPrint("data from API ${response.body}");
//           final Map<String, dynamic> responseBody = jsonDecode(response.body);
//           final String errorMessage = responseBody['message'] ?? 'Unknown error';

//           // Show dialog with one line call
//           if (!autoLogin) {
//             await AdaptiveAlertDialogWidget.show(
//               context,
//               title: 'Login Failed',
//               content: errorMessage,
//               yesText: 'OK',
//               showNoButton: false,
//               onYes: () {
//               // Optional: do something on OK pressed
//             },
//             );
//           }
        
//           debugPrint('Error login failed: ${response.body}');
//         }
//       }

//        catch (e) {
//         if (!autoLogin) {
//            debugPrint('Error Network error: ${e.toString()}');
//           await AdaptiveAlertDialogWidget.show(
//             context,
//             title: 'Network Error',
//             content: e.toString(),
//             yesText: 'OK',
//             showNoButton: false,
//           );
//         }
//       }
     
//     }
//   }

// }

// class SignInView extends StatelessWidget {
//   final SignInViewController controller = Get.put(SignInViewController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: AppColors.kDarkBlue,
//       body: Padding(
//         padding: EdgeInsets.only(
//             left: AppSpacing.twentyHorizontal,
//             right: AppSpacing.twentyHorizontal,
//             bottom: AppSpacing.fiveVertical
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               top: Get.height * 0.08,
//               child: Row(
//                 children: [
//                   Image.asset(
//                     AppAssets.kTacLogo,
//                     height: Get.height * 0.07,
//                     width: Get.width * 0.25,
//                     fit: BoxFit.contain,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Login",
//                         style: AppTypography.customkBold24.copyWith(
//                           color: AppColors.kWhite
//                         )
//                       ),
//                       Text(
//                         "Welcome Back!",
//                         style: AppTypography.customkLight14.copyWith(
//                           color: Colors.grey
//                         )
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: Get.height * 0.23),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: controller.formKey,
//                   child: Column(
//                     children: [
//                       CustomTextField(
//                         keyboardType: TextInputType.emailAddress,
//                         controller: controller.emailController,
//                         hintText: 'johnsmith@gmail.com',
//                         iconPath: AppAssets.kEmail,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(320)
//                         ],
//                         onChanged: (value) {
//                           controller.formKey.currentState!.validate();
//                         },
//                         validator: (value){
//                           if (value == null || value.isEmpty) {
//                             return 'Email is required';
//                           }
//                           if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
//                             return 'Enter a valid email';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: AppSpacing.fifteenVertical),
//                       Obx(() => CustomPasswordField(
//                         keyboardType: TextInputType.visiblePassword,
//                         controller: controller.passwordController,
//                         obscureText: !controller.passwordVisible.value,
//                         hintText: '*********',
//                         iconPath: AppAssets.kPassword,
//                         inputFormatters: [
//                           LengthLimitingTextInputFormatter(64)
//                         ],
//                         passwordVisible: controller.passwordVisible.value,
//                         onPressed: (){
//                           controller.togglePasswordView();
//                         },
//                         validator: (value){
//                           if (value == null || value.isEmpty) {
//                             return 'Password is required';
//                           }
//                           if (value.length < 8) {
//                             return 'Password must be at least 8 characters';
//                           }
//                           return null;
//                         },
//                         onChanged: (value) {
//                           controller.formKey.currentState!.validate();
//                         },
//                       )),
//                       SizedBox(height: AppSpacing.tenVertical),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
                       

//                           Flexible(
//                             child: 
//                           //  CheckboxListTile(
//                           //     value: false,
//                           //     onChanged: (value) {
//                           //       // Handle checkbox state change
//                           //     },
//                           //     contentPadding: EdgeInsets.zero,
//                           //     controlAffinity: ListTileControlAffinity.leading,
//                           //     title: Text('Remember me', style: AppTypography.kLight14.copyWith(
//                           //         color: AppColors.kWhite
//                           //     ),),
//                           //   ),
//                             Obx(() => CheckboxListTile(
//                                   value: controller.rememberMe.value,
//                                   onChanged: controller.toggleRememberMe,
//                                   contentPadding: EdgeInsets.zero,
//                                   controlAffinity: ListTileControlAffinity.leading,
//                                   title: Text(
//                                     'Remember me',
//                                     style: AppTypography.customkLight14.copyWith(color: AppColors.kWhite),
//                                   ),
//                                 )),

//                           ),
//                           Flexible(
//                             child: TextButton(
//                                 onPressed: (){
//                                   Get.to(() => ForgetPasswordView());
//                                 },
//                                 child: Text(
//                                   'Forget Password',
//                                   style: AppTypography.customkBold16.copyWith(
//                                       color: AppColors.kSkyBlue
//                                   ),)),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: AppSpacing.fifteenVertical,),
//                       PrimaryButton(
//                         color: AppColors.kSkyBlue,
//                         onTap: () async {
//                           await controller.submitSignIn(context, controller.fcmToken);
//                         },
//                         text: 'Login',
//                       ),
//                       SizedBox(height: AppSpacing.twentyVertical,),
//                       Center(
//                         child: Text(
//                           'OR',
//                           style: AppTypography.customkBold16.copyWith(
//                             color: AppColors.kSkyBlue,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: AppSpacing.twentyVertical,),
//                       PrimaryContainer(
//                           width: double.maxFinite,
//                           color: Colors.transparent,
//                           child: GestureDetector(
//                             onTap: () async {
//                               final googleAuthService = GoogleAuthService();
//                               await googleAuthService.signInWithGoogle();
//                             },
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   AppAssets.kGoogleLogo,
//                                   fit: BoxFit.contain,
//                                 ),
//                                 SizedBox(width: AppSpacing.twentyHorizontal,),
//                                 Text(
//                                   'Continue with Google',
//                                   style: AppTypography.kBold18.copyWith(
//                                       color: AppColors.kWhite
//                                   ),
//                                 )
//                               ],
//                             ),
//                           )
//                       ),
//                       SizedBox(height: AppSpacing.twentyVertical,),
//                       PrimaryContainer(
//                           width: double.maxFinite,
//                           color: Colors.black,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 AppAssets.kAppleLogo,
//                                 fit: BoxFit.contain,
//                               ),
//                               SizedBox(width: AppSpacing.twentyHorizontal,),
//                               Text(
//                                 'Continue with Apple',
//                                 style: AppTypography.kBold18.copyWith(
//                                     color: AppColors.kWhite
//                                 ),
//                               )
//                             ],
//                           )
//                       ),
//                       SizedBox(height: AppSpacing.thirtyVertical,),
//                       Column(
                        
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Don\'t have an account?',
//                                 style: AppTypography.customkBold16.copyWith(
//                                     color: Colors.grey
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: (){
//                                   Get.toNamed(AppRoutes.getSignUpRoute());
//                                 },
//                                 child: Text(
//                                   'Create Account',
//                                   style: AppTypography.kBold18.copyWith(
//                                       color: AppColors.kSkyBlue
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           Text(
//                             'Powered by TAC Solutions',
//                         style: AppTypography.customkLight14.copyWith(
//                             color: Colors.grey
//                         ),
//                       ),
//                         ],
//                       ),
                      
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


// FIXED SIGNIN SCREEN
import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/account/components/logoutConstant.dart';
import 'package:tac/modules/auth/forget_password.dart';
import 'package:tac/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/data/constants/app_assets.dart';
import '../../dataproviders/api_service.dart';
import '../../models/onboarding.dart';
import '../../widhets/common widgets/buttons/TextFormFieldWidget.dart';
import '../../widhets/common widgets/buttons/adaptive_dialogue.dart';
import '../../widhets/common widgets/buttons/password_field.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import '../../widhets/common widgets/buttons/primary_container.dart';
import 'google_auth.dart';

class SignInViewController extends GetxController {
  String? fcmToken;
  var passwordVisible = false.obs;
  var rememberMe = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final String rememberEmailKey = AppConstants.rememberEmailKey;
  final String rememberPasswordKey = AppConstants.rememberPasswordKey;
  final String loginTimeKey = AppConstants.loginTimeKey;

  void togglePasswordView() {
    passwordVisible.value = !passwordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  @override
  void onInit() {
    super.onInit();
    // _checkAutoLogin();
    _initFCM();
    _listenForTokenRefresh();
  }

  Future<void> _initFCM() async {
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('Initial FCM Token: $fcmToken');
    } catch (e) {
      debugPrint('Failed to get FCM Token: $e');
    }
  }

  void _listenForTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('Refreshed FCM Token: $newToken');
      fcmToken = newToken;
      // You may want to update your server/backend here if user is logged in
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTimestamp = prefs.getInt(loginTimeKey);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (loginTimestamp != null && (now  - loginTimestamp <= 8 * 60 * 60 * 1000)) {
      final rememberedEmail = prefs.getString(rememberEmailKey);
      final rememberedPassword = prefs.getString(rememberPasswordKey);

      if (rememberedEmail != null && rememberedPassword != null) {
        emailController.text = rememberedEmail;
        passwordController.text = rememberedPassword;

        await submitSignIn(Get.context!, fcmToken, autoLogin: true);
      }
    } else {
      await prefs.remove(rememberEmailKey);
      await prefs.remove(rememberPasswordKey);
      await prefs.remove(loginTimeKey);

      emailController.clear();
      passwordController.clear();
      rememberMe.value = false;
      return;
    }
  }

// in SignInViewController class
Future<bool> checkAutoLoginAndRedirect() async {
  final prefs = await SharedPreferences.getInstance();
  final loginTimestamp = prefs.getInt(loginTimeKey);
  final now = DateTime.now().millisecondsSinceEpoch;

  if (loginTimestamp != null && (now - loginTimestamp <= 8 * 60 * 60 * 1000)) {
    final rememberedEmail = prefs.getString(rememberEmailKey);
    final rememberedPassword = prefs.getString(rememberPasswordKey);

    if (rememberedEmail != null && rememberedPassword != null) {
      // Ensure FCM token is fetched before proceeding
      if (fcmToken == null) {
        await _initFCM();
      }

      if (fcmToken != null) {
        final response = await MyApIService().login(
          rememberedEmail.trim(),
          rememberedPassword.trim(),
          fcmToken!, // Use a non-null fcmToken here
        );

        if (response.statusCode == 200) {
          await prefs.setInt(loginTimeKey, DateTime.now().millisecondsSinceEpoch);
          // Get.offAllNamed(AppRoutes.getLandingPageRoute());
           Get.offAllNamed(AppRoutes.getLandingPageRoute());
          return true;
        }
      }
    }
  }

  // Clear stale data and return false
  await prefs.remove(rememberEmailKey);
  await prefs.remove(rememberPasswordKey);
  await prefs.remove(loginTimeKey);

  return false;
}

Future<void> saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);
  }

Future<void> submitSignIn(BuildContext context, String? fcmToken, {bool autoLogin = false}) async {
    if (autoLogin || formKey.currentState!.validate()) {
      final apiService = MyApIService(); // create instance
      try{
        final response = await apiService.login(
          emailController.text.toString(),
          passwordController.text.toString(),
          fcmToken!,
        );

        if (response.statusCode == 200) {
           if (rememberMe.value || autoLogin) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(rememberEmailKey, emailController.text.trim());
            await prefs.setString(rememberPasswordKey, passwordController.text.trim());
            await prefs.setInt(loginTimeKey, DateTime.now().millisecondsSinceEpoch);
          }

          // Get.offAndToNamed(AppRoutes.getLandingPageRoute());
           Get.offAllNamed(AppRoutes.getLandingPageRoute());
          // debugPrint("data from API ${response.body}");
          // Get.offAndToNamed(AppRoutes.getLandingPageRoute());
          // // await saveLoginSession();
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint("data from API ${response.body}");
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          final String errorMessage = responseBody['message'] ?? 'Unknown error';

          // Show dialog with one line call
          if (!autoLogin) {
            await AdaptiveAlertDialogWidget.show(
              context,
              title: 'Login Failed',
              content: errorMessage,
              yesText: 'OK',
              showNoButton: false,
              onYes: () {
              // Optional: do something on OK pressed
            },
            );
          }
        
          debugPrint('Error login failed: ${response.body}');
        }
      }

       catch (e) {
        if (!autoLogin) {
           debugPrint('Error Network error: ${e.toString()}');
          await AdaptiveAlertDialogWidget.show(
            context,
            title: 'Network Error',
            content: e.toString(),
            yesText: 'OK',
            showNoButton: false,
          );
        }
      }
     
    }
  }

}

class SignInView extends StatelessWidget {
  final SignInViewController controller = Get.put(SignInViewController());

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
                      // Header section
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.kTacLogo,
                            height: Get.height * 0.07,
                            width: Get.width * 0.25,
                            fit: BoxFit.contain,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Login",
                                style: AppTypography.customkBold24.copyWith(
                                  color: AppColors.kWhite
                                )
                              ),
                              Text(
                                "Welcome Back!",
                                style: AppTypography.customkLight14.copyWith(
                                  color: Colors.grey
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      SizedBox(height: Get.height * 0.05),
                      
                      // Form section
                      Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: controller.emailController,
                              hintText: 'johnsmith@gmail.com',
                              iconPath: AppAssets.kEmail,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(320)
                              ],
                              onChanged: (value) {
                                controller.formKey.currentState!.validate();
                              },
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: AppSpacing.fifteenVertical),
                            Obx(() => CustomPasswordField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: controller.passwordController,
                              obscureText: !controller.passwordVisible.value,
                              hintText: '*********',
                              iconPath: AppAssets.kPassword,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(64)
                              ],
                              passwordVisible: controller.passwordVisible.value,
                              onPressed: (){
                                controller.togglePasswordView();
                              },
                              validator: (value){
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                controller.formKey.currentState!.validate();
                              },
                            )),
                            SizedBox(height: AppSpacing.tenVertical),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Obx(() => CheckboxListTile(
                                        value: controller.rememberMe.value,
                                        onChanged: controller.toggleRememberMe,
                                        contentPadding: EdgeInsets.zero,
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text(
                                          'Remember me',
                                          style: AppTypography.customkLight14.copyWith(color: AppColors.kWhite),
                                        ),
                                      )),
                                ),
                                Flexible(
                                  child: TextButton(
                                      onPressed: (){
                                        Get.to(() => ForgetPasswordView());
                                      },
                                      child: Text(
                                        'Forget Password',
                                        style: AppTypography.customkBold16.copyWith(
                                            color: AppColors.kSkyBlue
                                        ),)),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.fifteenVertical,),
                            PrimaryButton(
                              color: AppColors.kSkyBlue,
                              onTap: () async {
                                await controller.submitSignIn(context, controller.fcmToken);
                              },
                              text: 'Login',
                            ),
                            SizedBox(height: AppSpacing.twentyVertical,),
                            Center(
                              child: Text(
                                'OR',
                                style: AppTypography.customkBold16.copyWith(
                                  color: AppColors.kSkyBlue,
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.twentyVertical,),
                            PrimaryContainer(
                                width: double.maxFinite,
                                color: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () async {
                                    final googleAuthService = GoogleAuthService();
                                    await googleAuthService.signInWithGoogle();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppAssets.kGoogleLogo,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(width: AppSpacing.twentyHorizontal,),
                                      Text(
                                        'Continue with Google',
                                        style: AppTypography.kBold18.copyWith(
                                            color: AppColors.kWhite
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ),
                            SizedBox(height: AppSpacing.twentyVertical,),
                            PrimaryContainer(
                                width: double.maxFinite,
                                color: Colors.black,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AppAssets.kAppleLogo,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: AppSpacing.twentyHorizontal,),
                                    Text(
                                      'Continue with Apple',
                                      style: AppTypography.kBold18.copyWith(
                                          color: AppColors.kWhite
                                      ),
                                    )
                                  ],
                                )
                            ),
                            SizedBox(height: AppSpacing.thirtyVertical,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Don\'t have an account?',
                                  style: AppTypography.customkBold16.copyWith(
                                      color: Colors.grey
                                  ),
                                ),
                                TextButton(
                                  onPressed: (){
                                    Get.toNamed(AppRoutes.getSignUpRoute());
                                  },
                                  child: Text(
                                    'Create Account',
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
                  style: AppTypography.customkLight14.copyWith(
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
