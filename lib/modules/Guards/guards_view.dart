// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:tac/controllers/mapController.dart';
// import 'package:tac/data/data/constants/app_assets.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/constants.dart';
// import 'package:tac/modules/home/components/search_field.dart';
// import 'package:tac/modules/search/search_view.dart';
// import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

// import '../../controllers/user_controller.dart';
// import '../../data/data/constants/app_colors.dart';
// import '../../dataproviders/api_service.dart';
// import '../../models/jobCard_model.dart';
// import '../../models/jobResponse_model.dart';
// import '../../models/job_model.dart';
// import '../alerts/notification_view.dart';
// import 'dummy_data.dart';

// class GuardsViewController extends GetxController {
//   final RxList<JobData> jobList = <JobData>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//   final RxString selectedFilter = 'All'.obs;
//   final myApiService = MyApIService();
//   MapController mapController = Get.find<MapController>();

//   final RxString searchQuery = ''.obs;
//   final RxMap<String, double> cachedDistances = <String, double>{}.obs;
//   final RxBool isFirstLoad = true.obs;

//    final TextEditingController searchController = TextEditingController();


//   void clearDistanceCache() {
//     cachedDistances.clear();
//     isFirstLoad.value = true;
//   }

//   Timer? _refreshTimer;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchJob();
//     _refreshTimer = Timer.periodic(const Duration(seconds: 90), (_) => fetchJob(forceRefresh: false));
//   }

//   @override
//   void onClose() {
//     _refreshTimer?.cancel();
//     super.onClose();
//   }

//   // Fetch jobs from API
//   Future<void> fetchJob({bool forceRefresh = true}) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       final response = await myApiService.getJobsList();

//       if (response.statusCode == 200) {
//         final nearbyJobsResponse = NearbyJobsResponse.fromJson(jsonDecode(response.body));
//         jobList.value = nearbyJobsResponse.data;

//         // Calculate distances only on first load or forced refresh
//         if (isFirstLoad.value || forceRefresh) {
//           await _calculateDistances();
//           isFirstLoad.value = false;
//         }
//       } else {
//         errorMessage.value = 'Failed to load jobs. Status code: ${response.statusCode}';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error fetching jobs: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> _calculateDistances() async {
//     for (var job in jobList) {
//       if (!cachedDistances.containsKey(job.id)) {
//         try {
//           final distance = await mapController.getJobLocation(job.latitude, job.longitude);
//           cachedDistances[job.id] = distance;
//         } catch (e) {
//           debugPrint('Error calculating distance for job ${job.id}: $e');
//         }
//       }
//     }
//   }


//   // Future<String> getJobDistance(String jobId, String latitude, String longitude) async {
//   //   if (cachedDistances.containsKey(jobId)) {
//   //     return '${cachedDistances[jobId]!.truncate()} mi away';
//   //   }
//   //
//   //   try {
//   //     final distance = await mapController.getJobLocation(latitude, longitude);
//   //     cachedDistances[jobId] = distance;
//   //     return '${distance.truncate()} mi away';
//   //   } catch (e) {
//   //     return 'Distance unavailable';
//   //   }
//   // }

//   // // Get filtered jobs based on selected department/category
//   // List<JobData> getFilteredJobs() {
//   //   if (selectedFilter.value == 'All') {
//   //     return jobList;
//   //   } else {
//   //     return jobList.where((job) => _getCategoryType(job) == selectedFilter.value).toList();
//   //   }
//   // }

//   // Update getFilteredJobs to include search
//   List<JobData> getFilteredJobs() {
//     var jobs = jobList.where((job) {
//       // Apply search filter
//       if (searchQuery.value.isNotEmpty) {
//         final query = searchQuery.value.toLowerCase();
//         return job.title.toLowerCase().contains(query) ||
//             job.contractorName.toLowerCase().contains(query) ||
//             job.categoryName.toLowerCase().contains(query) ||
//             job.location.toLowerCase().contains(query);
//       }
//       return true;
//     }).toList();

//     // Apply category filter
//     if (selectedFilter.value != 'All') {
//       jobs = jobs.where((job) => _getCategoryType(job) == selectedFilter.value).toList();
//     }

//     return jobs;
//   }

