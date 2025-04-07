import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String perHourRate;
  final String companyName;
  final String rating;
  final String hiringTag;
  final String jobType;
  final String location;
  final String distance;
  final String day;
  final String shiftTime;
  final String requiredPersons;
  final String jobDept;
  final Color? jobStatus;

  const JobCard({
    Key? key,
    required this.jobTitle,
    required this.perHourRate,
    required this.companyName,
    required this.rating,
    required this.hiringTag,
    required this.jobType,
    required this.location,
    required this.distance,
    required this.day,
    required this.shiftTime,
    required this.requiredPersons,
    required this.jobDept,
    this.jobStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, bottom: 10, top: 20, left: 20),
      decoration: BoxDecoration(
        color: jobStatus?.withOpacity(0.5) ?? AppColors.kJobCardColor, // Dark background color
        border: Border.all(
          color: jobStatus ?? AppColors.kJobCardColor
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **Job Title & Per Hour Rate**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                jobTitle,
                style: AppTypography.kBold16.copyWith(
                  color: AppColors.kWhite,
                )
              ),
              Text(
                perHourRate,
                style: AppTypography.kBold16.copyWith(
                  color: AppColors.kSkyBlue
                )
              ),
            ],
          ),
          SizedBox(height: AppSpacing.fiveVertical),
          /// **Company Name & Rating**
          Row(
            children: [
              Text(
                companyName,
                style: AppTypography.kLight14.copyWith(
                  color: AppColors.kWhite
                )
              ),
              const SizedBox(width: 5),
              Text(
                rating,
                style: AppTypography.kBold14.copyWith(
                  color: AppColors.kSkyBlue
                )
              ),
            ],
          ),
          SizedBox(height: AppSpacing.fiveVertical),
          /// **Hiring Tags**
          Row(
            children: [
              _buildTag(hiringTag),
              const SizedBox(width: 8),
              _buildTag(jobType),
            ],
          ),
          SizedBox(height: AppSpacing.tenVertical),
          /// **Location & Distance**
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
                    location,
                    style: AppTypography.kLight14.copyWith(
                      color: AppColors.kWhite
                    ),
                  ),
                ],
              ),
              Text(
                distance,
                style: AppTypography.kLight14.copyWith(
                  color: AppColors.kWhite
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.tenVertical),

          /// **Date & Shift Timing**
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    day,
                    style: AppTypography.kLight14.copyWith(
                      color: AppColors.kWhite
                    ),
                  ),
                  const SizedBox(width: 20,),
                  const Icon(Icons.access_time, color: Colors.grey, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    shiftTime,
                    style: AppTypography.kLight14.copyWith(
                        color: AppColors.kWhite
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: AppSpacing.tenVertical),

          /// **Required Persons**
          Text(
            requiredPersons,
            style: AppTypography.kBold14.copyWith(
                color: AppColors.kSkyBlue
            ),
          ),
        ],
      ),
    );
  }

  /// **Helper Method to Build Tag Widgets**
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


// class JobCardController extends GetxController {
//   var jobTitle = "VIP Protection for Music Festival".obs;
//   var perHourRate = "\$25/hr".obs;
//   var companyName = "StarShield Security".obs;
//   var rating = "4.8".obs;
//   var hiringTag = "Urgent Hiring".obs;
//   var jobType = "Part-time".obs;
//   var location = "Miami, FL".obs;
//   var distance = "7.2 Km away".obs;
//   var day = "Monday".obs;
//   var shiftTime = "30 min remaining".obs;
//   var requiredPersons = "2 Security Guards Needed".obs;
//   var jobDept = "Security".obs;
//   var showDetails = false.obs;
//
//   // Constructor with optional parameters (default values if not provided)
//   JobCardController({
//     String jobTitle = "VIP Protection for Music Festival",
//     String perHourRate = "\$25/hr",
//     String companyName = "StarShield Security",
//     String rating = "4.8",
//     String hiringTag = "Urgent Hiring",
//     String jobType = "Part-time",
//     String location = "Miami, FL",
//     String distance = "7.2 Km away",
//     String day = "Monday",
//     String shiftTime = "30 min remaining",
//     String requiredPersons = "2 Security Guards Needed",
//     String jobDept = "Security",
//     bool showDetails = true,
//   }) {
//     this.jobTitle.value = jobTitle;
//     this.perHourRate.value = perHourRate;
//     this.companyName.value = companyName;
//     this.rating.value = rating;
//     this.hiringTag.value = hiringTag;
//     this.jobType.value = jobType;
//     this.location.value = location;
//     this.distance.value = distance;
//     this.day.value = day;
//     this.shiftTime.value = shiftTime;
//     this.requiredPersons.value = requiredPersons;
//     this.jobDept.value = jobDept;
//     this.showDetails.value = showDetails;
//   }
// }
//
// class JobCard extends StatelessWidget {
//   final JobCardController controller = Get.put(JobCardController());
//
//   JobCard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColors.kJobCardColor,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// **Job Title & Per Hour Rate**
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 controller.jobTitle.value,
//                 style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
//               ),
//               Text(
//                 controller.perHourRate.value,
//                 style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
//               ),
//             ],
//           ),
//           SizedBox(height: AppSpacing.fiveVertical),
//
//           /// **Company Name & Rating**
//           Row(
//             children: [
//               Text(
//                 controller.companyName.value,
//                 style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
//               ),
//               const SizedBox(width: 5),
//               Text(
//                 controller.rating.value,
//                 style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
//               ),
//             ],
//           ),
//           SizedBox(height: AppSpacing.fiveVertical),
//
//           /// **Conditionally Show Details or Check-In Button**
//           if (controller.showDetails.value == true) ...[
//             /// **Hiring Tags**
//             Row(
//               children: [
//                 _buildTag(controller.hiringTag.value),
//                 const SizedBox(width: 8),
//                 _buildTag(controller.jobType.value),
//               ],
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//
//             /// **Location & Distance**
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
//                       style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   controller.distance.value,
//                   style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//
//             /// **Date & Shift Timing**
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
//                 const SizedBox(width: 5),
//                 Text(
//                   controller.day.value,
//                   style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
//                 ),
//                 const SizedBox(width: 20),
//                 const Icon(Icons.access_time, color: Colors.grey, size: 16),
//                 const SizedBox(width: 5),
//                 Text(
//                   controller.shiftTime.value,
//                   style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//
//             /// **Required Persons**
//             Text(
//               controller.requiredPersons.value,
//               style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
//             ),
//           ] else ...[
//             /// **Check In / Check Out Button**
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle Check In / Check Out
//                   controller.showDetails.value = !controller.showDetails.value;
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.kSkyBlue,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: Text(
//                   "Check In / Check Out",
//                   style: AppTypography.kBold14.copyWith(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     ));
//   }
//
//   /// **Helper Method to Build Tag Widgets**
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
