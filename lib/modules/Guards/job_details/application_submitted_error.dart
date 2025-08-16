import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/models/job_model.dart';

import '../../../routes/app_routes.dart';

// Application submitted screen with error state
class ApplicationSubmittedScreenError extends StatelessWidget {
  final JobData? jobData;
  final String message; // New field for API message
  ApplicationSubmittedScreenError({super.key, required this.jobData, required this.message}); // require message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.kWhite),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Application Status",
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.red.withOpacity(0.1),
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Application Failed",
                style: AppTypography.kBold20.copyWith(color: AppColors.kWhite),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message!,
                style: AppTypography.kLight16.copyWith(color: AppColors.kgrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // onPressed: () => Get.offAndToNamed(AppRoutes.getLandingPageRoute()),
                  onPressed: () {
                      Get.back(); 
                      Get.back(); 

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kSkyBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Back to Jobs",
                    style: AppTypography.kBold16.copyWith(color: AppColors.kDarkBlue),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: AppTypography.kBold16.copyWith(color: AppColors.kgrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}