//   // Helper method to determine job category/department type
//   String _getCategoryType(JobData job) {
//     // Map job categories to filter types
//     if (job.categoryName.toLowerCase().contains('armed')) {
//       return 'Armed';
//     } else if (job.categoryName.toLowerCase().contains('event')) {
//       return 'Event';
//     } else if (job.categoryName.toLowerCase().contains('corporate')) {
//       return 'Corporate';
//     } else {
//       return 'Other';
//     }
//   }

//   // Convert job data to job card model
//   Future<JobCardModel> jobDataToCardModel(JobData job) async {
//     // Get first shift for display
//     final firstShift = job.shifts.isNotEmpty ? job.shifts.first : null;

//     // Format days string
//     String dayStr = firstShift != null && firstShift.days.isNotEmpty
//         ? firstShift.days.join(', ')
//         : 'N/A';

//     // Format shift time string
//     String shiftTimeStr = firstShift != null
//         ? '${_formatTime(firstShift.startTime)} - ${_formatTime(firstShift.endTime)}'
//         : 'N/A';

//     return JobCardModel(
//       jobTitle: job.title,
//       perHourRate: '\$${job.payPerHour}/hr',
//       companyName: job.contractorName.isNotEmpty ? job.contractorName : 'Company',
//       rating: '4.5', // Placeholder since rating isn't in API
//       hiringTag: 'Hiring Now',
//       jobType: job.categoryName,
//       location: _shortenLocation(job.location),
//       distance: null,
//       // distance: await _getDistanceInMiles(job.latitude, job.longitude),
//       // distance: '${job.distance?.toStringAsFixed(1)} mi',
//       day: dayStr,
//       shiftTime: shiftTimeStr,
//       requiredPersons: '${job.noOfGuardsRequired} guards needed',
//       jobDept: _getCategoryType(job),
//       jobData: job, // Pass original data for details screen
//     );
//   }

//   // Helper to get distance in miles
//   Future<String> getDistanceInMiles(String latitude, String longitude) async {
//     double calculatedDistance = await mapController.getJobLocation(latitude, longitude);
//     return '${calculatedDistance.truncate()} mi away';
//   }

//   // Helper to format time from API (HH:MM:SS) to more readable format
//   String _formatTime(String timeStr) {
//     try {
//       final parts = timeStr.split(':');
//       if (parts.length < 2) return timeStr;

//       int hour = int.parse(parts[0]);
//       final minute = parts[1];
//       final period = hour >= 12 ? 'PM' : 'AM';

//       // Convert to 12-hour format
//       if (hour > 12) hour -= 12;
//       if (hour == 0) hour = 12;

//       return '$hour:$minute $period';
//     } catch (e) {
//       return timeStr;
//     }
//   }

//   // Helper to shorten location for display
//   String _shortenLocation(String location) {
//     if (location.length > 25) {
//       return location.substring(0, 25) + '...';
//     }
//     return location;
//   }

//    void performSearch() {
//     searchQuery.value = searchController.text;
//     // Navigate to search view with current data
//     Get.to(() => SearchView(guardsController: this));
//   }

// }


import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tac/controllers/mapController.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/home/components/search_field.dart';
import 'package:tac/modules/search/search_view.dart';
import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_colors.dart';
import '../../dataproviders/api_service.dart';
import '../../models/jobCard_model.dart';
import '../../models/jobResponse_model.dart';
import '../../models/job_model.dart';
import '../alerts/notification_view.dart';
import 'dummy_data.dart';

class GuardsViewController extends GetxController {
  final RxList<JobData> jobList = <JobData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final myApiService = MyApIService();
  MapController mapController = Get.find<MapController>();

  final RxString searchQuery = ''.obs;
  final RxMap<String, double> cachedDistances = <String, double>{}.obs;
  final RxBool isFirstLoad = true.obs;

  final TextEditingController searchController = TextEditingController();

