import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/auth/forget_password.dart';
import 'package:tac/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/data/constants/app_assets.dart';
import '../../models/onboarding.dart';
import '../../widhets/common widgets/buttons/TextFormFieldWidget.dart';
import '../../widhets/common widgets/buttons/password_field.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import '../../widhets/common widgets/buttons/primary_container.dart';
import '../onboarding/components/custom_indicator.dart';
import '../onboarding/components/onboarding_card.dart';

class SignInViewController extends GetxController {
  var passwordVisible = false.obs;

  void togglePasswordView() {
    passwordVisible.value = !passwordVisible.value;
  }
}

class SignInView extends StatelessWidget {
  final SignInViewController controller = Get.put(SignInViewController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                        "Login",
                        style: AppTypography.kBold24.copyWith(
                          color: AppColors.kWhite
                        )
                      ),
                      Text(
                        "Welcome Back!",
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
              padding: EdgeInsets.only(top: Get.height * 0.23),
              child: Form(
                child: Column(
                  children: [
                    CustomTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      hintText: 'johnsmith@gmail.com',
                      iconPath: AppAssets.kEmail,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(320)
                      ],
                    ),
                    SizedBox(height: AppSpacing.fifteenVertical),
                    Obx(() => CustomPasswordField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
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
                    )),
                    SizedBox(height: AppSpacing.tenVertical),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CheckboxListTile(
                            onChanged: (value){},
                            value: false,
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('Remember me', style: AppTypography.kLight14.copyWith(
                                color: AppColors.kWhite
                            ),),
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                              onPressed: (){
                                Get.to(ForgetPasswordView());
                              },
                              child: Text(
                                'Forget Password',
                                style: AppTypography.kBold16.copyWith(
                                  color: AppColors.kSkyBlue
                                ),)),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.fifteenVertical,),
                    PrimaryButton(
                      color: AppColors.kSkyBlue,
                      onTap: () {
                        Get.offAllNamed<dynamic>(AppRoutes.getLandingPageRoute());
                        },
                      text: 'Login',
                    ),
                    SizedBox(height: AppSpacing.twentyVertical,),
                    Center(
                      child: Text(
                        'OR',
                        style: AppTypography.kBold16.copyWith(
                          color: AppColors.kSkyBlue,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical,),
                    PrimaryContainer(
                      width: double.maxFinite,
                      color: Colors.transparent,
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
                          style: AppTypography.kBold16.copyWith(
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
