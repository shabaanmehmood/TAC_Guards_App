import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../data/data/constants/app_assets.dart';
import '../../../data/data/constants/app_colors.dart';
import '../../../data/data/constants/app_spacing.dart';
import '../../../data/data/constants/app_typography.dart';

class JobCardController extends GetxController {
  var jobTitle = ''.obs;
  var perHourRate = ''.obs;
  var companyName = ''.obs;
  var rating = ''.obs;
  var hiringTag = ''.obs;
  var jobType = ''.obs;
  var location = ''.obs;
  var distance = ''.obs;
  var day = ''.obs;
  var shiftTime = ''.obs;
  var requiredPersons = ''.obs;
  var jobDept = ''.obs;
  var jobStatus = Rx<Color?>(null);
  var showDetails = true.obs;
  var statusLabel = ''.obs; // Add this

  // Constructor to initialize values
  JobCardController({
    required String jobTitle,
    required String perHourRate,
    required String companyName,
    required String rating,
    required String hiringTag,
    required String jobType,
    required String location,
    required String distance,
    required String day,
    required String shiftTime,
    required String requiredPersons,
    required String jobDept,
    Color? jobStatus,
    bool showDetails = true, // default to true
    required String statusLabel,
  }) {
    this.jobTitle.value = jobTitle;
    this.perHourRate.value = perHourRate;
    this.companyName.value = companyName;
    this.rating.value = rating;
    this.hiringTag.value = hiringTag;
    this.jobType.value = jobType;
    this.location.value = location;
    this.distance.value = distance;
    this.day.value = day;
    this.shiftTime.value = shiftTime;
    this.requiredPersons.value = requiredPersons;
    this.jobDept.value = jobDept;
    this.jobStatus.value = jobStatus;
    this.showDetails.value = showDetails;
    this.statusLabel.value = statusLabel;
  }
}

// class MyJobCard extends StatelessWidget {
//   final JobCardController controller;
//   final VoidCallback? onReviewSubmit;
//
//   MyJobCard({Key? key, required this.controller, this.onReviewSubmit}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Container(
//         padding: const EdgeInsets.only(right: 20, bottom: 10, top: 20, left: 20),
//         decoration: BoxDecoration(
//           color: controller.jobStatus.value?.withOpacity(0.3) ?? AppColors.kJobCardColor,
//           border: Border.all(color: controller.jobStatus.value ?? AppColors.kJobCardColor),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // **Job Title & Per Hour Rate**
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   controller.jobTitle.value,
//                   style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
//                 ),
//                 Text(
//                   controller.perHourRate.value,
//                   style: AppTypography.kBold16.copyWith(
//                     color: controller.jobStatus.value!
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//
//             // **Company Name & Rating**
//             Row(
//               children: [
//                 Text(
//                   controller.companyName.value,
//                   style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//
//             Obx(() {
//               if(controller.showDetails.value == true)
//                 {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // **Hiring Tags**
//                       Row(
//                         children: [
//                           _buildTag(controller.hiringTag.value),
//                           const SizedBox(width: 8),
//                           _buildTag(controller.jobType.value),
//                         ],
//                       ),
//                       SizedBox(height: AppSpacing.tenVertical,),
//                     ],
//                   );
//                 }
//               else {
//                 return const SizedBox();
//               }
//             }),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     SvgPicture.asset(
//                       AppAssets.kLocation,
//                       height: 16,
//                       width: 16,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       controller.location.value,
//                       style: AppTypography.kLight14.copyWith(
//                           color: AppColors.kWhite
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   controller.distance.value,
//                   style: AppTypography.kLight14.copyWith(
//                       color: AppColors.kWhite
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//
//             // **Date & Shift Timing**
//             Row(
//               children: [
//                 Icon(Icons.access_time, color: controller.jobStatus.value, size: 16),
//                 const SizedBox(width: 5),
//                 Text(
//                   controller.shiftTime.value,
//                   style: AppTypography.kLight14.copyWith(
//                       color: controller.jobStatus.value!
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: AppSpacing.tenVertical),
//
//             // **Hiring Tags**
//             // Hiring Tags, Shift Time, and Required Persons OR Check In/Out button
//             Obx(() {
//               if (controller.showDetails.value) {
//                 return Text(
//                   controller.requiredPersons.value,
//                   style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
//                 );
//               } else {
//                 // Show Check In / Check Out button
//                 return Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: controller.jobStatus.value!,
//                     ),
//                     borderRadius: BorderRadius.circular(10)
//                   ),
//                   child: TextButton(
//                     onPressed: (){},
//                     child: Text(
//                       'Check Out',
//                       style: AppTypography.kBold16.copyWith(
//                         color: controller.jobStatus.value
//                       ),
//                     ),
//                   ),
//                 );
//               }
//             }),
//           ],
//         ),
//       );
//     });
//   }
//
//   // **Helper Method to Build Tag Widgets**
//   Widget _buildTag(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(color: Colors.white, fontSize: 12),
//       ),
//     );
//   }
// }

class MyJobCard extends StatelessWidget{

  final JobCardController controller;
  final VoidCallback? onReviewSubmit;

  MyJobCard({Key? key, required this.controller, this.onReviewSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isCompleted = controller.statusLabel.value == 'Completed';

      return Container(
        padding: const EdgeInsets.only(right: 20, bottom: 10, top: 20, left: 20),
        decoration: BoxDecoration(
          color: controller.jobStatus.value?.withOpacity(0.3) ?? AppColors.kJobCardColor,
          border: Border.all(color: controller.jobStatus.value ?? AppColors.kJobCardColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Job Title & Per Hour Rate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.jobTitle.value,
                  style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                ),
                Text(
                  controller.perHourRate.value,
                  style: AppTypography.kBold16.copyWith(
                      color: controller.jobStatus.value!
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.tenVertical),

            // Company Name
            Row(
              children: [
                Text(
                  controller.companyName.value,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.tenVertical),

            // HIRING TAGS — hide if completed
            if (!isCompleted && controller.showDetails.value)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildTag(controller.hiringTag.value),
                      const SizedBox(width: 8),
                      _buildTag(controller.jobType.value),
                    ],
                  ),
                  SizedBox(height: AppSpacing.tenVertical),
                ],
              ),

            // Location & Distance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.kLocation,
                      height: 16,
                      width: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      controller.location.value,
                      style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                    ),
                  ],
                ),
                Text(
                  controller.distance.value,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.tenVertical),

            // SHIFT TIME — hide if completed
            if (!isCompleted)
              Row(
                children: [
                  Icon(Icons.access_time, color: controller.jobStatus.value, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    controller.shiftTime.value,
                    style: AppTypography.kLight14.copyWith(
                      color: controller.jobStatus.value!,
                    ),
                  ),
                ],
              ),

            SizedBox(height: AppSpacing.tenVertical),

            // REQUIRED PERSONS or BUTTON
            Obx(() {
              if (controller.showDetails.value && !isCompleted) {
                return Text(
                  controller.requiredPersons.value,
                  style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
                );
              } else {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: controller.jobStatus.value!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: isCompleted ? onReviewSubmit : () {},
                    child: Text(
                      isCompleted ? 'Share Your Review' : 'Check Out',
                      style: AppTypography.kBold16.copyWith(
                        color: controller.jobStatus.value,
                      ),
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      );
    });
  }

  // **Helper Method to Build Tag Widgets**
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

