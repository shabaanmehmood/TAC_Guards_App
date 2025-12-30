import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/models/jobApplications/jobApplications_model.dart';

import 'package:tac/modules/Guards/guards_view.dart';
import 'package:tac/modules/checkin/checkin_overlay.dart';
import 'package:tac/modules/checkin/jobcheckin/SubmitReviewScreen.dart';
import 'package:tac/modules/newjob%20section/job_model.dart';
import '../newjob section/job_controller.dart';
import 'package:tac/models/jobApplications/job_model.dart';
import 'package:tac/modules/home/components/search_field.dart';

class MyJobsView1 extends StatefulWidget {
  const MyJobsView1({super.key});

  @override
  State<MyJobsView1> createState() => _MyJobsView1State();
}

class _MyJobsView1State extends State<MyJobsView1> {
  final JobController jobController = Get.put(JobController());
  final TextEditingController searchController = TextEditingController();
  final GuardsViewController guardsController = Get.put(GuardsViewController());
  DateTime _lastAutoRefresh = DateTime.now();
  bool _isAutoRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Listen for changes in allApplications
    ever(jobController.allApplications, (List<JobApplication> apps) {
      if (mounted) {
        setState(() {
          _lastAutoRefresh = DateTime.now();
          _isAutoRefreshing = false;
        });

        // Show notification when jobs status changes
        _showStatusChangeNotification(apps);
      }
    });

