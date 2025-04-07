import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/data/constants/app_assets.dart';
import '../../models/onboarding.dart';
import '../../widhets/common widgets/buttons/custom_icon_button.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import '../onboarding/components/custom_indicator.dart';
import '../onboarding/components/onboarding_card.dart';

class SetPasswordViewController extends GetxController {
  var setPasswordVisible = false.obs;
  var setConfirmPasswordVisible = false.obs;

  void togglePasswordView() {
    setPasswordVisible.value = !setPasswordVisible.value;
  }
  void toggleConfirmPasswordView() {
    setConfirmPasswordVisible.value = !setConfirmPasswordVisible.value;
  }
}

class SetPasswordView extends StatelessWidget {
  final SetPasswordViewController controller = Get.put(SetPasswordViewController());

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
                AppAssets.kTacHomeScreenLogo,
                height: Get.height * 0.07,
                width: Get.width * 0.25,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.20),
              child: Form(
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
                            "Set Password",
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
                            "Set your password here.",
                            textAlign: TextAlign.start,
                            style: AppTypography.kBold18.copyWith(
                                color: Colors.grey
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.fifteenVertical,),
                    Obx(() => TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      obscureText: !controller.setPasswordVisible.value, // Fix here
                      cursorColor: AppColors.kSkyBlue,
                      style: TextStyle(color: AppColors.kWhite),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        isDense: true,
                        hintText: "Set Password",
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(AppAssets.kPassword, color: Colors.grey,),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.setPasswordVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20, color: Colors.grey,
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
                      controller: confirmPasswordController,
                      obscureText: !controller.setConfirmPasswordVisible.value, // Fix here
                      cursorColor: AppColors.kSkyBlue,
                      style: TextStyle(color: AppColors.kWhite),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        isDense: true,
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(AppAssets.kPassword, color: Colors.grey,),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.setConfirmPasswordVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20, color: Colors.grey,
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
                      onTap: () {},
                      text: 'Login',
                    ),
                    SizedBox(height: AppSpacing.twentyVertical,),
                    Center(
                      child: Text(
                        'By creating account, you agree to our terms and conditions',
                        style: AppTypography.kLight14.copyWith(
                          color: Colors.grey
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
