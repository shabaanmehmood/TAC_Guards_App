
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/widhets/buttons/buttons/buttons.dart';

import '../../data/data/constants/app_assets.dart';
import '../../data/data/constants/app_colors.dart';
import '../../routes/app_routes.dart';

class ReviewSubmitted extends StatelessWidget {
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.twentyHorizontal,
            vertical: AppSpacing.twentyVertical,
          ),
          child: Column(
            children: [
              _appBar(context), // App bar remains at the top
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers all widgets
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: Get.height * 0.1,
                      width: Get.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green.withOpacity(0.3),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.green,
                        weight: 900,
                        size: 50,
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    Flexible(
                      child: Text(
                        'Your review has been successfully submitted!',
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: AppTypography.kBold24.copyWith(
                          color: AppColors.kWhite,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.thirtyVertical),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Job Title',
                        textAlign: TextAlign.center,
                        style: AppTypography.kBold16.copyWith(color: Colors.grey),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Security Escort for Actor – Airport to Residence',
                        textAlign: TextAlign.center,
                        style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                      ),
                    ),
                    SizedBox(height: AppSpacing.twentyVertical),
                    PrimaryButton(
                      text: 'Submit Review',
                      onTap: () {
                        Get.offAllNamed(AppRoutes.getLandingPageRoute());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _appBar(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          GestureDetector(
            onTap: (){
              Get.back(
                canPop: true,
              );
            },
            child: SizedBox(
                height: 40.0,
                width: 40.0,
                child: Image.asset(AppAssets.kArrowBackward)
            ),
          ),
          SizedBox(width: AppSpacing.fiveHorizontal,),
          Text('Review Submitted', style: AppTypography.kBold18.copyWith(
              color: AppColors.kWhite
          ),)
        ],
      ),
      Divider(
        color: Colors.grey,
      ),
    ],
  );
}