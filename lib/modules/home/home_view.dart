import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tac/controllers/mapController.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/dataproviders/api_service.dart';
import 'package:tac/models/nearbyjob.dart';
import 'package:tac/modules/Guards/guards_view.dart';
import 'package:tac/modules/alerts/notification_view.dart';
import 'package:tac/modules/home/components/search_field.dart';

import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_colors.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final MapController controller = Get.put(MapController(), permanent: true);
  final UserController userController = Get.find<UserController>();
  final GuardsViewController guardsController = Get.put(GuardsViewController());

  // Helper method to format date
  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  // Helper method to format shift timing
  Widget _buildShiftTiming(JobNearby job) {
    if (job.shifts == null || job.shifts!.isEmpty) {
      return Text(
        "Flexible timing",
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
      );
    }

    // Take the first shift for display
    final shift = job.shifts!.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and Time
        Text(
          "${_formatDate(shift.date)} • ${_formatTime(shift.startTime)} - ${_formatTime(shift.endTime)}",
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),

        // Days
        if (shift.days != null && shift.days!.isNotEmpty)
          Text(
            shift.days!.join(', '),
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),

        // Show multiple shifts indicator
        if (job.shifts!.length > 1)
          Text(
            "+ ${job.shifts!.length - 1} more shift${job.shifts!.length - 1 > 1 ? 's' : ''}",
            style: TextStyle(
              color: const Color(0xFF00D3FF),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  String _formatTime(String timeString) {
    try {
      final timeParts = timeString.split(':');
      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = timeParts[1];

        // Convert to 12-hour format
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour % 12 == 0 ? 12 : hour % 12;

        return '$displayHour:${minute.padLeft(2, '0')} $period';
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(context),
            SizedBox(height: AppSpacing.tenVertical),
            Expanded(
              child: Stack(
                children: [
                  Obx(() {
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.userPath.isNotEmpty
                            ? controller.userPath.first
                            : const LatLng(33.6844, 73.0479),
                        zoom: 18,
                      ),
                      markers: controller.markers,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      onMapCreated: (GoogleMapController mapController) {
                        if (controller.userPath.isNotEmpty) {
                          print(controller.userPath.first);
                        }
                        controller.setMapController(mapController);
                        controller.requestAndSaveLocation();
                      },
                      onCameraMove: (position) {
                        controller.updateCameraPosition(position);
                      },
                      onTap: (LatLng position) {
                        // Close overlay when tapping anywhere on the map
                        controller.clearSelectedJob();
                      },
                    );
                  }),

                  // ✅ Overlay for selected job
                  Obx(() {
                    final job = controller.selectedJob.value;
                    if (job == null) return const SizedBox.shrink();

                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          // Prevent the tap from propagating to the map
                        },
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF0B132B),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with close button
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      job.jobTitle,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                      job.payPerHour != null
                                          ? "\$${job.payPerHour}/hr"
                                          : "Negotiable",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF00D3FF))),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // Contractor Name
                              Row(
                                children: [
                                  Icon(Icons.person,
                                      size: 14, color: Colors.grey[400]),
                                  const SizedBox(width: 4),
                                  Text(
                                    job.contractorName ?? "Contractor",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              // Job Location
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 14, color: Colors.grey[400]),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      job.jobLocation ??
                                          "Location not specified",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              // Shift Timing
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.access_time,
                                      size: 14, color: Colors.grey[400]),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: _buildShiftTiming(job),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              // Distance
                              Row(
                                children: [
                                  Icon(Icons.directions_walk,
                                      size: 14, color: Colors.grey[400]),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${((job.distance ?? 0) * 1000).toStringAsFixed(1)} meters away",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final GuardsViewController guardsController =
        Get.find<GuardsViewController>(); // Find the controller here
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
      child: SizedBox(
        width: double.infinity, // Ensures full width
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevents infinite height issue
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppAssets.kTacLogo,
                      height: Get.height * 0.045,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Home',
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kWhite),
                    ),
                  ],
                ),
                // Builder(
                //   builder: (BuildContext context) {
                //     return Image.asset(
                //       AppAssets.kTacHomeScreenLogo,
                //       height: Get.height * 0.07,
                //       width: Get.width * 0.25,
                //       fit: BoxFit.contain,
                //     );
                //   },
                // ),
                const Spacer(),
                Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min, // Prevent infinite height
                      children: [
                        IconButton(
                          focusColor: AppColors.kPrimary,
                          color: AppColors.kPrimary,
                          icon: SvgPicture.asset(
                            width: 35,
                            height: 35,
                            AppAssets.kAlerts,
                          ),
                          onPressed: () {
                            Get.to<void>(() => NotificationScreen());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Builder(
                  builder: (_) {
                    final profileImages =
                        userController.userData.value?.profileImages;
                    final mainImage = profileImages
                        ?.firstWhereOrNull((img) => img.isMain == true);
                    final imageUrl = (mainImage?.imageUrl != null &&
                            mainImage!.imageUrl!.isNotEmpty)
                        ? '${MyApIService.imageBaseUrl}${mainImage.imageUrl}'
                        : null;

                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: imageUrl != null
                              ? NetworkImage(imageUrl)
                              : AssetImage(AppAssets.kUserPicture)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                // Obx(() {
                //   final imagePath = userController
                //       .userData.value?.profileImages?.first.imageUrl;
                //   final imageUrl = MyApIService.fullImageUrl(imagePath);
                //   return Container(
                //     width: 34,
                //     height: 34,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(4),
                //       image: DecorationImage(
                //         image: imageUrl != null
                //             ? NetworkImage(imageUrl)
                //             : AssetImage(AppAssets.kUserPicture)
                //                 as ImageProvider,
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   );
                // }),
              ],
            ),
            SizedBox(height: AppSpacing.tenVertical),
            SearchField(
              isBorderBlue: true,
              isEnabled: false,
              text: 'Search for Security Guards',
              isIconColorBlue: false,
              icon2: AppAssets.kSearch,
              guardsController: guardsController, // Pass the found controller
            ),
          ],
        ),
      ),
    );
  }
}
