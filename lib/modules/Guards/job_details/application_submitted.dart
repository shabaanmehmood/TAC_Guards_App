import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/models/job_model.dart';
import 'package:tac/routes/app_routes.dart';

class ApplicationSubmittedScreen extends StatelessWidget {
  final JobData? jobdata;
  final String message;  // New field for API message

  ApplicationSubmittedScreen({super.key, required this.jobdata, required this.message});  // require message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Application Submitted',
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kgreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(24),
                child: Icon(Icons.check, size: 40, color: AppColors.kgreen),
              ),
            ),
            const SizedBox(height: 24),
            // Use dynamic message here instead of fixed text
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
            ),
            // ... rest of your UI unchanged
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Job Title', style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                  const SizedBox(height: 4),
                  Text(jobdata!.title, style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                  const SizedBox(height: 16),
                  Text('Applied On', style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                  const SizedBox(height: 4),
                  Text(DateTime.now().toString(), style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                  const SizedBox(height: 16),
                  Text('Status', style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.kalert,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        message,  // Show the message here as status too
                        style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Get.offAndToNamed(AppRoutes.getLandingPageRoute()); // Navigate to guards page route
                Get.back(); 
                Get.back(); 
                
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.black),
                    const SizedBox(width: 8),
                    Text('Back to Jobs', style: AppTypography.kBold16.copyWith(color: AppColors.kDarkBlue)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