  void clearDistanceCache() {
    cachedDistances.clear();
    isFirstLoad.value = true;
  }

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    fetchJob();
    _refreshTimer = Timer.periodic(const Duration(seconds: 90), (_) => fetchJob(forceRefresh: false));
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }

  // Fetch jobs from API
  Future<void> fetchJob({bool forceRefresh = true}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await myApiService.getJobsList();

      if (response.statusCode == 200) {
        final nearbyJobsResponse = NearbyJobsResponse.fromJson(jsonDecode(response.body));
        jobList.value = nearbyJobsResponse.data;

        // Calculate distances only on first load or forced refresh
        if (isFirstLoad.value || forceRefresh) {
          await _calculateDistances();
          isFirstLoad.value = false;
        }
      } else {
        errorMessage.value = 'Failed to load jobs. Status code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching jobs: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _calculateDistances() async {
    for (var job in jobList) {
      if (!cachedDistances.containsKey(job.id)) {
        try {
          final distance = await mapController.getJobLocation(job.latitude, job.longitude);
          cachedDistances[job.id] = distance;
        } catch (e) {
          debugPrint('Error calculating distance for job ${job.id}: $e');
        }
      }
    }
  }

  // Update getFilteredJobs to include search and work with the same job list
  List<JobData> getFilteredJobs() {
    // Always start with the complete job list
    var jobs = List<JobData>.from(jobList);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      jobs = jobs.where((job) {
        return job.title.toLowerCase().contains(query) ||
            job.contractorName.toLowerCase().contains(query) ||
            job.categoryName.toLowerCase().contains(query) ||
            job.location.toLowerCase().contains(query);
      }).toList();
    }

    // Apply category filter
    if (selectedFilter.value != 'All') {
      jobs = jobs.where((job) => _getCategoryType(job) == selectedFilter.value).toList();
    }

    return jobs;
  }

  // Helper method to determine job category/department type
  String _getCategoryType(JobData job) {
    String categoryLower = job.categoryName.toLowerCase();
    String titleLower = job.title.toLowerCase();
    
    // Check both category name and title for armed jobs
    if (categoryLower.contains('armed') || titleLower.contains('armed')) {
      return 'Armed';
    } else if (categoryLower.contains('event') || titleLower.contains('event')) {
      return 'Event';
    } else if (categoryLower.contains('corporate') || titleLower.contains('corporate')) {
      return 'Corporate';
    } else {
      return 'Other';
    }
  }

  // Convert job data to job card model
  Future<JobCardModel> jobDataToCardModel(JobData job) async {
    // Get first shift for display
    final firstShift = job.shifts.isNotEmpty ? job.shifts.first : null;

    // Format days string
    String dayStr = firstShift != null && firstShift.days.isNotEmpty
        ? firstShift.days.join(', ')
        : 'N/A';

    // Format shift time string
    String shiftTimeStr = firstShift != null
        ? '${_formatTime(firstShift.startTime)} - ${_formatTime(firstShift.endTime)}'
        : 'N/A';

    return JobCardModel(
      jobTitle: job.title,
      perHourRate: '\$${job.payPerHour}/hr',
      companyName: job.contractorName.isNotEmpty ? job.contractorName : 'Company',
      rating: '4.5', // Placeholder since rating isn't in API
      hiringTag: 'Hiring Now',
      jobType: job.categoryName,
      location: _shortenLocation(job.location),
      distance: null,
      day: dayStr,
      shiftTime: shiftTimeStr,
      requiredPersons: '${job.noOfGuardsRequired} guards needed',
      jobDept: _getCategoryType(job),
      jobData: job, // Pass original data for details screen
    );
  }

  // Helper to get distance in miles
  Future<String> getDistanceInMiles(String latitude, String longitude) async {
    double calculatedDistance = await mapController.getJobLocation(latitude, longitude);
    return '${calculatedDistance.truncate()} mi away';
  }

  // Helper to format time from API (HH:MM:SS) to more readable format
  String _formatTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length < 2) return timeStr;

      int hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      return '$hour:$minute $period';
    } catch (e) {
      return timeStr;
    }
  }

  // Helper to shorten location for display
  String _shortenLocation(String location) {
    if (location.length > 25) {
      return location.substring(0, 25) + '...';
    }
    return location;
  }

  void performSearch() {
    searchQuery.value = searchController.text;
    // Navigate to search view with current data
    Get.to(() => SearchView(guardsController: this));
  }

  // Update filter selection
  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
  }
}

