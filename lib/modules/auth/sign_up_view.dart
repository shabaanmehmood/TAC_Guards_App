import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/auth/set_password.dart';
import 'package:tac/modules/auth/sign_in_view.dart';
import 'package:tac/widhets/common%20widgets/buttons/TextFormFieldWidget.dart';

import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_assets.dart';
import '../../data/data/constants/app_colors.dart';
import '../../data/data/constants/app_spacing.dart';
import '../../data/data/constants/app_typography.dart';
import '../../routes/app_routes.dart';
import '../../widhets/common overlays/uploadFile_overlay.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import 'package:tac/dataproviders/api_service.dart';

class SignUpViewController extends GetxController {
  SignInViewController signInViewController = Get.put(SignInViewController());
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController postalAddressController = TextEditingController();
  TextEditingController masterSecurityIdController = TextEditingController();
  TextEditingController photoIdController = TextEditingController();

  // Password setup
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  String imageBase64 = '';

  var isLoading = false.obs;  // RxBool to track loading state

  var setPasswordVisible = false.obs;
  var setConfirmPasswordVisible = false.obs;

  void togglePasswordView() {
    setPasswordVisible.value = !setPasswordVisible.value;
  }
  void toggleConfirmPasswordView() {
    setConfirmPasswordVisible.value = !setConfirmPasswordVisible.value;
  }

  // ✅ Call this when form 1 is validated
  void savePersonalInfoAndGoNext() {
    if (formKey.currentState!.validate() && imageBase64.isNotEmpty) {
      Get.to(() => SetPasswordView()); // Navigate to screen 2
    }
  }

  Future<void> saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);
  }

  // ✅ Call this when password form is validated
  Future<void> submitSignup() async {
    if (passwordFormKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        debugPrint("password do not match");
        return;
      }

      final apiService = MyApIService(); // create instance
      try{
        final response = await apiService.signUp(
          fullNameController.text.toString(),
          emailController.text.toString(),
          phoneNumberController.text.toString(),
          postalAddressController.text.toString(),
          masterSecurityIdController.text.toString(),
          passwordController.text.toString(),
          imageBase64,
        );

        if (response.statusCode == 201) {
          debugPrint("data from API ${response.body}");
          final loginRespone = await apiService.login(
            emailController.text.toString(),
            passwordController.text.toString(),
            signInViewController.fcmToken!,
          );
          if (loginRespone.statusCode == 200) {
            // Force refresh user data to ensure we have the latest including image
            final userController = Get.find<UserController>();
            await userController.getUserData(); // This will update the user data including image

            Get.offAllNamed(AppRoutes.getLandingPageRoute());
          }
          // await saveLoginSession();
        } else {
          debugPrint('Error Signup failed: ${response.body}');
        }
      }
      catch(e){
        debugPrint('Error Network error: ${e.toString()}');
      }
    }
  }
}

class SignUpView extends StatelessWidget {
  final SignUpViewController controller = Get.put(SignUpViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.kDarkBlue,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.08,
              child: Row(
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
                        "Create Account",
                          style: AppTypography.kBold24.copyWith(
                              color: AppColors.kWhite
                          )
                      ),
                      Text(
                        "Get Yourself Registered",
                          style: AppTypography.kLight14.copyWith(
                              color: Colors.grey
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.18, bottom: AppSpacing.twentyVertical),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        keyboardType: TextInputType.name,
                        controller: controller.fullNameController,
                        iconPath: AppAssets.kPerson,
                        hintText: "Full Name",
                        inputFormatters: [LengthLimitingTextInputFormatter(320)],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.formKey.currentState!.validate();
                        },
                      ),
                      SizedBox(height: AppSpacing.fifteenVertical),
                      CustomTextField(
                        hintText: "johndoe@gmail.com",
                        iconPath: AppAssets.kEmail,
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [LengthLimitingTextInputFormatter(320)],
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
                      SizedBox(height: AppSpacing.fifteenVertical),
                      CustomTextField(
                        hintText: "Phone Number",
                        iconPath: AppAssets.kPhone,
                        controller: controller.phoneNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty || value.length < 10) {
                            return 'Please enter 10 digit phone number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.formKey.currentState!.validate();
                        },
                      ),
                      SizedBox(height: AppSpacing.fifteenVertical),
                      CustomTextField(
                        hintText: "Postal Address",
                        iconPath: AppAssets.kLocation,
                        controller: controller.postalAddressController,
                        keyboardType: TextInputType.streetAddress,
                        inputFormatters: [LengthLimitingTextInputFormatter(500)],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Postal Address is required';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.formKey.currentState!.validate();
                        },
                      ),
                      SizedBox(height: AppSpacing.fifteenVertical),
                      CustomTextField(
                        hintText: "Master Security License",
                        iconPath: AppAssets.kPersonalCard,
                        controller: controller.masterSecurityIdController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(14)],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty || value.length < 14) {
                            return 'Please enter 14 digit master security license #';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.formKey.currentState!.validate();
                        },
                      ),
                      SizedBox(height: AppSpacing.fifteenVertical),
                      CustomTextField(
                        hintText: "Upload Photo ID",
                        iconPath: AppAssets.kGalleryAdd,
                        controller: controller.photoIdController,
                        keyboardType: TextInputType.none,
                        onChanged: (value) {
                          controller.formKey.currentState!.validate();
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Photo ID is required';
                          }
                          return null;
                        },
                        onTap: () async {
                          // pickImageAndConvertToBase64().then((base64Image) {
                          //   if (base64Image != null) {
                          //     controller.imageBase64 = base64Image;
                          //     controller.photoIdController.text = 'Photo ID uploaded';
                          //   } else {
                          //     controller.photoIdController.text = 'No image selected';
                          //   }
                          // });
                          final UploadFileController uploadFileController = Get.put(UploadFileController());
                          String? base64image = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true, showPickFileOption: false);
                          if (base64image != null) {
                            controller.imageBase64 = base64image;
                            controller.photoIdController.text = 'Photo ID uploaded';
                          } else {
                            controller.formKey.currentState!.validate();
                          }
                        },
                        readOnly: true,
                      ),
                      SizedBox(height: AppSpacing.thirtyVertical),
                      PrimaryButton(
                        color: AppColors.kSkyBlue,
                        onTap: ()async  {
                          controller.savePersonalInfoAndGoNext();
                        },
                        text: 'Continue & Set Password',
                      ),
                      SizedBox(height: AppSpacing.twentyVertical),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: AppTypography.kBold16.copyWith(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.offAllNamed<dynamic>(AppRoutes.getSignInRoute());
                            },
                            child: Text(
                              'Login',
                              style: AppTypography.kBold18.copyWith(color: AppColors.kSkyBlue),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.twentyVertical),
                      Text(
                        'Powered by TAC Solutions',
                        style: AppTypography.kLight14.copyWith(color: Colors.grey),
                      ),
                    ],
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
