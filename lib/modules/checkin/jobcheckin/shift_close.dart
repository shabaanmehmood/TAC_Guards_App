import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/checkin/jobcheckin/job_status_screen.dart';
import 'package:tac/modules/checkin/jobcheckin/shift_close_controller.dart';
import 'job_live_controller.dart'; // Add this import

class ShiftCloseBottomSheet extends StatelessWidget {
  final Map<String, dynamic>? completionData;

  const ShiftCloseBottomSheet({super.key, this.completionData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShiftCloseController());
    final jobLiveController = Get.find<JobLiveController>(); // Get the JobLiveController
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.fifteenHorizontal,
          vertical: AppSpacing.twentyVertical,
        ),
        decoration: const BoxDecoration(
          color: AppColors.kDarkestBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: AppSpacing.fifteenVertical),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Closing Shift Early?",
                  style: AppTypography.kBold17,
                ),
              ),
              SizedBox(height: AppSpacing.twelveVertical),
              const Divider(color: Colors.white24, thickness: 1),
              SizedBox(height: AppSpacing.twelveVertical),

              // Early Closure Warning
              Container(
                padding: EdgeInsets.all(AppSpacing.fifteenHorizontal),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, 
                         color: Colors.orange, size: 20),
                    SizedBox(width: AppSpacing.twelveHorizontal),
                    Expanded(
                      child: Text(
                        "You are ending your shift before the scheduled time.",
                        style: AppTypography.kLight14.copyWith(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.fifteenVertical),

              // Early Closure Details
              if (completionData != null) _buildEarlyClosureDetails(completionData!),
              SizedBox(height: AppSpacing.fifteenVertical),

              // Reason Container
              Container(
                padding: EdgeInsets.all(AppSpacing.fifteenHorizontal),
                decoration: BoxDecoration(
                  color: AppColors.kJobCardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please select your reason for ending the job early",
                      style: AppTypography.kBold14
                          .copyWith(color: AppColors.kWhite),
                    ),
                    SizedBox(height: AppSpacing.twelveVertical),

                    // Custom Checkboxes
                    Obx(() => Column(
                          children: controller.reasons.map((reason) {
                            final isSelected =
                                controller.selectedReason.value == reason;
                            return GestureDetector(
                              onTap: () {
                                controller.selectedReason.value = reason;
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: AppSpacing.twelveVertical),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      margin: EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.kPrimary
                                              : Colors.white38,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? AppColors.kPrimary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.black,
                                            )
                                          : null,
                                    ),
                                    SizedBox(
                                        width: AppSpacing.twelveHorizontal),
                                    Expanded(
                                      child: Text(
                                        reason,
                                        style: AppTypography.kLight14
                                            .copyWith(color: AppColors.kWhite),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )),

                    SizedBox(height: AppSpacing.fifteenVertical),

                    // Share details input
                    TextField(
                      onChanged: (val) => controller.customReason.value = val,
                      maxLines: null,
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kWhite),
                      cursorColor: AppColors.kPrimary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.kDarkestBlue,
                        hintText: "Share details (Optional)",
                        hintStyle: AppTypography.kLight14
                            .copyWith(color: Colors.white38),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset(AppAssets.kEdit,
                              width: 20, height: 20, color: Colors.white38),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppSpacing.fifteenVertical,
                          horizontal: AppSpacing.twelveHorizontal,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.kPrimary),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.kPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.twentyVertical),
              const Divider(color: Colors.white24, thickness: 1),
              SizedBox(height: AppSpacing.fifteenVertical),

              // Action Buttons
              Row(
                children: [
                  // Cancel button
                  SizedBox(
                    width: screenWidth * 0.28,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {
                        jobLiveController.isNavigating.value = false; // Reset navigation state
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.kPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: AppTypography.kBold14
                            .copyWith(color: AppColors.kPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.twelveHorizontal),

                  // End Job button
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.selectedReason.value.isEmpty || jobLiveController.isNavigating.value
                            ? null
                            : () {
                                _handleEndJob(controller, jobLiveController, completionData);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.selectedReason.value.isEmpty
                              ? Colors.grey
                              : AppColors.kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: jobLiveController.isNavigating.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                "End Job",
                                style: AppTypography.kBold14.copyWith(
                                  color: controller.selectedReason.value.isEmpty
                                      ? Colors.white38
                                      : AppColors.kBlack,
                                ),
                              ),
                      )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarlyClosureDetails(Map<String, dynamic> completionData) {
    final calculatedData = completionData['calculatedData'] ?? {};
    final earlyClosureDetails = calculatedData['earlyClosureDetails'] ?? {};
    
    final minutesEarly = earlyClosureDetails['minutesEarly'] ?? 0;
    final formattedRemainingTime = earlyClosureDetails['formattedRemainingTime'] ?? "00:00";
    final potentialEarningsLoss = earlyClosureDetails['potentialEarningsLoss'] ?? 0.0;

    return Container(
      padding: EdgeInsets.all(AppSpacing.fifteenHorizontal),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Early Closure Details",
            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
          ),
          SizedBox(height: AppSpacing.twelveVertical),
          _detailRow("Time Remaining", formattedRemainingTime),
          _detailRow("Minutes Early", "$minutesEarly minutes"),
          if (potentialEarningsLoss > 0)
            _detailRow("Potential Earnings Loss", 
                "\$${potentialEarningsLoss.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
          ),
          Text(
            value,
            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
          ),
        ],
      ),
    );
  }

  void _handleEndJob(ShiftCloseController controller, JobLiveController jobLiveController, Map<String, dynamic>? completionData) {
    try {
      // Use the JobLiveController to handle the early closure with reason
      jobLiveController.handleEarlyClosureWithReason(
        completionData ?? {},
        controller.selectedReason.value,
        controller.customReason.value,
      );
      
      // Optional: Show confirmation message
      Get.snackbar(
        "Shift Ended",
        "Your shift has been ended early",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      // If there's an error, the JobLiveController will handle it
      print("Error in bottom sheet: $e");
    }
  }
}