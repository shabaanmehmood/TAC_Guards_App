import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/models/jobApplications/jobApplications_model.dart';
import 'package:tac/modules/checkin/checkin_overlay.dart';
import 'package:tac/modules/checkin/jobcheckin/SubmitReviewScreen.dart';
import 'package:tac/modules/fiilters/sort_overlay.dart';
import '../newjob section/job_controller.dart';
// import '../newjob section/job_model.dart';
import 'package:tac/models/jobApplications/job_model.dart';
import 'package:tac/modules/home/components/search_field.dart';

import '../newjob section/job_model.dart';

class MyJobsView1 extends StatelessWidget {
  final JobController jobController = Get.put(JobController());
  // final JobApplicationController jobController = Get.put(JobApplicationController());

  MyJobsView1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(),
              SizedBox(height: AppSpacing.fifteenVertical),
              _buildTabFilters(),
              SizedBox(height: AppSpacing.tenVertical),
              Expanded(child: Obx(() => _buildJobList()))
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              AppAssets.kTacHomeScreenLogo,
              height: Get.height * 0.07,
              width: Get.width * 0.25,
              fit: BoxFit.contain,
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(AppAssets.kPlusSign),
              ),
            )
          ],
        ),
        SizedBox(height: AppSpacing.tenVertical),
        SearchField(
          isBorderBlue: true,
          isIconColorBlue: true,
          icon2: AppAssets.kSearch,
          text: 'Search for security jobs...',
        )
      ],
    );
  }

  Widget _buildTabFilters() {
    List<String> filters = ["Active", "Pending", "Completed", "Cancelled"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() => Row(
            children: filters.map((filter) {
              bool selected = jobController.selectedFilter.value == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.kSkyBlue),
                  ),
                  backgroundColor: AppColors.kDarkBlue,
                  selectedColor: AppColors.kSkyBlue,
                  showCheckmark: false,
                  selected: selected,
                  label: Text(
                    filter,
                    style: AppTypography.kBold14.copyWith(color: Colors.white),
                  ),
                  onSelected: (_) => jobController.setFilter(filter),
                ),
              );
            }).toList(),
          )),
    );
  }

  Widget _buildJobList() {
    var jobs = jobController.filteredJobs;

    if (jobController.isLoading.value) {
      return Center(child: CircularProgressIndicator());
    }
    if (jobs.isEmpty) {
      return Center(child: Text('No jobs found', style: TextStyle(color: Colors.white)));
    }
    // var jobs = jobController.filteredJobs;
    return ListView.separated(
      itemCount: jobs.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.fifteenVertical),
      itemBuilder: (context, index) {
        final jobApp = jobs[index];
        final job = jobApp.job;

        final jobModel = JobModel(
          title: job.title,
          guardName: job.contractor.name,
          location: job.location,
          distance: job.latitude,
          time: job.shifts.isNotEmpty
              ? '${job.shifts[0].startTime} - ${job.shifts[0].endTime}'
              : '',
          price: '${job.payPerHour}/hr',
          status: _mapStatus(jobApp.currentStatus.status),
          statusLabel: jobApp.currentStatus.status.capitalizeFirst ?? '',
          showButton: true,
          buttonText: 'Check In',
          rating: '',
        );
        return JobCardWidget(
          job: jobModel,
          shiftId: jobApp.assignedShift.id, // key update
          latitude: job.latitude,
          longitude: job.longitude,
        );
      },
    );
  }

  String _mapStatus(String apiStatus) {
    switch (apiStatus.toLowerCase()) {
      case 'approved':
        return 'In Progress';
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return apiStatus.capitalizeFirst ?? '';
    }
  }
}

class JobCardWidget extends StatelessWidget {
  final JobModel job;
  final String shiftId;
  final String latitude;
  final String longitude;

  const JobCardWidget({super.key, required this.job, required this.shiftId, required this.latitude, required this.longitude});


