import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';

import '../../../routes/app_routes.dart';

class ReviewSubmittedScreen extends StatelessWidget {
  final bool resultStatus;
  final String responseMessage;
  final String jobTitle;

  const ReviewSubmittedScreen({
    Key? key,
    required this.resultStatus,
    required this.responseMessage,
    required this.jobTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(AppAssets.kBack, width: 24),
          onPressed: () => Get.back(),
        ),
        title: Text(
          resultStatus ? 'Review Submitted' : 'Submission Failed',
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: resultStatus ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                shape: resultStatus ? BoxShape.circle : BoxShape.rectangle,
              ),
              child: Icon(
                resultStatus ? Icons.check : Icons.error,
                size: 48,
                color: resultStatus ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            Text(
              resultStatus ? 'Review Submitted Successfully' : responseMessage,
              textAlign: TextAlign.center,
              style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
            ),
            SizedBox(height: AppSpacing.thirtyVertical),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Title',
                    style: AppTypography.kLight14.copyWith(
                      color: AppColors.ktextlight,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    jobTitle,
                    style: AppTypography.kBold14.copyWith(
                      color: AppColors.kWhite,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.landing, arguments: {'selectedIndex': 2});
                },
                icon: Image.asset(
                  AppAssets.kBack,
                  width: 20,
                  color: AppColors.kDarkBlue,
                ),
                label: Text(
                  'Back to Jobs',
                  style: AppTypography.kBold16
                      .copyWith(color: AppColors.kDarkBlue),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.twentyVertical),
          ],
        ),
      ),
    );
  }
}
