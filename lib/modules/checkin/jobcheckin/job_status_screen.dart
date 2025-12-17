import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/checkin/jobcheckin/SubmitReviewScreen.dart';
import 'package:tac/modules/jobApplications/my_jobs_view.dart';
import 'package:tac/modules/reviews/review_submitted.dart';

class JobStatusScreenSuccess extends StatelessWidget {
  const JobStatusScreenSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the data passed from JobLiveScreen or ShiftCloseBottomSheet
    final completionData = Get.arguments ?? {};
    final originalApiData = completionData['originalApiData'] ?? {};
    final calculatedData = completionData['calculatedData'] ?? {};
    final earlyClosureReason = completionData['earlyClosureReason'];

    // Extract data from original API response
    final responseBody = originalApiData['responseBody'] ?? {};
    final data = responseBody['data'] ?? {};
    final jobData = data['job'] ?? {};
    final shiftData = data['shift'] ?? {};

    // Extract calculated data
    final workDuration = calculatedData['workDuration'] ?? {};
    final earnings = calculatedData['earnings'] ?? {};
    final closureInfo = calculatedData['closureInfo'] ?? {};
    final isEarlyClosure = closureInfo['isEarlyClosure'] ?? false;

    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.twentyHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: AppSpacing.twentyVertical),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Image.asset(AppAssets.kBack, height: 24),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Job Completed",
                              style: AppTypography.kBold20
                                  .copyWith(color: AppColors.kWhite),
                            )
                          ],
                        ),
                        SizedBox(height: AppSpacing.thirtyVertical),

                        // Success Icon with conditional color
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: isEarlyClosure
                                ? Colors.orange.withOpacity(0.2)
                                : AppColors.kGreenS,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check,
                              size: 36,
                              color: isEarlyClosure
                                  ? Colors.orange
                                  : Colors.green),
                        ),
                        SizedBox(height: AppSpacing.twentyVertical),

                        // Conditional message based on closure type
                        Text(
                          isEarlyClosure
                              ? "Your job has been completed early!"
                              : "Your job has been successfully completed!",
                          textAlign: TextAlign.center,
                          style: AppTypography.kBold18
                              .copyWith(color: AppColors.kWhite),
                        ),

                        // Show early closure reason if applicable
                        if (isEarlyClosure && earlyClosureReason != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Reason: ${earlyClosureReason['selectedReason']}",
                              textAlign: TextAlign.center,
                              style: AppTypography.kLight14
                                  .copyWith(color: Colors.orange),
                            ),
                          ),

                        SizedBox(height: AppSpacing.thirtyVertical),
                        _JobDetailsCard(jobData, shiftData),
                        SizedBox(height: AppSpacing.twentyVertical),
                        _ShiftDetailsCard(
                            workDuration, earnings, shiftData, isEarlyClosure),
                        SizedBox(height: AppSpacing.twentyVertical),
                        _BottomActionButtons(
                            jobData, shiftData, originalApiData),
                        SizedBox(height: AppSpacing.twentyVertical),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _JobDetailsCard(
      Map<String, dynamic> jobData, Map<String, dynamic> shiftData) {
    // Use real data with fallbacks
    String jobTitle = jobData['title']?.toString() ??
        "Security Escort for Actor – Airport to Residence";
    String contractorName =
        shiftData['job']?['contractor']?['name']?.toString() ?? "Hugh Jackman";
    String location = jobData['location']?.toString() ??
        "2972 Westheimer Rd. Santa Ana, Illinois 85486";
    String startTime = shiftData['startTime']?.toString() ?? "9:00 AM";
    String endTime = shiftData['endTime']?.toString() ?? "5:00 PM";

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Job Details",
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
          SizedBox(height: 12),
          Text(jobTitle,
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
          SizedBox(height: 6),
          Text("$contractorName    Actor",
              style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
          SizedBox(height: 6),
          Row(
            children: [
              Image.asset(AppAssets.kLoc, height: 18),
              SizedBox(width: 6),
              Expanded(
                  child: Text(location,
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kgrey))),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Image.asset(AppAssets.kCal, height: 18),
              SizedBox(width: 6),
              Text("Today   $startTime - $endTime",
                  style:
                      AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _ShiftDetailsCard(
      Map<String, dynamic> workDuration,
      Map<String, dynamic> earnings,
      Map<String, dynamic> shiftData,
      bool isEarlyClosure) {
    // Use real data with fallbacks
    String startTime = shiftData['startTime']?.toString() ?? "9:00 AM";
    String endTime = shiftData['endTime']?.toString() ?? "5:00 PM";
    double hourlyRate = earnings['hourlyRate'] ?? 28.0;
    double hoursWorked = earnings['hoursWorked'] ?? 8.0;
    double totalEarnings = earnings['totalEarnings'] ?? 224.0;
    double tip = 0.0; // You can add tip calculation if available

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Shift Details",
                  style:
                      AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
              if (isEarlyClosure)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Early Closure",
                    style:
                        AppTypography.kLight16.copyWith(color: Colors.orange),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),
          _shiftRow("Start Time", "Today, $startTime"),
          _shiftRow("End Time", "Today, $endTime"),
          _shiftRow("Actual Duration",
              workDuration['formattedDuration'] ?? "00:00:00"),
          _shiftRow("Rate Per Hour", "\$${hourlyRate.toStringAsFixed(0)}/hr"),
          _shiftRow("Hours Worked", hoursWorked.toStringAsFixed(1)),
          _shiftRow("Tip", "\$${tip.toStringAsFixed(0)}"),
          _shiftRow("Total Earning", "\$${totalEarnings.toStringAsFixed(0)}"),
        ],
      ),
    );
  }

  Widget _shiftRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
          Text(value,
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
        ],
      ),
    );
  }

  Widget _BottomActionButtons(Map<String, dynamic> jobData,
      Map<String, dynamic> shiftData, Map<String, dynamic> origionalApiData) {
    // Extract data for the review screen
    String jobTitle = jobData['title']?.toString() ??
        "Security Escort for Actor – Airport to Residence";
    String contractorName =
        shiftData['job']?['contractor']?['name']?.toString() ?? "Hugh Jackman";
    double hourlyRate =
        double.tryParse(jobData['payPerHour']?.toString() ?? '0') ?? 28.0;

    // Extract IDs from the data (adjust these paths based on your actual API structure)
    String guardId = origionalApiData['guardId']?.toString() ?? '';
    String jobId = jobData['id']?.toString() ?? '';
    String contractorId =
        shiftData['job']?['contractor']?['id']?.toString() ?? '';

    // Get current date for the review
    String currentDate = DateTime.now().toIso8601String().split('T')[0];
    String jobDate = shiftData['date']?.toString() ?? currentDate;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(
                () => SubmitReviewScreen(
                  jobTitle: jobTitle,
                  guardName:
                      contractorName, // Using contractor name as guard name
                  jobDate: jobDate,
                  payPerHour: hourlyRate.toStringAsFixed(0),
                  guardId: guardId,
                  jobId: jobId,
                  contractorId: contractorId,
                  date: currentDate,
                ),
              );
            },
            child: Center(
              child: Text("Share Your Review!",
                  style: AppTypography.kBold16
                      .copyWith(color: AppColors.kSkyBlue)),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // Navigate to next job screen
                // MyJobsView1(),
                Get.to(() => MyJobsView1());
              },
              child: Text("Check My Next Job",
                  style:
                      AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.kSkyBlue,
                side: BorderSide(color: AppColors.kSkyBlue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Get.to(() => MyJobsView1()),
              icon: Icon(Icons.arrow_back, size: 20),
              label: Text("Back to Jobs",
                  style: AppTypography.kBold16
                      .copyWith(color: AppColors.kSkyBlue)),
            ),
          ),
        ],
      ),
    );
  }
}
