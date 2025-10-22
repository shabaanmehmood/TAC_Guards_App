import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';

class JobStatusScreenError extends StatelessWidget {
  const JobStatusScreenError({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the data passed from JobLiveScreen (if any error data is sent)
    final errorData = Get.arguments ?? {};
    final errorMessage = errorData['errorMessage'] ?? 'An unexpected error occurred';
    final originalApiData = errorData['originalApiData'] ?? {};
    final calculatedData = errorData['calculatedData'] ?? {};
    
    // Extract data from original API response
    final responseBody = originalApiData['responseBody'] ?? {};
    final data = responseBody['data'] ?? {};
    final jobData = data['job'] ?? {};
    final shiftData = data['shift'] ?? {};

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
                              "Shift Closure Error",
                              style: AppTypography.kBold20
                                  .copyWith(color: AppColors.kWhite),
                            )
                          ],
                        ),
                        SizedBox(height: AppSpacing.thirtyVertical),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.error_outline, size: 36, color: Colors.red),
                        ),
                        SizedBox(height: AppSpacing.twentyVertical),
                        Text(
                          "Unable to Complete Shift",
                          textAlign: TextAlign.center,
                          style: AppTypography.kBold18
                              .copyWith(color: AppColors.kWhite),
                        ),
                        SizedBox(height: AppSpacing.tenVertical),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: AppTypography.kLight14
                              .copyWith(color: Colors.red),
                        ),
                        SizedBox(height: AppSpacing.thirtyVertical),
                        _JobDetailsCard(jobData, shiftData),
                        SizedBox(height: AppSpacing.twentyVertical),
                        _ShiftDetailsCard(calculatedData, shiftData),
                        SizedBox(height: AppSpacing.twentyVertical),
                      ],
                    ),
                  ),
                ),
                _BottomActionButtons(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _JobDetailsCard(Map<String, dynamic> jobData, Map<String, dynamic> shiftData) {
    // Use real data with fallbacks
    String jobTitle = jobData['title']?.toString() ?? "Security Escort for Actor – Airport to Residence";
    String contractorName = shiftData['job']?['contractor']?['name']?.toString() ?? "Hugh Jackman";
    String location = jobData['location']?.toString() ?? "2972 Westheimer Rd. Santa Ana, Illinois 85486";
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

  Widget _ShiftDetailsCard(Map<String, dynamic> calculatedData, Map<String, dynamic> shiftData) {
    // Use real data with fallbacks
    final earnings = calculatedData['earnings'] ?? {};
    final workDuration = calculatedData['workDuration'] ?? {};
    final errorInfo = calculatedData['errorInfo'] ?? {};
    
    String startTime = shiftData['startTime']?.toString() ?? "9:00 AM";
    String endTime = shiftData['endTime']?.toString() ?? "5:00 PM";
    double hourlyRate = earnings['hourlyRate'] ?? 28.0;
    double hoursWorked = earnings['hoursWorked'] ?? 0.0;
    double totalEarnings = earnings['totalEarnings'] ?? 0.0;
    String formattedDuration = workDuration['formattedDuration']?.toString() ?? "00:00:00";
    String shiftStatus = errorInfo['shiftStatus']?.toString() ?? "UNKNOWN";

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Shift Details",
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
          SizedBox(height: 12),
          _shiftRow("Start Time", "Today, $startTime"),
          _shiftRow("End Time", "Today, $endTime"),
          _shiftRow("Time Worked", formattedDuration),
          _shiftRow("Rate Per Hour", "\$${hourlyRate.toStringAsFixed(0)}/hr"),
          _shiftRow("Hours Worked", hoursWorked > 0 ? hoursWorked.toStringAsFixed(1) : "0"),
          _shiftRow("Status", "Error - $shiftStatus", isError: true),
          _shiftRow("Total Earning", hoursWorked > 0 ? "\$${totalEarnings.toStringAsFixed(0)}" : "\$0"),
        ],
      ),
    );
  }

  Widget _shiftRow(String title, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
          Text(value,
              style: AppTypography.kBold14.copyWith(
                color: isError ? Colors.red : AppColors.kWhite,
              )),
        ],
      ),
    );
  }

  Widget _BottomActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text("Need Help? Contact Support",
                style:
                    AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue)),
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
                // Try to close shift again or navigate to find new jobs
                Get.offAllNamed('/findJobs');
              },
              child: Text("Find New Jobs",
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
              onPressed: () {
                // Go back to job live screen to retry
                Get.back();
              },
              icon: Icon(Icons.refresh, size: 20),
              label: Text("Try Again",
                  style: AppTypography.kBold16
                      .copyWith(color: AppColors.kSkyBlue)),
            ),
          ),
        ],
      ),
    );
  }
}