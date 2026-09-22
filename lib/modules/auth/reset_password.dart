import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/widhets/common%20widgets/buttons/password_field.dart';

import '../../data/data/constants/app_assets.dart';
import '../../data/data/helpers/validators.dart';
import '../../widhets/common widgets/buttons/custom_icon_button.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import 'forget_password.dart';

class ResetPasswordView extends StatelessWidget {
  final ForgetPasswordViewController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
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
              child: SingleChildScrollView(
                child: Form(
                  key: controller.resetPasswordFormKey,
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
                          Text("Reset Password",
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
                          Text("Set new password here.",
                              textAlign: TextAlign.start,
                              style: AppTypography.kBold18
                                  .copyWith(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(
                        height: AppSpacing.fifteenVertical,
                      ),
                      Obx(() => CustomPasswordField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: controller.passwordController,
                            obscureText: !controller
                                .setPasswordVisible.value,
                            iconPath: AppAssets.kPassword,
                            hintText: "Password",
                            passwordVisible:
                                controller.setPasswordVisible.value,
                            onPressed: () {
                              controller.togglePasswordView();
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(64)
                            ],
                            onChanged: (value) {
                              controller.resetPasswordFormKey.currentState!
                                  .validate();
                            },
                            validator: AppValidators.validateSignupPassword,
                          )),
                      SizedBox(height: AppSpacing.fifteenVertical),
                      Obx(() => CustomPasswordField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: controller.confirmPasswordController,
                            obscureText: !controller
                                .setConfirmPasswordVisible.value,
                            iconPath: AppAssets.kPassword,
                            hintText: "Confirm Password",
                            passwordVisible:
                                controller.setConfirmPasswordVisible.value,
                            onPressed: () {
                              controller.toggleConfirmPasswordView();
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(64)
                            ],
                            onChanged: (value) {
                              controller.resetPasswordFormKey.currentState!
                                  .validate();
                            },
                            validator: (value) =>
                                AppValidators.validateConfirmPassword(
                                    value, controller.passwordController.text),
                          )),
                      SizedBox(height: AppSpacing.thirtyVertical),
                      PrimaryButton(
                        color: AppColors.kSkyBlue,
                        onTap: () async {
                          await controller.resetPassword();
                        },
                        text: 'Update Password',
                      ),
                      SizedBox(
                        height: AppSpacing.twentyVertical,
                      ),
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
                              Get.offAllNamed<dynamic>(
                                  AppRoutes.getSignInRoute());
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
                      SizedBox(
                        height: AppSpacing.fifteenVertical,
                      ),
                      Text(
                        'Powered by Control1 Security',
                        style: AppTypography.kLight14.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: AppSpacing.twentyVertical),
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
