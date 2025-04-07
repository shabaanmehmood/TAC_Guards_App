import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/auth/enter_otp.dart';
import 'package:tac/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/data/constants/app_assets.dart';
import '../../models/onboarding.dart';
import '../../widhets/common widgets/buttons/custom_icon_button.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import '../onboarding/components/custom_indicator.dart';
import '../onboarding/components/onboarding_card.dart';

class ForgetPasswordViewController extends GetxController {
  var setPasswordVisible = false.obs;
  var setConfirmPasswordVisible = false.obs;

  void togglePasswordView() {
    setPasswordVisible.value = !setPasswordVisible.value;
  }
  void toggleConfirmPasswordView() {
    setConfirmPasswordVisible.value = !setConfirmPasswordVisible.value;
  }
}

class ForgetPasswordView extends StatelessWidget {
  final ForgetPasswordViewController controller = Get.put(ForgetPasswordViewController());

  TextEditingController emailController = TextEditingController();

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
              padding: EdgeInsets.only(top: Get.height * 0.20),
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
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(320)
                      ],
                      cursorColor: AppColors.kSkyBlue,
                      cursorErrorColor: Colors.red,
                      style: TextStyle(color: AppColors.kWhite),
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        isDense: true,
                        fillColor: AppColors.kWhite,
                        hintText: "Email",
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(AppAssets.kEmail, color: Colors.grey,),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.thirtyVertical),
                    PrimaryButton(
                      color: AppColors.kSkyBlue,
                      onTap: () {
                        Get.to(() => EnterOtpView());
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
                    const Spacer(),
                    Text(
                      'Powered by TAC Solutions',
                      style: AppTypography.kLight14.copyWith(
                          color: Colors.grey
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical,)
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