class GuardsView extends StatelessWidget {
  const GuardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GuardsViewController());

    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(context),
              SizedBox(height: AppSpacing.tenVertical),
              Text('Available Jobs', style: AppTypography.kBold20.copyWith(
                  color: AppColors.kWhite
              )),
              SizedBox(height: AppSpacing.fiveVertical),
              _buildFilterChips(controller),
              SizedBox(height: AppSpacing.tenVertical),
              Expanded(
                  child: _buildJobList(controller)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(GuardsViewController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip("All", controller),
          SizedBox(width: 10),
          _buildFilterChip("Armed", controller),
          SizedBox(width: 10),
          _buildFilterChip("Event", controller),
          SizedBox(width: 10),
          _buildFilterChip("Corporate", controller),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, GuardsViewController controller) {
    String displayTitle;

  // Determine the display title based on the filter chip's label
  if (label == "All") {
    displayTitle = "All Jobs";
  } else if (label == "Armed") {
    displayTitle = "Armed Guard";
  } else if (label == "Event") {
    displayTitle = "Event Security";
  } else if (label == "Corporate") {
    displayTitle = "Corporate";
  } else {
    // Fallback for any other labels
    displayTitle = label;
  }
    return Obx(() => FilterChip(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
              color: AppColors.kSkyBlue
          )
      ),
      label: Text(displayTitle),
      selected: controller.selectedFilter.value == label,
      onSelected: (bool selected) {
        if (selected) {
          controller.selectedFilter.value = label;
        }
      },
      backgroundColor: AppColors.kDarkBlue,
      selectedColor: AppColors.kSkyBlue,
      disabledColor: AppColors.kDarkBlue,
      showCheckmark: false,
      surfaceTintColor: Colors.transparent,
      labelStyle: AppTypography.kBold14.copyWith(
        color: controller.selectedFilter.value == label ? Colors.white : AppColors.kSkyBlue,
      ),
    ));
  }

  Widget _buildJobList(GuardsViewController controller) {
    return Obx(() {
      if (controller.isLoading.value && controller.jobList.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.kWhite),
        );
      }

      if (controller.errorMessage.value.isNotEmpty && controller.jobList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.errorMessage.value,
                style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchJob(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                ),
                child: Text(
                  'Retry',
                  style: AppTypography.kBold14.copyWith(color: AppColors.kDarkBlue),
                ),
              ),
            ],
          ),
        );
      }

      final filteredJobs = controller.getFilteredJobs();

      if (filteredJobs.isEmpty) {
        return Center(
          child: Text(
            'No guards available for this category',
            style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
            textAlign: TextAlign.center,
          ),
        );
      }
      return RefreshIndicator(
        color: AppColors.kSkyBlue,
        backgroundColor: AppColors.kDarkestBlue,
        onRefresh: () => controller.fetchJob(forceRefresh: true),
        child: ListView.separated(
          itemCount: filteredJobs.length,
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
          itemBuilder: (context, index) {
            final jobData = filteredJobs[index];
            return FutureBuilder<JobCardModel>(
              future: controller.jobDataToCardModel(jobData),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    color: AppColors.kDarkBlue,
                  ));
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                  );
                } else if (!snapshot.hasData) {
                  return const SizedBox();
                }
                final jobCardModel = snapshot.data!;
                return JobCard(
                  jobTitle: jobCardModel.jobTitle,
                  perHourRate: jobCardModel.perHourRate,
                  companyName: jobCardModel.companyName,
                  rating: jobCardModel.rating,
                  hiringTag: jobCardModel.hiringTag,
                  jobType: jobCardModel.jobType,
                  location: jobCardModel.location,
                  distance: jobCardModel.distance,
                  day: jobCardModel.day,
                  shiftTime: jobCardModel.shiftTime,
                  requiredPersons: jobCardModel.requiredPersons,
                  jobDept: jobCardModel.jobDept,
                  jobData: jobData,
                );
              },
            );
          },

        ),
      );
    });
  }
}