  Color _getCardColor() {
    switch (job.status) {
      case 'In Progress':
        return AppColors.kGreenS;
      case 'Awaiting':
        return AppColors.kYellowS;
      case 'Cancelled':
        return Colors.red.withOpacity(0.1);
      case 'Pending':
      case 'Completed':
      default:
        return AppColors.kDarkBlue;
    }
  }

  Color _getStatusTextColor() {
    switch (job.status) {
      case 'In Progress':
        return AppColors.kgreen;
      case 'Awaiting':
        return AppColors.kalert;
      case 'Cancelled':
        return AppColors.kRed;
      default:
        return AppColors.kSkyBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.fifteenVertical),
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(job.status), // ✅ updated border logic
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: title and status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  job.title,
                  style: AppTypography.kBold14.copyWith(color: Colors.white),
                ),
              ),
              if (job.statusLabel.isNotEmpty)
                Text(
                  job.statusLabel,
                  style: AppTypography.kBold14.copyWith(
                    color: _getStatusTextColor(),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),

          // Guard name with rating
          Row(
            children: [
              Text(
                job.guardName,
                style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
              ),
              // Text(
              //   job.rating,
              //   style:
              //       AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
              // ),
            ],
          ),
          SizedBox(height: 4),

          // Location and distance
          Row(
            children: [
              Icon(Icons.location_pin, color: AppColors.kgrey, size: 16),
              SizedBox(width: 4),
              Expanded(
                child: Text(job.location,
                    style: AppTypography.kLight14
                        .copyWith(color: AppColors.kgrey)),
              ),
              Text(job.distance,
                  style:
                      AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
            ],
          ),
          SizedBox(height: 4),

          // Time range
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.kinput, size: 16),
              SizedBox(width: 4),
              Expanded(
                child: Text(job.time,
                    style: AppTypography.kLight14
                        .copyWith(color: AppColors.kinput)),
              ),
            ],
          ),

          // Remaining time for Awaiting and In Progress
          if (job.remainingTime != null &&
              (job.status == 'In Progress' || job.status == 'Awaiting')) ...[
            SizedBox(height: 6),
            Text(
              '${job.remainingTime}',
              style: AppTypography.kLight14.copyWith(
                color: _getStatusTextColor(),
              ),
            ),
          ],

          // Nested cards for Pending
          if (job.status == 'Pending' && job.nestedCards != null)
            ...job.nestedCards!.map((item) => _nestedCard(item)).toList(),

          // Price for Completed
          if (job.price.isNotEmpty && job.status == 'Completed') ...[
            SizedBox(height: 8),
            Text(
              job.price,
              style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
            ),
          ],

          // Button for statuses
          if (job.showButton && job.buttonText != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: _getCardColor(), // Matches card background
                  side: BorderSide(
                    color:
                        _getStatusTextColor(), // Border color same as status text
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Rectangular
                  ),
                  minimumSize: Size(double.infinity, 40),
                ),
                onPressed: () {
                  if (job.buttonText == 'Check In') {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CheckInPage(job: job, shiftId: shiftId, latitude: latitude, longitude: longitude),
                    );

                  } else if (job.buttonText == 'Check-Out') {
                    //Get.to(() => CheckOutScreen()); // Add this screen if not yet created
                  } else if (job.buttonText == 'Share your review') {
                    Get.to(() =>
                        SubmitReviewScreen()); // Add this screen if not yet created
                  }
                },
                child: Text(
                  job.buttonText!,
                  style: AppTypography.kBold14.copyWith(
                    color: _getStatusTextColor(), // Text color matches status
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getBorderColor(String status) {
    switch (status) {
      case 'Pending':
      case 'Completed':
        return const Color(0xFF2F3D52); // rgba(47, 61, 82, 1)
      case 'Cancelled':
        return AppColors.kRed;
      case 'In Progress':
      case 'Awaiting':
      default:
        return _getStatusTextColor(); // match button/status color
    }
  }

  Widget _nestedCard(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.kDarkBlue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kgrey.withOpacity(0.4)),
      ),
      child: Text(
        title,
        style: AppTypography.kLight14.copyWith(color: Colors.white),
      ),
    );
  }
}
