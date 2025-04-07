import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/auth/set_password.dart';

import '../../data/data/constants/app_assets.dart';
import '../../data/data/constants/app_colors.dart';
import '../../data/data/constants/app_spacing.dart';
import '../../data/data/constants/app_typography.dart';
import '../../routes/app_routes.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';

class SignUpViewController extends GetxController {
  var passwordVisible = false.obs;

  void togglePasswordView() {
    passwordVisible.value = !passwordVisible.value;
  }
}

class SignUpView extends StatelessWidget {
  final SignUpViewController controller = Get.put(SignUpViewController());

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController postalAddressController = TextEditingController();
  TextEditingController masterSecurityIdController = TextEditingController();

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
                    AppAssets.kTacHomeScreenLogo,
                    height: Get.height * 0.07,
                    width: Get.width * 0.25,
                    fit: BoxFit.contain,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Create Account",
                          style: AppTypography.kBold32.copyWith(
                              color: AppColors.kWhite
                          )
                      ),
                      Text(
                          "Get Yourself Registered",
                          style: AppTypography.kBold18.copyWith(
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
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: fullNameController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(320)
                      ],
                      cursorColor: AppColors.kSkyBlue,
                      cursorErrorColor: Colors.red,
                      style: TextStyle(color: AppColors.kWhite),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        isDense: true,
                        fillColor: AppColors.kWhite,
                        hintText: "Full Name",
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(AppAssets.kPerson, color: Colors.grey,),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.fifteenVertical),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(320)
                      ],
                      cursorColor: AppColors.kSkyBlue,
                      cursorErrorColor: Colors.red,
                      style: TextStyle(color: AppColors.kWhite),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        isDense: true,
                        fillColor: AppColors.kWhite,
                        hintText: "johndoe@gmail.com",
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(AppAssets.kEmail, color: Colors.grey,),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.fifteenVertical),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneNumberController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10)
                      ],
                      cursorColor: AppColors.kSkyBlue,
                      cursorErrorColor: Colors.red,
                      style: TextStyle(color: AppColors.kWhite),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        isDense: true,
                        fillColor: AppColors.kWhite,
                        hintText: "Phone Number",
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(AppAssets.kPhone, color: Colors.grey,),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.fifteenVertical),
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      controller: postalAddressController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(500)
                      ],
                      cursorColor: AppColors.kSkyBlue,
                      cursorErrorColor: Colors.red,
                      style: TextStyle(color: AppColors.kWhite),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        isDense: true,
                        fillColor: AppColors.kWhite,
                        hintText: "Postal Address",
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(AppAssets.kLocation, color: Colors.grey,),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.fifteenVertical),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: masterSecurityIdController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(14)
                      ],
                      cursorColor: AppColors.kSkyBlue,
                      cursorErrorColor: Colors.red,
                      style: TextStyle(color: AppColors.kWhite),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        isDense: true,
                        fillColor: AppColors.kWhite,
                        hintText: "Master Security License ",
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(AppAssets.kPersonalCard, color: Colors.grey,),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.fifteenVertical),
                    TextFormField(
                      cursorColor: AppColors.kSkyBlue,
                      cursorErrorColor: Colors.red,
                      style: TextStyle(color: AppColors.kWhite),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        isDense: true,
                        fillColor: AppColors.kWhite,
                        hintText: "Upload Photo ID",
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15),
                          child: SvgPicture.asset(AppAssets.kGalleryAdd, color: Colors.grey,),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.thirtyVertical,),
                    PrimaryButton(
                      color: AppColors.kSkyBlue,
                      onTap: () {
                        Get.to(() => SetPasswordView());
                      },
                      text: 'Continue & Set Password',
                    ),
                    SizedBox(height: AppSpacing.twentyVertical,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
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
