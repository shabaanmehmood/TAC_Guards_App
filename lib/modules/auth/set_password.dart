// temporary commented for testing
// import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/auth/sign_up_view.dart';
import 'package:tac/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/data/constants/app_assets.dart';
import '../../data/data/helpers/validators.dart';
import '../../models/onboarding.dart';
import '../../widhets/common widgets/buttons/custom_icon_button.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import '../onboarding/components/custom_indicator.dart';
import '../onboarding/components/onboarding_card.dart';

class SetPasswordView extends StatelessWidget {
  final SignUpViewController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.08,
              child: Image.asset(
                AppAssets.kTacLogo,
                height: Get.height * 0.07,
                width: Get.width * 0.25,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.20),
              // padding: EdgeInsets.symmetric(vertical: Get.height * 0.20),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.passwordFormKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: AppSpacing.tenHorizontal,
                          ),
                          CustomIconButton(
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Get.back();
                              }
                            },
                          ),
                          SizedBox(
                            width: AppSpacing.twentyHorizontal,
                          ),
                          Text("Set Password",
                              style: AppTypography.kBold32
                                  .copyWith(color: AppColors.kWhite)),
                        ],
                      ),
                      SizedBox(
                        height: AppSpacing.tenVertical,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: AppSpacing.tenHorizontal,
                          ),
                          Text("Set your password here.",
                              textAlign: TextAlign.start,
                              style: AppTypography.kBold18
                                  .copyWith(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(
                        height: AppSpacing.fifteenVertical,
                      ),
                      Obx(() => TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: controller.passwordController,
                            obscureText: !controller
                                .setPasswordVisible.value,
                            cursorColor: AppColors.kSkyBlue,
                            style: TextStyle(color: AppColors.kWhite),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(64)
                            ],
                            validator: AppValidators.validateSignupPassword,
                            onChanged: (value) {
                              controller.passwordFormKey.currentState!.validate();
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              isDense: true,
                              hintText: "Set Password",
                              hintStyle: TextStyle(color: Colors.grey),
                              counter: const Offstage(),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(15),
                                child: SvgPicture.asset(
                                  AppAssets.kPassword,
                                  color: Colors.grey,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.setPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  controller.togglePasswordView();
                                },
                              ),
                            ),
                          )),
                      SizedBox(height: AppSpacing.fifteenVertical),
                      Obx(() => TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: controller.confirmPasswordController,
                            obscureText: !controller
                                .setConfirmPasswordVisible.value,
                            cursorColor: AppColors.kSkyBlue,
                            style: TextStyle(color: AppColors.kWhite),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(64)
                            ],
                            validator: (value) =>
                                AppValidators.validateConfirmPassword(
                                    value, controller.passwordController.text),
                            onChanged: (value) {
                              controller.passwordFormKey.currentState!.validate();
                            },
                            decoration: InputDecoration(
                              counter: Offstage(),
                              contentPadding: EdgeInsets.all(15),
                              isDense: true,
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(15),
                                child: SvgPicture.asset(
                                  AppAssets.kPassword,
                                  color: Colors.grey,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.setConfirmPasswordVisible.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  controller.toggleConfirmPasswordView();
                                },
                              ),
                            ),
                          )),
                      SizedBox(height: AppSpacing.thirtyVertical),
                      PrimaryButton(
                        color: AppColors.kSkyBlue,
                        onTap: () async {
                          await controller.submitSignup();
                        },
                        text: 'Sign Up',
                      ),
                      SizedBox(
                        height: AppSpacing.twentyVertical,
                      ),
                      Center(
                        child: Text(
                          'By creating account, you agree to our terms and conditions',
                          style: AppTypography.kLight14
                              .copyWith(color: Colors.grey),
                        ),
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