// class GuardsView extends StatefulWidget {
//   const GuardsView({super.key});
//
//   @override
//   State<GuardsView> createState() => _GuardsViewState();
// }
//
// class _GuardsViewState extends State<GuardsView> {
//
//   String selectedFilter = "All"; // Default filter
//
//   @override
//   Widget build(BuildContext context) {
//     List<JobCard> filteredList = selectedFilter == "All" ?
//     jobList : jobList.where((job) => job.jobDept == selectedFilter).toList();
//
//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _appBar(context),
//               SizedBox(height: AppSpacing.tenVertical,),
//               Text('Available Guards', style: AppTypography.kBold20.copyWith(
//                 color: AppColors.kWhite
//               ),),
//               SizedBox(height: AppSpacing.fiveVertical,),
//               Wrap(
//                 spacing: 10.0,
//                 children: [
//                   _buildFilterChip("All"),
//                   _buildFilterChip("Armed"),
//                   _buildFilterChip("Event"),
//                   _buildFilterChip("Corporate"),
//                 ],
//               ),
//               SizedBox(height: AppSpacing.tenVertical,),
//               Flexible(
//                 child: ListView.separated(
//                   itemCount: filteredList.length,
//                   separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
//                   itemBuilder: (context, index) {
//                     final job = filteredList[index]; // Extract job object
//                     return JobCard(
//                       jobTitle: job.jobTitle,
//                       perHourRate: job.perHourRate,
//                       companyName: job.companyName,
//                       rating: job.rating,
//                       hiringTag: job.hiringTag,
//                       jobType: job.jobType,
//                       location: job.location,
//                       distance: job.distance,
//                       day: job.day,
//                       shiftTime: job.shiftTime,
//                       requiredPersons: job.requiredPersons,
//                       jobDept: job.jobDept,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // BUILD FILTER CHIPS
//   Widget _buildFilterChip(String label) {
//     return FilterChip(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(
//           color: AppColors.kSkyBlue
//         )
//       ),
//       label: Text(label,),
//       selected: selectedFilter == label,
//       onSelected: (bool selected) {
//         setState(() {
//           selectedFilter = label;
//         });
//       },
//       backgroundColor: AppColors.kDarkBlue, // Unselected chips will have Dark Blue background
//       selectedColor: AppColors.kSkyBlue, // Selected chip color
//       disabledColor: AppColors.kDarkBlue, // Ensure disabled chips also have Dark Blue background
//       showCheckmark: false, // No checkmark inside the chip
//       surfaceTintColor: Colors.transparent, // Prevent unwanted overlay effects
//       labelStyle: AppTypography.kBold14.copyWith(
//         color: selectedFilter == label ? Colors.white : AppColors.kSkyBlue, // White text when selected, SkyBlue otherwise
//       ),
//     );
//   }
//
//   int selectedIndex = 0;
// }

Widget _appBar(BuildContext context) {
  final userController = Get.find<UserController>();
  final controller = Get.find<GuardsViewController>();
  return Column(
    children: [
      Row(
        children: [
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

          Row(
                children: [
                  Image.asset(
                     AppAssets.kTacLogo,
                    height: Get.height * 0.045,
                    // width: Get.width * 0.18,
                    fit: BoxFit.contain,
                  ),

                  
          SizedBox(width: 4),
                  Text(
                    'Find Jobs',
                    style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                  ),
                ],
              ),
          const Spacer(),
          Stack(
            children: [
              Column(
                children: [
                  IconButton(
                    focusColor: AppColors.kPrimary,
                    color: AppColors.kPrimary,
                    icon: SvgPicture.asset(
                        width: 35,
                        height: 35,
                        AppAssets.kAlerts
                    ),
                    onPressed: () {
                      Get.to<void>(() => NotificationScreen());                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 6,),
          // Obx(() {
          //   final imagePath = userController.userData.value?.profileImages?.first.imageUrl;
          //   // userController.userData.value?.profileImages?.first.imageUrl
          //   final imageUrl = MyApIService.fullImageUrl(imagePath);
          //   return Container(
          //     width: 34,
          //     height: 34,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(4),
          //       image: DecorationImage(
          //         image: imageUrl != null
          //             ? NetworkImage(imageUrl)
          //             : AssetImage(AppAssets.kUserPicture) as ImageProvider,
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   );
          // }),
            Builder(
        builder: (_) {
          final profileImages = userController.userData.value?.profileImages;
          final mainImage = profileImages?.firstWhereOrNull((img) => img.isMain == true);
          final imageUrl = (mainImage?.imageUrl != null && mainImage!.imageUrl!.isNotEmpty)
              ? '${MyApIService.imageBaseUrl}/${mainImage.imageUrl}'
              : null;

          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: imageUrl != null
                    ? NetworkImage(imageUrl)
                    :  AssetImage(AppAssets.kUserPicture) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
        ],
      ),
      SizedBox(height: AppSpacing.tenVertical,),
      SearchField(
        isBorderBlue: false,
        isIconColorBlue: false,
        icon2: AppAssets.kSearch,
        text: 'Search for Security Guards',
        isEnabled: true,
        controller: controller.searchController,
        onChanged: (value) {
          final controller = Get.find<GuardsViewController>();
          controller.searchQuery.value = value;
        },
        onSearchPressed: () {
          // This will be called when search icon is pressed
        final controller = Get.find<GuardsViewController>();
          controller.performSearch();
        },
      ),
    ],
  );
}