    // Also listen for last refresh time updates
    ever(jobController.lastAutoRefreshTime, (_) {
      if (mounted) {
        setState(() {
          _lastAutoRefresh = jobController.lastAutoRefreshTime.value;
        });
      }
    });
  }

  void _showStatusChangeNotification(List<JobApplication> apps) {
    // You can add logic here to show notifications when jobs change status
    debugPrint('Jobs list updated with ${apps.length} jobs');

    // Show a subtle snackbar when there are jobs
    if (apps.isNotEmpty) {
      final currentFilter = jobController.selectedFilter.value;
      final filteredCount = jobController.filteredJobs.length;

      // if (filteredCount == 0) {
      //   // No jobs in current filter - suggest switching
      //   Future.delayed(Duration(milliseconds: 500), () {
      //     Get.snackbar(
      //       "No jobs in current filter",
      //       "Try switching to another tab",
      //       backgroundColor: AppColors.kSkyBlue,
      //       colorText: Colors.white,
      //       duration: Duration(seconds: 2),
      //     );
      //   });
      // }
    }
  }

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
              // SizedBox(height: AppSpacing.tenVertical),
              // _buildLastRefreshIndicator(),
              SizedBox(height: AppSpacing.tenVertical),
              Expanded(child: _buildJobList())
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
            Row(
              children: [
                Image.asset(
                  AppAssets.kTacLogo,
                  height: Get.height * 0.045,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 4),
                Text(
                  'My Jobs',
                  style:
                      AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                ),
              ],
            ),
            Spacer(),
            // Manual refresh button
            IconButton(
              onPressed: () {
                setState(() {
                  _isAutoRefreshing = true;
                });
                jobController.refreshJobs().then((_) {
                  setState(() {
                    _isAutoRefreshing = false;
                    _lastAutoRefresh = DateTime.now();
                  });
                });
              },
              icon: Obx(() {
                return Stack(
                  children: [
                    Icon(
                      Icons.refresh,
                      color: AppColors.kSkyBlue,
                      size: 24,
                    ),
                    if (jobController.isLoading.value || _isAutoRefreshing)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.kgreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.tenVertical),
        SearchField(
          isBorderBlue: true,
          isEnabled: false,
          text: 'Search for Security Guards',
          isIconColorBlue: false,
          icon2: AppAssets.kSearch,
          guardsController: guardsController,
        ),
      ],
    );
  }

  Widget _buildTabFilters() {
    List<String> filters = [
      "Active",
      "In Progress",
      "Pending",
      "Completed",
      "Cancelled"
    ];

    return GetBuilder<JobController>(
      builder: (controller) {
        final statusCounts = controller.statusCounts;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              bool selected = controller.selectedFilter.value == filter;
              final jobCount = statusCounts[filter] ?? 0;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: selected ? AppColors.kSkyBlue : AppColors.kgrey,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  backgroundColor:
                      selected ? AppColors.kSkyBlue : AppColors.kDarkBlue,
                  selectedColor: AppColors.kSkyBlue,
                  showCheckmark: false,
                  selected: selected,
                  label: Text(
                    filter,
                    style: AppTypography.kBold14.copyWith(
                      color: selected ? Colors.white : AppColors.kWhite,
                    ),
                  ),

                  //  Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Text(
                  //       filter,
                  //       style: AppTypography.kBold14.copyWith(
                  //         color: selected ? Colors.white : AppColors.kWhite,
                  //       ),
                  //     ),
                  // SizedBox(width: 4),
                  // Container(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  //   decoration: BoxDecoration(
                  //     color: selected
                  //         ? Colors.white
                  //         : AppColors.kSkyBlue.withOpacity(0.3),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Text(
                  //     jobCount.toString(),
                  //     style: AppTypography.kBold12.copyWith(
                  //       color: selected ? AppColors.kSkyBlue : Colors.white,
                  //     ),
                  //   ),
                  // ),
                  //   ],
                  // ),
                  onSelected: (_) => controller.setFilter(filter),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildLastRefreshIndicator() {
    return Obx(() {
      final timeDifference =
          DateTime.now().difference(jobController.lastAutoRefreshTime.value);
      final secondsAgo = timeDifference.inSeconds;

      String timeText;
      if (secondsAgo < 60) {
        timeText = '$secondsAgo seconds ago';
      } else if (secondsAgo < 120) {
        timeText = '1 minute ago';
      } else {
        timeText = '${timeDifference.inMinutes} minutes ago';
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.access_time,
            size: 12,
            color: AppColors.kgrey,
          ),
          SizedBox(width: 4),
          Text(
            'Updated $timeText',
            style: AppTypography.kLight12.copyWith(color: AppColors.kgrey),
          ),
          SizedBox(width: 8),
          if (jobController.isLoading.value)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.kSkyBlue),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildJobList() {
    return GetBuilder<JobController>(
      builder: (controller) {
        final jobs = controller.filteredJobs;
        if (jobs.isEmpty) {
          return Center(
            child: Text('No jobs found', style: TextStyle(color: Colors.white)),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshJobs();
          },
          child: ListView.separated(
            itemCount: jobs.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppSpacing.fifteenVertical),
            itemBuilder: (context, index) {
              final jobApp = jobs[index];

              // Calculate buttonText and showButton based on job status
              String? buttonText;
              bool showButton = false;
              final jobStatus = jobApp.job.status.toLowerCase();
              final checkIn = jobApp.assignedShift.checkInRequired ?? false;
              final checkOut = jobApp.assignedShift.checkOutRequired ?? false;

              if (jobStatus == 'active' || jobStatus == 'in_progress') {
                if (checkIn && !checkOut) {
                  buttonText = 'Check In';
                  showButton = true;
                } else if (!checkIn && checkOut) {
                  buttonText = 'Check Out';
                  showButton = true;
                } else {
                  buttonText = null;
                  showButton = false;
                }
              } else if (jobStatus == 'completed') {
                buttonText = 'Share your review';
                showButton = true;
              } else {
                buttonText = null;
                showButton = false;
              }

              return JobCardWidget(
                key: ValueKey(
                    '${jobApp.id}_${jobApp.job.status}'), // Include status in key for proper rebuild
                job: JobModel(
                  id: jobApp.job.id,
                  title: jobApp.job.title,
                  guardName: jobApp.job.contractor.name ?? '--',
                  rating: '',
                  location: jobApp.job.location,
                  distance: jobApp.job.latitude,
                  time: jobApp.job.shifts.isNotEmpty
                      ? '${jobApp.job.shifts[0].startTime} - ${jobApp.job.shifts[0].endTime}'
                      : '',
                  status: jobApp.job.status,
                  statusLabel: jobApp.job.status,
                  price: jobApp.job.payPerHour.isNotEmpty &&
                          jobApp.job.status.toLowerCase() == 'completed'
                      ? '\$${jobApp.job.payPerHour}'
                      : '',
                  remainingTime: null,
                  nestedCards: null,
                  showButton: showButton,
                  buttonText: buttonText,
                ),
                shiftId: jobApp.assignedShift.shift.id,
                latitude: jobApp.job.latitude,
                longitude: jobApp.job.longitude,
                isCheckInRequired:
                    jobApp.assignedShift.checkInRequired ?? false,
                isCheckOutRequired:
                    jobApp.assignedShift.checkOutRequired ?? false,
                jobId: jobApp.job.id,
                contractorId: jobApp.job.contractor.id,
                guardId: controller.userController.userData.value!.id!,
                date: jobApp.job.shifts.isNotEmpty
                    ? jobApp.job.shifts[0].date
                    : '',
                time: jobApp.job.shifts.isNotEmpty
                    ? '${jobApp.job.shifts[0].startTime.substring(0, 5)} - ${jobApp.job.shifts[0].endTime.substring(0, 5)}'
                    : '',
              );
            },
          ),
        );
      },
    );
  }
}

class JobCardWidget extends StatelessWidget {
  final JobModel job;
  final String shiftId;
  final String latitude;
  final String longitude;
  final bool isCheckInRequired;
  final bool isCheckOutRequired;
  final String guardId;
  final String jobId;
  final String contractorId;
  final String date;
  final String time;

  const JobCardWidget(
      {super.key,
      required this.job,
      required this.shiftId,
      required this.latitude,
      required this.longitude,
      required this.isCheckInRequired,
      required this.isCheckOutRequired,
      required this.guardId,
      required this.jobId,
      required this.contractorId,
      required this.date,
      required this.time});

  Color _getCardColor() {
    switch (job.status) {
      case 'Active':
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
      case 'Active':
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
                  job.id = jobId;
                  if (isCheckInRequired == true &&
                      isCheckOutRequired == false) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CheckInPage(
                          job: job,
                          shiftId: shiftId,
                          latitude: latitude,
                          longitude: longitude,
                          isCheckInRequired: isCheckInRequired,
                          isCheckOutRequired: isCheckOutRequired),
                    );
                  } else if (isCheckInRequired == false &&
                      isCheckOutRequired == true) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CheckInPage(
                          job: job,
                          shiftId: shiftId,
                          latitude: latitude,
                          longitude: longitude,
                          isCheckInRequired: isCheckInRequired,
                          isCheckOutRequired: isCheckOutRequired),
                    );
                  } else if (job.buttonText == 'Share your review') {
                    Get.to(() => SubmitReviewScreen(
                          jobTitle: job.title,
                          guardName: job.guardName,
                          jobDate: time,
                          payPerHour: job.price,
                          jobId: jobId,
                          contractorId: contractorId,
                          guardId: guardId,
                          date: date,
                        ));
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
