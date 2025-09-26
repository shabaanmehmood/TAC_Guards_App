// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:tac/data/data/constants/app_assets.dart';
// // // import 'package:tac/data/data/constants/app_spacing.dart';
// // // import 'package:tac/modules/home/components/search_field.dart';
// // // import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

// // // import '../../data/data/constants/app_colors.dart';
// // // import '../../data/data/constants/app_typography.dart';
// // // import '../../models/jobCard_model.dart';
// // // import '../../models/job_model.dart';
// // // import '../Guards/guards_view.dart';
// // // import '../fiilters/sort_overlay.dart';

// // // class SearchViewController extends GetxController {
// // //   final RxList<JobData> jobList = <JobData>[].obs;
// // //   final RxString searchQuery = ''.obs;
// // //   final RxString selectedFilter = 'All'.obs;
// // //   final RxList<String> appliedFilters = <String>[].obs;
// // //   final RxString sortBy = 'Latest'.obs;

  

// // //   void updateFilter(String filter) {
// // //     selectedFilter.value = filter;
// // //   }

// // //   // void initWithData() {
// // //   //   final guardsController = Get.find<GuardsViewController>();
// // //   //   jobList.value = guardsController.jobList;
// // //   // }

// // //    // Update the method to take the controller as a parameter
// // //     void initWithData(GuardsViewController guardsController) {
// // //     jobList.value = guardsController.jobList;
// // //      }

// // //   List<JobData> getFilteredJobs() {
// // //     var jobs = jobList.where((job) {
// // //       if (searchQuery.value.isNotEmpty) {
// // //         final query = searchQuery.value.toLowerCase();
// // //         return job.title.toLowerCase().contains(query) ||
// // //             job.contractorName.toLowerCase().contains(query) ||
// // //             job.categoryName.toLowerCase().contains(query) ||
// // //             job.location.toLowerCase().contains(query);
// // //       }
// // //       return true;
// // //     }).toList();

// // //     if (selectedFilter.value != 'All') {
// // //       jobs = jobs.where((job) => _getCategoryType(job) == selectedFilter.value).toList();
// // //     }

// // //     if (appliedFilters.isNotEmpty) {
// // //       jobs = jobs.where((job) {
// // //         return appliedFilters.every((filter) {
// // //           return true;
// // //         });
// // //       }).toList();
// // //     }

// // //     switch (sortBy.value) {
// // //       case 'Latest':
// // //         jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
// // //         break;
// // //       case 'Oldest':
// // //         jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
// // //         break;
// // //       case 'Pay Rate (High to Low)':
// // //         jobs.sort((a, b) => b.payPerHour.compareTo(a.payPerHour));
// // //         break;
// // //       case 'Pay Rate (Low to High)':
// // //         jobs.sort((a, b) => a.payPerHour.compareTo(b.payPerHour));
// // //         break;
// // //     }

// // //     return jobs;
// // //   }

// // //   String _getCategoryType(JobData job) {
// // //     if (job.categoryName.toLowerCase().contains('armed')) {
// // //       return 'Armed';
// // //     } else if (job.categoryName.toLowerCase().contains('event')) {
// // //       return 'Event';
// // //     } else if (job.categoryName.toLowerCase().contains('corporate')) {
// // //       return 'Corporate';
// // //     } else {
// // //       return 'Other';
// // //     }
// // //   }

// // //   void addFilter(String filter) {
// // //     if (!appliedFilters.contains(filter)) {
// // //       appliedFilters.add(filter);
// // //     }
// // //   }

// // //   void removeFilter(String filter) {
// // //     appliedFilters.remove(filter);
// // //   }

// // //   void setSortBy(String sort) {
// // //     sortBy.value = sort;
// // //   }
// // // }

// // // class SearchView extends StatelessWidget {
// // //   final GuardsViewController guardsController; // Add this propert
  
// // //   final controller = Get.put(SearchViewController());

// // //   // SearchView({Key? key}) : super(key: key) {
// // //   //   controller.initWithData();
// // //   // }

// // //   SearchView({Key? key, required this.guardsController}) : super(key: key) {
// // //     controller.initWithData(guardsController);
// // //      }
   
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: AppColors.kDarkBlue,
// // //       body: SafeArea(
// // //         child: Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               _buildAppBar(context),
// // //               SizedBox(height: AppSpacing.tenVertical),
// // //               Obx(() => controller.appliedFilters.isEmpty
// // //                   ? SizedBox()
// // //                   : _buildAppliedFilters()),
// // //               SizedBox(height: AppSpacing.tenVertical),
// // //               Row(
// // //                 children: [
// // //                   Obx(() => Text(
// // //                     '${controller.getFilteredJobs().length} records found',
// // //                     style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
// // //                   )),
// // //                   Spacer(),
// // //                   TextButton.icon(
// // //                     onPressed: () => showSortBottomSheet(context),
// // //                     label: Text(
// // //                       'Sort by',
// // //                       style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
// // //                     ),
// // //                     icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
// // //                   ),
// // //                 ],
// // //               ),
// // //               SizedBox(height: AppSpacing.fiveVertical),
// // //               _buildFilterChips(),
// // //               SizedBox(height: AppSpacing.tenVertical),
// // //               Expanded(
// // //                 child: Obx(() {
// // //                   final jobs = controller.getFilteredJobs();
// // //                   return ListView.separated(
// // //                     itemCount: jobs.length,
// // //                     separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
// // //                     itemBuilder: (context, index) {
// // //                       final job = jobs[index];
// // //                       return FutureBuilder<JobCardModel>(
// // //                         future: Get.find<GuardsViewController>().jobDataToCardModel(job),
// // //                         builder: (context, snapshot) {
// // //                           if (!snapshot.hasData) return SizedBox();
// // //                           return JobCard(
// // //                             jobTitle: snapshot.data!.jobTitle,
// // //                             perHourRate: snapshot.data!.perHourRate,
// // //                             companyName: snapshot.data!.companyName,
// // //                             rating: snapshot.data!.rating,
// // //                             hiringTag: snapshot.data!.hiringTag,
// // //                             jobType: snapshot.data!.jobType,
// // //                             location: snapshot.data!.location,
// // //                             distance: snapshot.data!.distance,
// // //                             day: snapshot.data!.day,
// // //                             shiftTime: snapshot.data!.shiftTime,
// // //                             requiredPersons: snapshot.data!.requiredPersons,
// // //                             jobDept: snapshot.data!.jobDept,
// // //                             jobData: job,
// // //                           );
// // //                         },
// // //                       );
// // //                     },
// // //                   );
// // //                 }),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildAppBar(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         Row(
// // //           mainAxisAlignment: MainAxisAlignment.start,
// // //           children: [
// // //             TextButton.icon(
// // //               onPressed: () => Get.back(canPop: true),
// // //               label: Text('Search', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
// // //               icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
// // //             ),
// // //           ],
// // //         ),
// // //         Divider(color: Colors.grey),
// // //         SizedBox(height: AppSpacing.tenVertical),
// // //         SearchField(
// // //           isBorderBlue: true,
// // //           isIconColorBlue: true,
// // //           text: 'Armed Security Jobs in Perth',
// // //           icon1: AppAssets.kCross,
// // //           icon2: AppAssets.kFilter,
// // //           leadingIcon: AppAssets.kSearch,
// // //           isEnabled: true,
// // //           controller: TextEditingController(),
// // //           onChanged: (value) {
// // //             controller.searchQuery.value = value;
// // //           },

// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildAppliedFilters() {
// // //     return Wrap(
// // //       spacing: 8,
// // //       children: controller.appliedFilters.map((filter) {
// // //         return Chip(
// // //           label: Text(filter),
// // //           onDeleted: () => controller.removeFilter(filter),
// // //           backgroundColor: AppColors.kSkyBlue,
// // //           labelStyle: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
// // //         );
// // //       }).toList(),
// // //     );
// // //   }

// // //   Widget _buildFilterChips() {
// // //     return SingleChildScrollView(
// // //       scrollDirection: Axis.horizontal,
// // //       child: Row(
// // //         children: [
// // //           _buildFilterChip("All"),
// // //           SizedBox(width: 10),
// // //           _buildFilterChip("Armed"),
// // //           SizedBox(width: 10),
// // //           _buildFilterChip("Event"),
// // //           SizedBox(width: 10),
// // //           _buildFilterChip("Corporate"),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildFilterChip(String label) {
// // //     return Obx(() => FilterChip(
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(8),
// // //         side: BorderSide(color: AppColors.kSkyBlue),
// // //       ),
// // //       label: Text(label),
// // //       selected: controller.selectedFilter.value == label,
// // //       onSelected: (bool selected) {
// // //         controller.updateFilter(label);
// // //       },
// // //       backgroundColor: AppColors.kDarkBlue,
// // //       selectedColor: AppColors.kSkyBlue,
// // //       disabledColor: AppColors.kDarkBlue,
// // //       showCheckmark: false,
// // //       surfaceTintColor: Colors.transparent,
// // //       labelStyle: AppTypography.kBold14.copyWith(
// // //         color: controller.selectedFilter.value == label ? Colors.white : AppColors.kSkyBlue,
// // //       ),
// // //     ));
// // //   }
// // // }



// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:tac/data/data/constants/app_assets.dart';
// // import 'package:tac/data/data/constants/app_spacing.dart';
// // import 'package:tac/modules/home/components/search_field.dart';
// // import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

// // import '../../data/data/constants/app_colors.dart';
// // import '../../data/data/constants/app_typography.dart';
// // import '../../models/jobCard_model.dart';
// // import '../../models/job_model.dart';
// // import '../Guards/guards_view.dart';
// // import '../fiilters/sort_overlay.dart';

// // class SearchViewController extends GetxController {
// //   final RxList<JobData> jobList = <JobData>[].obs;
// //   final RxString searchQuery = ''.obs;
// //   final RxString selectedFilter = 'All'.obs;
// //   final RxList<String> appliedFilters = <String>[].obs;
// //   final RxString sortBy = 'Latest'.obs;

// //     // Advanced filter properties
// //   final RxDouble payRateMin = 20.0.obs;
// //   final RxDouble payRateMax = 100.0.obs;
// //   final RxString jobType = ''.obs;
// //   final RxString shiftTiming = ''.obs;
// //   final RxString requiredLevel = ''.obs;
// //   final RxString experience = ''.obs;
// //   final RxList<String> licenses = <String>[].obs;
// //   final RxList<String> premises = <String>[].obs;
// //   final RxString location = ''.obs;
// //   final RxBool useCurrentLocation = true.obs;

// //   final TextEditingController searchController = TextEditingController();

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     searchController.text = searchQuery.value;
// //   }

// //   @override
// //   void onClose() {
// //     searchController.dispose();
// //     super.onClose();
// //   }
  

// //   void updateFilter(String filter) {
// //     selectedFilter.value = filter;
// //   }

// //   // void initWithData() {
// //   //   final guardsController = Get.find<GuardsViewController>();
// //   //   jobList.value = guardsController.jobList;
// //   // }

// //    // Update the method to take the controller as a parameter
// //     void initWithData(GuardsViewController guardsController) {
// //     jobList.value = guardsController.jobList;

// //       if (guardsController.searchQuery.value.isNotEmpty) {
// //       searchQuery.value = guardsController.searchQuery.value;
// //       searchController.text = guardsController.searchQuery.value;
// //     }
// //      }

// //  List<JobData> getFilteredJobs() {
// //   var jobs = jobList.where((job) {
// //     // Apply search filter
// //     if (searchQuery.value.isNotEmpty) {
// //       final query = searchQuery.value.toLowerCase();
// //       bool matchesSearch = job.title.toLowerCase().contains(query) ||
// //           job.contractorName.toLowerCase().contains(query) ||
// //           job.categoryName.toLowerCase().contains(query) ||
// //           job.location.toLowerCase().contains(query);
// //       if (!matchesSearch) return false;
// //     }

// //     // Apply category filter
// //     if (selectedFilter.value != 'All') {
// //       if (_getCategoryType(job) != selectedFilter.value) return false;
// //     }

// //     // Apply advanced filters
// //     if (appliedFilters.isNotEmpty) {
// //       double jobPayRate = double.tryParse(job.payPerHour.toString()) ?? 0.0;
// //       // Pay rate filter
// //       if (jobPayRate < payRateMin.value || jobPayRate > payRateMax.value) {
// //         return false;
// //       }

// //       // Job type filter
// //       if (jobType.value.isNotEmpty) {
// //         // You can implement job type matching based on your job data structure
// //         // For now, we'll skip this filter
// //       }

// //       // Shift timing filter
// //       if (shiftTiming.value.isNotEmpty) {
// //         // Check if job matches shift timing
// //         bool hasMatchingShift = job.shifts.any((shift) {
// //           String startHour = shift.startTime.split(':')[0];
// //           int hour = int.tryParse(startHour) ?? 0;
          
// //           switch (shiftTiming.value) {
// //             case 'Morning':
// //               return hour >= 6 && hour < 12;
// //             case 'Afternoon':
// //               return hour >= 12 && hour < 17;
// //             case 'Evening':
// //               return hour >= 17 && hour < 21;
// //             case 'Night':
// //               return hour >= 21 || hour < 6;
// //             default:
// //               return true;
// //           }
// //         });
// //         if (!hasMatchingShift) return false;
// //       }

// //       // Location filter
// //       if (location.value.isNotEmpty && !useCurrentLocation.value) {
// //         if (!job.location.toLowerCase().contains(location.value.toLowerCase())) {
// //           return false;
// //         }
// //       }

// //       // License filters
// //       if (licenses.isNotEmpty) {
// //         // This would need to be implemented based on your job data structure
// //         // For now, we'll assume all jobs match license requirements
// //       }

// //       // Premises filters
// //       if (premises.isNotEmpty) {
// //         bool matchesPremises = premises.any((premise) =>
// //             job.categoryName.toLowerCase().contains(premise.toLowerCase()));
// //         if (!matchesPremises) return false;
// //       }
// //     }

// //     return true;
// //   }).toList();

// //   // Apply sorting
// //   switch (sortBy.value) {
// //     case 'Latest':
// //       jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
// //       break;
// //     case 'Oldest':
// //       jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
// //       break;
// //     case 'Pay Rate (High to Low)':
// //       jobs.sort((a, b) => b.payPerHour.compareTo(a.payPerHour));
// //       break;
// //     case 'Pay Rate (Low to High)':
// //       jobs.sort((a, b) => a.payPerHour.compareTo(b.payPerHour));
// //       break;
// //     case 'Most Relevant':
// //       // Sort by relevance based on search query match and other factors
// //       if (searchQuery.value.isNotEmpty) {
// //         jobs.sort((a, b) => _calculateRelevanceScore(b).compareTo(_calculateRelevanceScore(a)));
// //       } else {
// //         // If no search query, fall back to latest
// //         jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
// //       }
// //       break;
// //   }

// //   return jobs;
// // }
// // double _calculateRelevanceScore(JobData job) {
// //   double score = 0.0;
  
// //   if (searchQuery.value.isNotEmpty) {
// //     final query = searchQuery.value.toLowerCase();
    
// //     // Title match gets highest score
// //     if (job.title.toLowerCase().contains(query)) {
// //       score += 100.0;
// //       // Exact title match gets bonus
// //       if (job.title.toLowerCase() == query) {
// //         score += 50.0;
// //       }
// //     }
    
// //     // Company name match
// //     if (job.contractorName.toLowerCase().contains(query)) {
// //       score += 75.0;
// //     }
    
// //     // Category match
// //     if (job.categoryName.toLowerCase().contains(query)) {
// //       score += 60.0;
// //     }
    
// //     // Location match
// //     if (job.location.toLowerCase().contains(query)) {
// //       score += 40.0;
// //     }
    
// //     // Recent jobs get slight bonus for relevance
// //     final daysSinceCreated = DateTime.now().difference(job.createdAt).inDays;
// //     if (daysSinceCreated <= 7) {
// //       score += 20.0;
// //     } else if (daysSinceCreated <= 30) {
// //       score += 10.0;
// //     }
// //      double jobPayRate = double.tryParse(job.payPerHour.toString()) ?? 0.0;
// //     // Higher pay rate gets slight bonus
// //     score += (jobPayRate / 10.0);
// //   }
  
// //   return score;
// // }


// //   String _getCategoryType(JobData job) {
// //     if (job.categoryName.toLowerCase().contains('armed')) {
// //       return 'Armed';
// //     } else if (job.categoryName.toLowerCase().contains('event')) {
// //       return 'Event';
// //     } else if (job.categoryName.toLowerCase().contains('corporate')) {
// //       return 'Corporate';
// //     } else {
// //       return 'Other';
// //     }
// //   }

// //   void addFilter(String filter) {
// //     if (!appliedFilters.contains(filter)) {
// //       appliedFilters.add(filter);
// //     }
// //   }

// //   void removeFilter(String filter) {
// //     appliedFilters.remove(filter);
// //   }

// //   void setSortBy(String sort) {
// //     sortBy.value = sort;
// //     update();
// //   }

// //   // Method to apply advanced filters
// //   void applyAdvancedFilters(Map<String, dynamic> filters) {
// //     payRateMin.value = filters['payRateMin'] ?? 20.0;
// //     payRateMax.value = filters['payRateMax'] ?? 100.0;
// //     jobType.value = filters['jobType'] ?? '';
// //     shiftTiming.value = filters['shiftTiming'] ?? '';
// //     requiredLevel.value = filters['requiredLevel'] ?? '';
// //     experience.value = filters['experience'] ?? '';
// //     licenses.value = List<String>.from(filters['licenses'] ?? []);
// //     premises.value = List<String>.from(filters['premises'] ?? []);
// //     location.value = filters['location'] ?? '';
// //     useCurrentLocation.value = filters['useCurrentLocation'] ?? true;

// //     // Add filter labels to applied filters
// //     appliedFilters.clear();
// //     if (jobType.value.isNotEmpty) appliedFilters.add(jobType.value);
// //     if (shiftTiming.value.isNotEmpty) appliedFilters.add(shiftTiming.value);
// //     if (requiredLevel.value.isNotEmpty) appliedFilters.add('Level ${requiredLevel.value}');
// //     if (experience.value.isNotEmpty) appliedFilters.add('${experience.value} years');
// //     appliedFilters.addAll(licenses);
// //     appliedFilters.addAll(premises);
// //     if (location.value.isNotEmpty && !useCurrentLocation.value) {
// //       appliedFilters.add(location.value);
// //     }
// //   }

// //   void performSearch() {
// //     searchQuery.value = searchController.text;
// //   }
// // }

// // class SearchView extends StatelessWidget {
// //   final GuardsViewController guardsController; // Add this propert
  
// //   final controller = Get.put(SearchViewController());

// //   // SearchView({Key? key}) : super(key: key) {
// //   //   controller.initWithData();
// //   // }

// //   SearchView({Key? key, required this.guardsController}) : super(key: key) {
// //     controller.initWithData(guardsController);
// //      Get.put(SortController());
// //      }
   
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.kDarkBlue,
// //       body: SafeArea(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildAppBar(context),
// //               SizedBox(height: AppSpacing.tenVertical),
// //               Obx(() => controller.appliedFilters.isEmpty
// //                   ? SizedBox()
// //                   : _buildAppliedFilters()),
// //               SizedBox(height: AppSpacing.tenVertical),
// //               Row(
// //                 children: [
// //                   Obx(() => Text(
// //                     '${controller.getFilteredJobs().length} records found',
// //                     style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
// //                   )),
// //                   Spacer(),
// //   //                 TextButton.icon(
// //   //                                      onPressed: () {
// //   //                     // Make sure SortController is initialized before showing
// //   //                     if (!Get.isRegistered<SortController>()) {
// //   //                       Get.put(SortController());
// //   //                     }
// //   //                     showSortBottomSheet(context);
// //   //                   },
// //   // label: Text(
// //   //                     'Sort by',
// //   //                     style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
// //   //                   ),
// //   //                   icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
// //   //                 ),

// //    Obx(() => TextButton.icon(
// //                     onPressed: () {
// //                       // Make sure SortController is initialized before showing
// //                       if (!Get.isRegistered<SortController>()) {
// //                         Get.put(SortController());
// //                       }
// //                       showSortBottomSheet(context);
// //                     },
// //                     label: Text(
// //                       'Sort by: ${_getSortDisplayName()}',
// //                       style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
// //                     ),
// //                     icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
// //                   )),
// //                 ],
// //               ),
// //               SizedBox(height: AppSpacing.fiveVertical),
// //               _buildFilterChips(),
// //               SizedBox(height: AppSpacing.tenVertical),
// //               Expanded(
// //                 child: Obx(() {
// //                   final jobs = controller.getFilteredJobs();
// //                   if (jobs.isEmpty) {
// //                     return Center(
// //                       child: Text(
// //                         'No jobs found matching your criteria',
// //                         style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
// //                       ),
// //                     );
// //                   }
// //                   return ListView.separated(
// //                     itemCount: jobs.length,
// //                     separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
// //                     itemBuilder: (context, index) {
// //                       final job = jobs[index];
// //                       return FutureBuilder<JobCardModel>(
// //                         future: Get.find<GuardsViewController>().jobDataToCardModel(job),
// //                         builder: (context, snapshot) {
// //                           if (!snapshot.hasData) return SizedBox();
// //                           return JobCard(
// //                             jobTitle: snapshot.data!.jobTitle,
// //                             perHourRate: snapshot.data!.perHourRate,
// //                             companyName: snapshot.data!.companyName,
// //                             rating: snapshot.data!.rating,
// //                             hiringTag: snapshot.data!.hiringTag,
// //                             jobType: snapshot.data!.jobType,
// //                             location: snapshot.data!.location,
// //                             distance: snapshot.data!.distance,
// //                             day: snapshot.data!.day,
// //                             shiftTime: snapshot.data!.shiftTime,
// //                             requiredPersons: snapshot.data!.requiredPersons,
// //                             jobDept: snapshot.data!.jobDept,
// //                             jobData: job,
// //                           );
// //                         },
// //                       );
// //                     },
// //                   );
// //                 }),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // Replace the _getSortDisplayName() method with this updated version
// // String _getSortDisplayName() {
// //   switch (controller.sortBy.value) {
// //     case 'Latest':
// //       return 'Recent';
// //     case 'Oldest':
// //       return 'Oldest'; // Fixed typo from "OldReest"
// //     case 'Pay Rate (High to Low)':
// //       return 'Pay ↓';
// //     case 'Pay Rate (Low to High)':
// //       return 'Pay ↑';
// //     case 'Most Relevant':
// //       return 'Relevant';
// //     default:
// //       return 'Recent';
// //   }
// // }

// //   Widget _buildAppBar(BuildContext context) {
// //     return Column(
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.start,
// //           children: [
// //             TextButton.icon(
// //               onPressed: () => Get.back(canPop: true),
// //               label: Text('Search', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
// //               icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
// //             ),
// //           ],
// //         ),
// //         Divider(color: Colors.grey),
// //         SizedBox(height: AppSpacing.tenVertical),
// //         SearchField(
// //           isBorderBlue: true,
// //           isIconColorBlue: true,
// //           text: 'Armed Security Jobs in Perth',
// //           icon1: AppAssets.kCross,
// //           icon2: AppAssets.kFilter,
// //           leadingIcon: AppAssets.kSearch,
// //           isEnabled: true,
// //            controller: controller.searchController,
// //           onChanged: (value) {
// //             controller.searchQuery.value = value;
// //           },
// //           onSearchPressed: () {
// //             controller.performSearch();
// //           },
          

// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildAppliedFilters() {
// //     return Wrap(
// //       spacing: 8,
// //       children: controller.appliedFilters.map((filter) {
// //         return Chip(
// //           label: Text(filter),
// //           onDeleted: () => controller.removeFilter(filter),
// //           backgroundColor: AppColors.kSkyBlue,
// //           labelStyle: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
// //         );
// //       }).toList(),
// //     );
// //   }

// //   Widget _buildFilterChips() {
// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       child: Row(
// //         children: [
// //           _buildFilterChip("All"),
// //           SizedBox(width: 10),
// //           _buildFilterChip("Armed"),
// //           SizedBox(width: 10),
// //           _buildFilterChip("Event"),
// //           SizedBox(width: 10),
// //           _buildFilterChip("Corporate"),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFilterChip(String label) {
// //     return Obx(() => FilterChip(
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(8),
// //         side: BorderSide(color: AppColors.kSkyBlue),
// //       ),
// //       label: Text(label),
// //       selected: controller.selectedFilter.value == label,
// //       onSelected: (bool selected) {
// //         controller.updateFilter(label);
// //       },
// //       backgroundColor: AppColors.kDarkBlue,
// //       selectedColor: AppColors.kSkyBlue,
// //       disabledColor: AppColors.kDarkBlue,
// //       showCheckmark: false,
// //       surfaceTintColor: Colors.transparent,
// //       labelStyle: AppTypography.kBold14.copyWith(
// //         color: controller.selectedFilter.value == label ? Colors.white : AppColors.kSkyBlue,
// //       ),
// //     ));
// //   }
// // }



// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:tac/data/data/constants/app_assets.dart';
// // // import 'package:tac/data/data/constants/app_spacing.dart';
// // // import 'package:tac/modules/home/components/search_field.dart';
// // // import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

// // // import '../../data/data/constants/app_colors.dart';
// // // import '../../data/data/constants/app_typography.dart';
// // // import '../../models/jobCard_model.dart';
// // // import '../../models/job_model.dart';
// // // import '../Guards/guards_view.dart';
// // // import '../fiilters/sort_overlay.dart';

// // // class SearchViewController extends GetxController {
// // //   final RxList<JobData> jobList = <JobData>[].obs;
// // //   final RxString searchQuery = ''.obs;
// // //   final RxString selectedFilter = 'All'.obs;
// // //   final RxList<String> appliedFilters = <String>[].obs;
// // //   final RxString sortBy = 'Latest'.obs;

  

// // //   void updateFilter(String filter) {
// // //     selectedFilter.value = filter;
// // //   }

// // //   // void initWithData() {
// // //   //   final guardsController = Get.find<GuardsViewController>();
// // //   //   jobList.value = guardsController.jobList;
// // //   // }

// // //    // Update the method to take the controller as a parameter
// // //     void initWithData(GuardsViewController guardsController) {
// // //     jobList.value = guardsController.jobList;
// // //      }

// // //   List<JobData> getFilteredJobs() {
// // //     var jobs = jobList.where((job) {
// // //       if (searchQuery.value.isNotEmpty) {
// // //         final query = searchQuery.value.toLowerCase();
// // //         return job.title.toLowerCase().contains(query) ||
// // //             job.contractorName.toLowerCase().contains(query) ||
// // //             job.categoryName.toLowerCase().contains(query) ||
// // //             job.location.toLowerCase().contains(query);
// // //       }
// // //       return true;
// // //     }).toList();

// // //     if (selectedFilter.value != 'All') {
// // //       jobs = jobs.where((job) => _getCategoryType(job) == selectedFilter.value).toList();
// // //     }

// // //     if (appliedFilters.isNotEmpty) {
// // //       jobs = jobs.where((job) {
// // //         return appliedFilters.every((filter) {
// // //           return true;
// // //         });
// // //       }).toList();
// // //     }

// // //     switch (sortBy.value) {
// // //       case 'Latest':
// // //         jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
// // //         break;
// // //       case 'Oldest':
// // //         jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
// // //         break;
// // //       case 'Pay Rate (High to Low)':
// // //         jobs.sort((a, b) => b.payPerHour.compareTo(a.payPerHour));
// // //         break;
// // //       case 'Pay Rate (Low to High)':
// // //         jobs.sort((a, b) => a.payPerHour.compareTo(b.payPerHour));
// // //         break;
// // //     }

// // //     return jobs;
// // //   }

// // //   String _getCategoryType(JobData job) {
// // //     if (job.categoryName.toLowerCase().contains('armed')) {
// // //       return 'Armed';
// // //     } else if (job.categoryName.toLowerCase().contains('event')) {
// // //       return 'Event';
// // //     } else if (job.categoryName.toLowerCase().contains('corporate')) {
// // //       return 'Corporate';
// // //     } else {
// // //       return 'Other';
// // //     }
// // //   }

// // //   void addFilter(String filter) {
// // //     if (!appliedFilters.contains(filter)) {
// // //       appliedFilters.add(filter);
// // //     }
// // //   }

// // //   void removeFilter(String filter) {
// // //     appliedFilters.remove(filter);
// // //   }

// // //   void setSortBy(String sort) {
// // //     sortBy.value = sort;
// // //   }
// // // }

// // // class SearchView extends StatelessWidget {
// // //   final GuardsViewController guardsController; // Add this propert
  
// // //   final controller = Get.put(SearchViewController());

// // //   // SearchView({Key? key}) : super(key: key) {
// // //   //   controller.initWithData();
// // //   // }

// // //   SearchView({Key? key, required this.guardsController}) : super(key: key) {
// // //     controller.initWithData(guardsController);
// // //      }
   
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: AppColors.kDarkBlue,
// // //       body: SafeArea(
// // //         child: Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               _buildAppBar(context),
// // //               SizedBox(height: AppSpacing.tenVertical),
// // //               Obx(() => controller.appliedFilters.isEmpty
// // //                   ? SizedBox()
// // //                   : _buildAppliedFilters()),
// // //               SizedBox(height: AppSpacing.tenVertical),
// // //               Row(
// // //                 children: [
// // //                   Obx(() => Text(
// // //                     '${controller.getFilteredJobs().length} records found',
// // //                     style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
// // //                   )),
// // //                   Spacer(),
// // //                   TextButton.icon(
// // //                     onPressed: () => showSortBottomSheet(context),
// // //                     label: Text(
// // //                       'Sort by',
// // //                       style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
// // //                     ),
// // //                     icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
// // //                   ),
// // //                 ],
// // //               ),
// // //               SizedBox(height: AppSpacing.fiveVertical),
// // //               _buildFilterChips(),
// // //               SizedBox(height: AppSpacing.tenVertical),
// // //               Expanded(
// // //                 child: Obx(() {
// // //                   final jobs = controller.getFilteredJobs();
// // //                   return ListView.separated(
// // //                     itemCount: jobs.length,
// // //                     separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
// // //                     itemBuilder: (context, index) {
// // //                       final job = jobs[index];
// // //                       return FutureBuilder<JobCardModel>(
// // //                         future: Get.find<GuardsViewController>().jobDataToCardModel(job),
// // //                         builder: (context, snapshot) {
// // //                           if (!snapshot.hasData) return SizedBox();
// // //                           return JobCard(
// // //                             jobTitle: snapshot.data!.jobTitle,
// // //                             perHourRate: snapshot.data!.perHourRate,
// // //                             companyName: snapshot.data!.companyName,
// // //                             rating: snapshot.data!.rating,
// // //                             hiringTag: snapshot.data!.hiringTag,
// // //                             jobType: snapshot.data!.jobType,
// // //                             location: snapshot.data!.location,
// // //                             distance: snapshot.data!.distance,
// // //                             day: snapshot.data!.day,
// // //                             shiftTime: snapshot.data!.shiftTime,
// // //                             requiredPersons: snapshot.data!.requiredPersons,
// // //                             jobDept: snapshot.data!.jobDept,
// // //                             jobData: job,
// // //                           );
// // //                         },
// // //                       );
// // //                     },
// // //                   );
// // //                 }),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildAppBar(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         Row(
// // //           mainAxisAlignment: MainAxisAlignment.start,
// // //           children: [
// // //             TextButton.icon(
// // //               onPressed: () => Get.back(canPop: true),
// // //               label: Text('Search', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
// // //               icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
// // //             ),
// // //           ],
// // //         ),
// // //         Divider(color: Colors.grey),
// // //         SizedBox(height: AppSpacing.tenVertical),
// // //         SearchField(
// // //           isBorderBlue: true,
// // //           isIconColorBlue: true,
// // //           text: 'Armed Security Jobs in Perth',
// // //           icon1: AppAssets.kCross,
// // //           icon2: AppAssets.kFilter,
// // //           leadingIcon: AppAssets.kSearch,
// // //           isEnabled: true,
// // //           controller: TextEditingController(),
// // //           onChanged: (value) {
// // //             controller.searchQuery.value = value;
// // //           },

// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildAppliedFilters() {
// // //     return Wrap(
// // //       spacing: 8,
// // //       children: controller.appliedFilters.map((filter) {
// // //         return Chip(
// // //           label: Text(filter),
// // //           onDeleted: () => controller.removeFilter(filter),
// // //           backgroundColor: AppColors.kSkyBlue,
// // //           labelStyle: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
// // //         );
// // //       }).toList(),
// // //     );
// // //   }

// // //   Widget _buildFilterChips() {
// // //     return SingleChildScrollView(
// // //       scrollDirection: Axis.horizontal,
// // //       child: Row(
// // //         children: [
// // //           _buildFilterChip("All"),
// // //           SizedBox(width: 10),
// // //           _buildFilterChip("Armed"),
// // //           SizedBox(width: 10),
// // //           _buildFilterChip("Event"),
// // //           SizedBox(width: 10),
// // //           _buildFilterChip("Corporate"),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildFilterChip(String label) {
// // //     return Obx(() => FilterChip(
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(8),
// // //         side: BorderSide(color: AppColors.kSkyBlue),
// // //       ),
// // //       label: Text(label),
// // //       selected: controller.selectedFilter.value == label,
// // //       onSelected: (bool selected) {
// // //         controller.updateFilter(label);
// // //       },
// // //       backgroundColor: AppColors.kDarkBlue,
// // //       selectedColor: AppColors.kSkyBlue,
// // //       disabledColor: AppColors.kDarkBlue,
// // //       showCheckmark: false,
// // //       surfaceTintColor: Colors.transparent,
// // //       labelStyle: AppTypography.kBold14.copyWith(
// // //         color: controller.selectedFilter.value == label ? Colors.white : AppColors.kSkyBlue,
// // //       ),
// // //     ));
// // //   }
// // // }



// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:tac/data/data/constants/app_assets.dart';
// // // import 'package:tac/data/data/constants/app_spacing.dart';
// // // import 'package:tac/modules/home/components/search_field.dart';
// // // import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

// // // import '../../data/data/constants/app_colors.dart';
// // // import '../../data/data/constants/app_typography.dart';
// // // import '../../models/jobCard_model.dart';
// // // import '../../models/job_model.dart';
// // // import '../Guards/guards_view.dart';
// // // import '../fiilters/sort_overlay.dart';

// // // class SearchViewController extends GetxController {
// // //   final RxList<JobData> jobList = <JobData>[].obs;
// // //   final RxString searchQuery = ''.obs;
// // //   final RxString selectedFilter = 'All'.obs;
// // //   final RxList<String> appliedFilters = <String>[].obs;
// // //   final RxString sortBy = 'Latest'.obs;

// // //     // Advanced filter properties
// // //   final RxDouble payRateMin = 20.0.obs;
// // //   final RxDouble payRateMax = 100.0.obs;
// // //   final RxString jobType = ''.obs;
// // //   final RxString shiftTiming = ''.obs;
// // //   final RxString requiredLevel = ''.obs;
// // //   final RxString experience = ''.obs;
// // //   final RxList<String> licenses = <String>[].obs;
// // //   final RxList<String> premises = <String>[].obs;
// // //   final RxString location = ''.obs;
// // //   final RxBool useCurrentLocation = true.obs;

// // //   final TextEditingController searchController = TextEditingController();

// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //     searchController.text = searchQuery.value;
// // //   }

// // //   @override
// // //   void onClose() {
// // //     searchController.dispose();
// // //     super.onClose();
// // //   }
  

// // //   void updateFilter(String filter) {
// // //     selectedFilter.value = filter;
// // //   }

// // //   // void initWithData() {
// // //   //   final guardsController = Get.find<GuardsViewController>();
// // //   //   jobList.value = guardsController.jobList;
// // //   // }

// // //    // Update the method to take the controller as a parameter
// // //     void initWithData(GuardsViewController guardsController) {
// // //     jobList.value = guardsController.jobList;

// // //       if (guardsController.searchQuery.value.isNotEmpty) {
// // //       searchQuery.value = guardsController.searchQuery.value;
// // //       searchController.text = guardsController.searchQuery.value;
// // //     }
// // //      }

// // //   List<JobData> getFilteredJobs() {
// // //     var jobs = jobList.where((job) {
// // //       // Apply search filter
// // //       if (searchQuery.value.isNotEmpty) {
// // //         final query = searchQuery.value.toLowerCase();
// // //         bool matchesSearch = job.title.toLowerCase().contains(query) ||
// // //             job.contractorName.toLowerCase().contains(query) ||
// // //             job.categoryName.toLowerCase().contains(query) ||
// // //             job.location.toLowerCase().contains(query);
// // //         if (!matchesSearch) return false;
// // //       }

// // //       // Apply category filter
// // //       if (selectedFilter.value != 'All') {
// // //         if (_getCategoryType(job) != selectedFilter.value) return false;
// // //       }

// // //       // Apply advanced filters
// // //       if (appliedFilters.isNotEmpty) {
// // //         double jobPayRate = double.tryParse(job.payPerHour.toString()) ?? 0.0;
// // //         // Pay rate filter
// // //         if (jobPayRate < payRateMin.value || jobPayRate > payRateMax.value) {
// // //           return false;
// // //         }

// // //         // Job type filter
// // //         if (jobType.value.isNotEmpty) {
// // //           // You can implement job type matching based on your job data structure
// // //           // For now, we'll skip this filter
// // //         }

// // //         // Shift timing filter
// // //         if (shiftTiming.value.isNotEmpty) {
// // //           // Check if job matches shift timing
// // //           bool hasMatchingShift = job.shifts.any((shift) {
// // //             String startHour = shift.startTime.split(':')[0];
// // //             int hour = int.tryParse(startHour) ?? 0;
            
// // //             switch (shiftTiming.value) {
// // //               case 'Morning':
// // //                 return hour >= 6 && hour < 12;
// // //               case 'Afternoon':
// // //                 return hour >= 12 && hour < 17;
// // //               case 'Evening':
// // //                 return hour >= 17 && hour < 21;
// // //               case 'Night':
// // //                 return hour >= 21 || hour < 6;
// // //               default:
// // //                 return true;
// // //             }
// // //           });
// // //           if (!hasMatchingShift) return false;
// // //         }

// // //         // Location filter
// // //         if (location.value.isNotEmpty && !useCurrentLocation.value) {
// // //           if (!job.location.toLowerCase().contains(location.value.toLowerCase())) {
// // //             return false;
// // //           }
// // //         }

// // //         // License filters
// // //         if (licenses.isNotEmpty) {
// // //           // This would need to be implemented based on your job data structure
// // //           // For now, we'll assume all jobs match license requirements
// // //         }

// // //         // Premises filters
// // //         if (premises.isNotEmpty) {
// // //           bool matchesPremises = premises.any((premise) =>
// // //               job.categoryName.toLowerCase().contains(premise.toLowerCase()));
// // //           if (!matchesPremises) return false;
// // //         }
// // //       }

// // //       return true;
// // //     }).toList();

// // //     // Apply sorting
// // //    // Apply sorting - This is the key fix!
// // //     switch (sortBy.value) {
// // //       case 'Latest':
// // //         jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
// // //         break;
// // //       case 'Oldest':
// // //         jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
// // //         break;
// // //       case 'Pay Rate (High to Low)':
// // //         jobs.sort((a, b) => b.payPerHour.compareTo(a.payPerHour));
// // //         break;
// // //       case 'Pay Rate (Low to High)':
// // //         jobs.sort((a, b) => a.payPerHour.compareTo(b.payPerHour));
// // //         break;
// // //     }


// // //     return jobs;
// // //   }

// // //   String _getCategoryType(JobData job) {
// // //     if (job.categoryName.toLowerCase().contains('armed')) {
// // //       return 'Armed';
// // //     } else if (job.categoryName.toLowerCase().contains('event')) {
// // //       return 'Event';
// // //     } else if (job.categoryName.toLowerCase().contains('corporate')) {
// // //       return 'Corporate';
// // //     } else {
// // //       return 'Other';
// // //     }
// // //   }

// // //   void addFilter(String filter) {
// // //     if (!appliedFilters.contains(filter)) {
// // //       appliedFilters.add(filter);
// // //     }
// // //   }

// // //   void removeFilter(String filter) {
// // //     appliedFilters.remove(filter);
// // //   }

// // //   void setSortBy(String sort) {
// // //     sortBy.value = sort;
// // //     update();
// // //   }

// // //   // Method to apply advanced filters
// // //   void applyAdvancedFilters(Map<String, dynamic> filters) {
// // //     payRateMin.value = filters['payRateMin'] ?? 20.0;
// // //     payRateMax.value = filters['payRateMax'] ?? 100.0;
// // //     jobType.value = filters['jobType'] ?? '';
// // //     shiftTiming.value = filters['shiftTiming'] ?? '';
// // //     requiredLevel.value = filters['requiredLevel'] ?? '';
// // //     experience.value = filters['experience'] ?? '';
// // //     licenses.value = List<String>.from(filters['licenses'] ?? []);
// // //     premises.value = List<String>.from(filters['premises'] ?? []);
// // //     location.value = filters['location'] ?? '';
// // //     useCurrentLocation.value = filters['useCurrentLocation'] ?? true;

// // //     // Add filter labels to applied filters
// // //     appliedFilters.clear();
// // //     if (jobType.value.isNotEmpty) appliedFilters.add(jobType.value);
// // //     if (shiftTiming.value.isNotEmpty) appliedFilters.add(shiftTiming.value);
// // //     if (requiredLevel.value.isNotEmpty) appliedFilters.add('Level ${requiredLevel.value}');
// // //     if (experience.value.isNotEmpty) appliedFilters.add('${experience.value} years');
// // //     appliedFilters.addAll(licenses);
// // //     appliedFilters.addAll(premises);
// // //     if (location.value.isNotEmpty && !useCurrentLocation.value) {
// // //       appliedFilters.add(location.value);
// // //     }
// // //   }

// // //   void performSearch() {
// // //     searchQuery.value = searchController.text;
// // //   }
// // // }

// // // class SearchView extends StatelessWidget {
// // //   final GuardsViewController guardsController; // Add this propert
  
// // //   final controller = Get.put(SearchViewController());

// // //   // SearchView({Key? key}) : super(key: key) {
// // //   //   controller.initWithData();
// // //   // }

// // //   SearchView({Key? key, required this.guardsController}) : super(key: key) {
// // //     controller.initWithData(guardsController);
// // //      Get.put(SortController());
// // //      }
   
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: AppColors.kDarkBlue,
// // //       body: SafeArea(
// // //         child: Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               _buildAppBar(context),
// // //               SizedBox(height: AppSpacing.tenVertical),
// // //               Obx(() => controller.appliedFilters.isEmpty
// // //                   ? SizedBox()
// // //                   : _buildAppliedFilters()),
// // //               SizedBox(height: AppSpacing.tenVertical),
// // //               Row(
// // //                 children: [
// // //                   Obx(() => Text(
// // //                     '${controller.getFilteredJobs().length} records found',
// // //                     style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
// // //                   )),
// // //                   Spacer(),
// // //                 //   TextButton.icon(
// // //                 //                        onPressed: () {
// // //                 //       // Make sure SortController is initialized before showing
// // //                 //       if (!Get.isRegistered<SortController>()) {
// // //                 //         Get.put(SortController());
// // //                 //       }
// // //                 //       showSortBottomSheet(context);
// // //                 //     },
// // //                 //  label: Text(
// // //                 //       'Sort by',
// // //                 //       style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
// // //                 //     ),
// // //                 //     icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
// // //                 //   ),

// // //                 Obx(() => TextButton.icon(
// // //                     onPressed: () {
// // //                       // Make sure SortController is initialized before showing
// // //                       if (!Get.isRegistered<SortController>()) {
// // //                         Get.put(SortController());
// // //                       }
// // //                       showSortBottomSheet(context);
// // //                     },
// // //                     label: Text(
// // //                       'Sort by: ${_getSortDisplayName()}',
// // //                       style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
// // //                     ),
// // //                     icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
// // //                   )),

// // //                 ],
// // //               ),
// // //               SizedBox(height: AppSpacing.fiveVertical),
// // //               _buildFilterChips(),
// // //               SizedBox(height: AppSpacing.tenVertical),
// // //               Expanded(
// // //                 child: Obx(() {
// // //                   final jobs = controller.getFilteredJobs();
// // //                   return ListView.separated(
// // //                     itemCount: jobs.length,
// // //                     separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
// // //                     itemBuilder: (context, index) {
// // //                       final job = jobs[index];
// // //                       return FutureBuilder<JobCardModel>(
// // //                         future: Get.find<GuardsViewController>().jobDataToCardModel(job),
// // //                         builder: (context, snapshot) {
// // //                           if (!snapshot.hasData) return SizedBox();
// // //                           return JobCard(
// // //                             jobTitle: snapshot.data!.jobTitle,
// // //                             perHourRate: snapshot.data!.perHourRate,
// // //                             companyName: snapshot.data!.companyName,
// // //                             rating: snapshot.data!.rating,
// // //                             hiringTag: snapshot.data!.hiringTag,
// // //                             jobType: snapshot.data!.jobType,
// // //                             location: snapshot.data!.location,
// // //                             distance: snapshot.data!.distance,
// // //                             day: snapshot.data!.day,
// // //                             shiftTime: snapshot.data!.shiftTime,
// // //                             requiredPersons: snapshot.data!.requiredPersons,
// // //                             jobDept: snapshot.data!.jobDept,
// // //                             jobData: job,
// // //                           );
// // //                         },
// // //                       );
// // //                     },
// // //                   );
// // //                 }),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // Helper method to get display name for current sort
// // //   String _getSortDisplayName() {
// // //     switch (controller.sortBy.value) {
// // //       case 'Latest':
// // //         return 'Recent';
// // //       case 'Oldest':
// // //         return 'Oldest';
// // //       case 'Pay Rate (High to Low)':
// // //         return 'Pay ↓';
// // //       case 'Pay Rate (Low to High)':
// // //         return 'Pay ↑';
// // //       default:
// // //         return 'Recent';
// // //     }
// // //   }

// // //   Widget _buildAppBar(BuildContext context) {
// // //     return Column(
// // //       children: [
// // //         Row(
// // //           mainAxisAlignment: MainAxisAlignment.start,
// // //           children: [
// // //             TextButton.icon(
// // //               onPressed: () => Get.back(canPop: true),
// // //               label: Text('Search', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
// // //               icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
// // //             ),
// // //           ],
// // //         ),
// // //         Divider(color: Colors.grey),
// // //         SizedBox(height: AppSpacing.tenVertical),
// // //         SearchField(
// // //           isBorderBlue: true,
// // //           isIconColorBlue: true,
// // //           text: 'Armed Security Jobs in Perth',
// // //           icon1: AppAssets.kCross,
// // //           icon2: AppAssets.kFilter,
// // //           leadingIcon: AppAssets.kSearch,
// // //           isEnabled: true,
// // //           controller: TextEditingController(),
// // //           onChanged: (value) {
// // //             controller.searchQuery.value = value;
// // //           },
// // //           onSearchPressed: () {
// // //             controller.performSearch();
// // //           },

// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildAppliedFilters() {
// // //     return Wrap(
// // //       spacing: 8,
// // //       children: controller.appliedFilters.map((filter) {
// // //         return Chip(
// // //           label: Text(filter),
// // //           onDeleted: () => controller.removeFilter(filter),
// // //           backgroundColor: AppColors.kSkyBlue,
// // //           labelStyle: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
// // //         );
// // //       }).toList(),
// // //     );
// // //   }

// // //   Widget _buildFilterChips() {
// // //     return SingleChildScrollView(
// // //       scrollDirection: Axis.horizontal,
// // //       child: Row(
// // //         children: [
// // //           _buildFilterChip("All"),
// // //           SizedBox(width: 10),
// // //           _buildFilterChip("Armed"),
// // //           SizedBox(width: 10),
// // //           _buildFilterChip("Event"),
// // //           SizedBox(width: 10),
// // //           _buildFilterChip("Corporate"),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildFilterChip(String label) {
// // //     return Obx(() => FilterChip(
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(8),
// // //         side: BorderSide(color: AppColors.kSkyBlue),
// // //       ),
// // //       label: Text(label),
// // //       selected: controller.selectedFilter.value == label,
// // //       onSelected: (bool selected) {
// // //         controller.updateFilter(label);
// // //       },
// // //       backgroundColor: AppColors.kDarkBlue,
// // //       selectedColor: AppColors.kSkyBlue,
// // //       disabledColor: AppColors.kDarkBlue,
// // //       showCheckmark: false,
// // //       surfaceTintColor: Colors.transparent,
// // //       labelStyle: AppTypography.kBold14.copyWith(
// // //         color: controller.selectedFilter.value == label ? Colors.white : AppColors.kSkyBlue,
// // //       ),
// // //     ));
// // //   }
// // // }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_assets.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/modules/home/components/search_field.dart';
// import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

// import '../../data/data/constants/app_colors.dart';
// import '../../data/data/constants/app_typography.dart';
// import '../../models/jobCard_model.dart';
// import '../../models/job_model.dart';
// import '../Guards/guards_view.dart';
// import '../fiilters/sort_overlay.dart';

// class SearchViewController extends GetxController {
//   final RxList<JobData> jobList = <JobData>[].obs;
//   final RxString searchQuery = ''.obs;
//   final RxString selectedFilter = 'All'.obs;
//   final RxList<String> appliedFilters = <String>[].obs;
//   final RxString sortBy = 'Latest'.obs;

//   // Advanced filter properties
//   final RxDouble payRateMin = 0.0.obs;
//   final RxDouble payRateMax = 2000.0.obs;
//   final RxBool usePayRateFilter = false.obs; // Toggle for pay rate filter
//   final RxString jobType = ''.obs;
//   final RxString shiftTiming = ''.obs;
//   final RxString requiredLevel = ''.obs;
//   final RxString experience = ''.obs;
//   final RxList<String> licenses = <String>[].obs;
//   final RxList<String> premises = <String>[].obs;
//   final RxString location = ''.obs;
//   final RxBool useCurrentLocation = true.obs;

//   final TextEditingController searchController = TextEditingController();

//   @override
//   void onInit() {
//     super.onInit();
//     searchController.text = searchQuery.value;
//   }

//   @override
//   void onClose() {
//     searchController.dispose();
//     super.onClose();
//   }

//   void updateFilter(String filter) {
//     selectedFilter.value = filter;
//   }

//   void initWithData(GuardsViewController guardsController) {
//     jobList.value = guardsController.jobList;

//     if (guardsController.searchQuery.value.isNotEmpty) {
//       searchQuery.value = guardsController.searchQuery.value;
//       searchController.text = guardsController.searchQuery.value;
//     }
//   }

//   List<JobData> getFilteredJobs() {
//     // Start with all jobs from the main list
//     var jobs = List<JobData>.from(jobList);

//     // Apply search filter
//     if (searchQuery.value.isNotEmpty) {
//       final query = searchQuery.value.toLowerCase();
//       jobs = jobs.where((job) {
//         return job.title.toLowerCase().contains(query) ||
//             job.contractorName.toLowerCase().contains(query) ||
//             job.categoryName.toLowerCase().contains(query) ||
//             job.location.toLowerCase().contains(query);
//       }).toList();
//     }

//     // Apply category filter (Armed, Event, Corporate)
//     if (selectedFilter.value != 'All') {
//       jobs = jobs.where((job) {
//         String categoryType = _getCategoryType(job);
//         return categoryType == selectedFilter.value;
//       }).toList();
//     }

//     // Apply advanced filters only if they are set
//     if (appliedFilters.isNotEmpty) {
//       jobs = jobs.where((job) {
//         bool matchesFilters = true;

//         // Pay rate filter - only apply if toggle is enabled
//         if (usePayRateFilter.value) {
//           double jobPayRate = double.tryParse(job.payPerHour.toString()) ?? 0.0;
//           if (jobPayRate < payRateMin.value || jobPayRate > payRateMax.value) {
//             matchesFilters = false;
//           }
//         }

//         // Job type filter
//         if (jobType.value.isNotEmpty) {
//           // Match based on job title or category
//           if (!job.title.toLowerCase().contains(jobType.value.toLowerCase()) &&
//               !job.categoryName.toLowerCase().contains(jobType.value.toLowerCase())) {
//             matchesFilters = false;
//           }
//         }

//         // Shift timing filter
//         if (shiftTiming.value.isNotEmpty && job.shifts.isNotEmpty) {
//           bool hasMatchingShift = job.shifts.any((shift) {
//             String startHour = shift.startTime.split(':')[0];
//             int hour = int.tryParse(startHour) ?? 0;
            
//             switch (shiftTiming.value) {
//               case 'Morning':
//                 return hour >= 6 && hour < 12;
//               case 'Afternoon':
//                 return hour >= 12 && hour < 17;
//               case 'Evening':
//                 return hour >= 17 && hour < 21;
//               case 'Night':
//                 return hour >= 21 || hour < 6;
//               default:
//                 return true;
//             }
//           });
//           if (!hasMatchingShift) matchesFilters = false;
//         }

//         // Location filter
//         if (location.value.isNotEmpty && !useCurrentLocation.value) {
//           if (!job.location.toLowerCase().contains(location.value.toLowerCase())) {
//             matchesFilters = false;
//           }
//         }

//         // License filters
//         if (licenses.isNotEmpty) {
//           bool matchesLicense = licenses.any((license) =>
//               job.categoryName.toLowerCase().contains(license.toLowerCase()) ||
//               job.title.toLowerCase().contains(license.toLowerCase()));
//           if (!matchesLicense) matchesFilters = false;
//         }

//         // Premises filters
//         if (premises.isNotEmpty) {
//           bool matchesPremises = premises.any((premise) =>
//               job.premisesTypeName?.toLowerCase().contains(premise.toLowerCase()) ?? false ||
//               job.categoryName.toLowerCase().contains(premise.toLowerCase()));
//           if (!matchesPremises) matchesFilters = false;
//         }

//         return matchesFilters;
//       }).toList();
//     }

//     // Apply sorting
//     switch (sortBy.value) {
//       case 'Latest':
//         jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//         break;
//       case 'Oldest':
//         jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//         break;
//       case 'Pay Rate (High to Low)':
//         jobs.sort((a, b) => b.payPerHour.compareTo(a.payPerHour));
//         break;
//       case 'Pay Rate (Low to High)':
//         jobs.sort((a, b) => a.payPerHour.compareTo(b.payPerHour));
//         break;
//       case 'Most Relevant':
//         if (searchQuery.value.isNotEmpty) {
//           jobs.sort((a, b) => _calculateRelevanceScore(b).compareTo(_calculateRelevanceScore(a)));
//         } else {
//           jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//         }
//         break;
//     }

//     return jobs;
//   }

//   double _calculateRelevanceScore(JobData job) {
//     double score = 0.0;
    
//     if (searchQuery.value.isNotEmpty) {
//       final query = searchQuery.value.toLowerCase();
      
//       if (job.title.toLowerCase().contains(query)) {
//         score += 100.0;
//         if (job.title.toLowerCase() == query) {
//           score += 50.0;
//         }
//       }
      
//       if (job.contractorName.toLowerCase().contains(query)) {
//         score += 75.0;
//       }
      
//       if (job.categoryName.toLowerCase().contains(query)) {
//         score += 60.0;
//       }
      
//       if (job.location.toLowerCase().contains(query)) {
//         score += 40.0;
//       }
      
//       final daysSinceCreated = DateTime.now().difference(job.createdAt).inDays;
//       if (daysSinceCreated <= 7) {
//         score += 20.0;
//       } else if (daysSinceCreated <= 30) {
//         score += 10.0;
//       }

//       double jobPayRate = double.tryParse(job.payPerHour.toString()) ?? 0.0;
//       score += (jobPayRate / 10.0);
//     }
    
//     return score;
//   }

//   String _getCategoryType(JobData job) {
//     String categoryLower = job.categoryName.toLowerCase();
//     String titleLower = job.title.toLowerCase();
    
//     if (categoryLower.contains('armed') || titleLower.contains('armed')) {
//       return 'Armed';
//     } else if (categoryLower.contains('event') || titleLower.contains('event')) {
//       return 'Event';
//     } else if (categoryLower.contains('corporate') || titleLower.contains('corporate')) {
//       return 'Corporate';
//     } else {
//       return 'Other';
//     }
//   }

//   void addFilter(String filter) {
//     if (!appliedFilters.contains(filter)) {
//       appliedFilters.add(filter);
//     }
//   }

//   void removeFilter(String filter) {
//     appliedFilters.remove(filter);
//   }

//   void setSortBy(String sort) {
//     sortBy.value = sort;
//     update();
//   }

//   // Method to apply advanced filters
//   void applyAdvancedFilters(Map<String, dynamic> filters) {
//     payRateMin.value = filters['payRateMin'] ?? 0.0;
//     payRateMax.value = filters['payRateMax'] ?? 2000.0;
//     usePayRateFilter.value = filters['usePayRateFilter'] ?? false;
//     jobType.value = filters['jobType'] ?? '';
//     shiftTiming.value = filters['shiftTiming'] ?? '';
//     requiredLevel.value = filters['requiredLevel'] ?? '';
//     experience.value = filters['experience'] ?? '';
//     licenses.value = List<String>.from(filters['licenses'] ?? []);
//     premises.value = List<String>.from(filters['premises'] ?? []);
//     location.value = filters['location'] ?? '';
//     useCurrentLocation.value = filters['useCurrentLocation'] ?? true;

//     // Clear and rebuild applied filters
//     appliedFilters.clear();
    
//     if (usePayRateFilter.value) {
//       appliedFilters.add('\$${payRateMin.value.toInt()}-\$${payRateMax.value.toInt()}');
//     }
//     if (jobType.value.isNotEmpty) appliedFilters.add(jobType.value);
//     if (shiftTiming.value.isNotEmpty) appliedFilters.add(shiftTiming.value);
//     if (requiredLevel.value.isNotEmpty) appliedFilters.add('Level ${requiredLevel.value}');
//     if (experience.value.isNotEmpty) appliedFilters.add('${experience.value} years');
//     appliedFilters.addAll(licenses);
//     appliedFilters.addAll(premises);
//     if (location.value.isNotEmpty && !useCurrentLocation.value) {
//       appliedFilters.add(location.value);
//     }
//   }

//   void performSearch() {
//     searchQuery.value = searchController.text;
//   }

//   void clearAllFilters() {
//     appliedFilters.clear();
//     selectedFilter.value = 'All';
//     payRateMin.value = 0.0;
//     payRateMax.value = 2000.0;
//     usePayRateFilter.value = false;
//     jobType.value = '';
//     shiftTiming.value = '';
//     requiredLevel.value = '';
//     experience.value = '';
//     licenses.clear();
//     premises.clear();
//     location.value = '';
//     useCurrentLocation.value = true;
//   }
// }

// class SearchView extends StatelessWidget {
//   final GuardsViewController guardsController;
  
//   final controller = Get.put(SearchViewController());

//   SearchView({Key? key, required this.guardsController}) : super(key: key) {
//     controller.initWithData(guardsController);
//     Get.put(SortController());
//   }
   
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildAppBar(context),
//               SizedBox(height: AppSpacing.tenVertical),
//               Obx(() => controller.appliedFilters.isEmpty
//                   ? SizedBox()
//                   : _buildAppliedFilters()),
//               SizedBox(height: AppSpacing.tenVertical),
//               Row(
//                 children: [
//                   Obx(() => Text(
//                     '${controller.getFilteredJobs().length} records found',
//                     style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
//                   )),
//                   Spacer(),
//                   Obx(() => TextButton.icon(
//                     onPressed: () {
//                       if (!Get.isRegistered<SortController>()) {
//                         Get.put(SortController());
//                       }
//                       showSortBottomSheet(context);
//                     },
//                     label: Text(
//                       'Sort by: ${_getSortDisplayName()}',
//                       style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
//                     ),
//                     icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
//                   )),
//                 ],
//               ),
//               SizedBox(height: AppSpacing.fiveVertical),
//               _buildFilterChips(),
//               SizedBox(height: AppSpacing.tenVertical),
//               Expanded(
//                 child: Obx(() {
//                   final jobs = controller.getFilteredJobs();
//                   if (jobs.isEmpty) {
//                     return Center(
//                       child: Text(
//                         'No jobs found matching your criteria',
//                         style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
//                       ),
//                     );
//                   }
//                   return ListView.separated(
//                     itemCount: jobs.length,
//                     separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
//                     itemBuilder: (context, index) {
//                       final job = jobs[index];
//                       return FutureBuilder<JobCardModel>(
//                         future: Get.find<GuardsViewController>().jobDataToCardModel(job),
//                         builder: (context, snapshot) {
//                           // final jobData = snapshot.data!;
//                           // // Print each data field
//                           // print('--- Job Data Loaded ---');
//                           // print('Job Title: ${jobData.jobTitle}');
//                           // print('Per Hour Rate: ${jobData.perHourRate}');
//                           // print('Company Name: ${jobData.companyName}');
//                           // print('Rating: ${jobData.rating}');
//                           // print('Hiring Tag: ${jobData.hiringTag}');
//                           // print('Job Type: ${jobData.jobType}');
//                           // print('Location: ${jobData.location}');
//                           // print('Distance: ${jobData.distance}');
//                           // print('Day: ${jobData.day}');
//                           // print('Shift Time: ${jobData.shiftTime}');
//                           // print('Required Persons: ${jobData.requiredPersons}');
//                           // print('Job Dept: ${jobData.jobDept}');
//                           // print('premisesTypeName : ${job.premisesTypeName}');
//                           // print('--- End of Job Data ---');
                          
//                           if (!snapshot.hasData) return SizedBox();
//                           return JobCard(
//                             jobTitle: snapshot.data!.jobTitle,
//                             perHourRate: snapshot.data!.perHourRate,
//                             companyName: snapshot.data!.companyName,
//                             rating: snapshot.data!.rating,
//                             hiringTag: snapshot.data!.hiringTag,
//                             jobType: snapshot.data!.jobType,
//                             location: snapshot.data!.location,
//                             distance: snapshot.data!.distance,
//                             day: snapshot.data!.day,
//                             shiftTime: snapshot.data!.shiftTime,
//                             requiredPersons: snapshot.data!.requiredPersons,
//                             jobDept: snapshot.data!.jobDept,
//                             jobData: job,
//                           );
//                         },
//                       );
//                     },
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getSortDisplayName() {
//     switch (controller.sortBy.value) {
//       case 'Latest':
//         return 'Recent';
//       case 'Oldest':
//         return 'Oldest';
//       case 'Pay Rate (High to Low)':
//         return 'Pay ↓';
//       case 'Pay Rate (Low to High)':
//         return 'Pay ↑';
//       case 'Most Relevant':
//         return 'Relevant';
//       default:
//         return 'Recent';
//     }
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             TextButton.icon(
//               onPressed: () => Get.back(canPop: true),
//               label: Text('Search', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
//               icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
//             ),
//           ],
//         ),
//         Divider(color: Colors.grey),
//         SizedBox(height: AppSpacing.tenVertical),
//         SearchField(
//           isBorderBlue: true,
//           isIconColorBlue: true,
//           text: 'Armed Security Jobs in Perth',
//           icon1: AppAssets.kCross,
//           icon2: AppAssets.kFilter,
//           leadingIcon: AppAssets.kSearch,
//           isEnabled: true,
//           controller: controller.searchController,
//           onChanged: (value) {
//             controller.searchQuery.value = value;
//           },
//           onSearchPressed: () {
//             controller.performSearch();
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildAppliedFilters() {
//     return Wrap(
//       spacing: 8,
//       children: controller.appliedFilters.map((filter) {
//         return Chip(
//           label: Text(filter),
//           onDeleted: () => controller.removeFilter(filter),
//           backgroundColor: AppColors.kSkyBlue,
//           labelStyle: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildFilterChips() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           _buildFilterChip("All"),
//           SizedBox(width: 10),
//           _buildFilterChip("Armed"),
//           SizedBox(width: 10),
//           _buildFilterChip("Event"),
//           SizedBox(width: 10),
//           _buildFilterChip("Corporate"),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label) {
//     return Obx(() => FilterChip(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(color: AppColors.kSkyBlue),
//       ),
//       label: Text(label),
//       selected: controller.selectedFilter.value == label,
//       onSelected: (bool selected) {
//         controller.updateFilter(label);
//       },
//       backgroundColor: AppColors.kDarkBlue,
//       selectedColor: AppColors.kSkyBlue,
//       disabledColor: AppColors.kDarkBlue,
//       showCheckmark: false,
//       surfaceTintColor: Colors.transparent,
//       labelStyle: AppTypography.kBold14.copyWith(
//         color: controller.selectedFilter.value == label ? Colors.white : AppColors.kSkyBlue,
//       ),
//     ));
//   }
// }

// main code

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_assets.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/modules/home/components/search_field.dart';
// import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

// import '../../data/data/constants/app_colors.dart';
// import '../../data/data/constants/app_typography.dart';
// import '../../models/jobCard_model.dart';
// import '../../models/job_model.dart';
// import '../Guards/guards_view.dart';
// import '../fiilters/sort_overlay.dart';

// class SearchViewController extends GetxController {
//   final RxList<JobData> jobList = <JobData>[].obs;
//   final RxString searchQuery = ''.obs;
//   final RxString selectedFilter = 'All'.obs;
//   final RxList<String> appliedFilters = <String>[].obs;
//   final RxString sortBy = 'Latest'.obs;

//   // Advanced filter properties
//   final RxDouble payRateMin = 0.0.obs;
//   final RxDouble payRateMax = 2000.0.obs;
//   final RxBool usePayRateFilter = false.obs; // Toggle for pay rate filter
//   final RxString jobType = ''.obs;
//   final RxString shiftTiming = ''.obs;
//   final RxString requiredLevel = ''.obs;
//   final RxString experience = ''.obs;
//   final RxList<String> licenses = <String>[].obs;
//   final RxList<String> premises = <String>[].obs;
//   final RxString location = ''.obs;
//   final RxBool useCurrentLocation = true.obs;

//   final TextEditingController searchController = TextEditingController();

//   @override
//   void onInit() {
//     super.onInit();
//     searchController.text = searchQuery.value;
    
//     // Add listener for real-time search updates
//     searchController.addListener(() {
//       if (searchController.text != searchQuery.value) {
//         searchQuery.value = searchController.text;
//         update(); // Trigger UI rebuild
//       }
//     });
//   }

//   @override
//   void onClose() {
//     searchController.dispose();
//     super.onClose();
//   }

//   void updateFilter(String filter) {
//     selectedFilter.value = filter;
//     update(); // Force UI update when filter changes
//   }

//   void initWithData(GuardsViewController guardsController) {
//     jobList.value = guardsController.jobList;

//     if (guardsController.searchQuery.value.isNotEmpty) {
//       searchQuery.value = guardsController.searchQuery.value;
//       searchController.text = guardsController.searchQuery.value;
//     }
//   }

//   List<JobData> getFilteredJobs() {
//     // Start with all jobs from the main list
//     var jobs = List<JobData>.from(jobList);

//     // Apply search filter
//     if (searchQuery.value.isNotEmpty) {
//       final query = searchQuery.value.toLowerCase();
//       jobs = jobs.where((job) {
//         return job.title.toLowerCase().contains(query) ||
//             job.contractorName.toLowerCase().contains(query) ||
//             job.categoryName.toLowerCase().contains(query) ||
//             job.location.toLowerCase().contains(query);
//       }).toList();
//     }

//     // Apply category filter (Armed, Event, Corporate)
//     if (selectedFilter.value != 'All') {
//       jobs = jobs.where((job) {
//         String categoryType = _getCategoryType(job);
//         return categoryType == selectedFilter.value;
//       }).toList();
//     }

//     // Apply advanced filters only if they are set
//     if (appliedFilters.isNotEmpty || usePayRateFilter.value) {
//       jobs = jobs.where((job) {
//         bool matchesFilters = true;

//         // Pay rate filter - only apply if toggle is enabled
//         if (usePayRateFilter.value) {
//           double jobPayRate = double.tryParse(job.payPerHour.toString()) ?? 0.0;
//           if (jobPayRate < payRateMin.value || jobPayRate > payRateMax.value) {
//             matchesFilters = false;
//           }
//         }

//         // Job type filter
//         if (jobType.value.isNotEmpty) {
//           // Match based on job title or category
//           if (!job.title.toLowerCase().contains(jobType.value.toLowerCase()) &&
//               !job.categoryName.toLowerCase().contains(jobType.value.toLowerCase())) {
//             matchesFilters = false;
//           }
//         }

//         // Shift timing filter
//         if (shiftTiming.value.isNotEmpty && job.shifts.isNotEmpty) {
//           bool hasMatchingShift = job.shifts.any((shift) {
//             String startHour = shift.startTime.split(':')[0];
//             int hour = int.tryParse(startHour) ?? 0;
            
//             switch (shiftTiming.value) {
//               case 'Morning':
//                 return hour >= 6 && hour < 12;
//               case 'Afternoon':
//                 return hour >= 12 && hour < 17;
//               case 'Evening':
//                 return hour >= 17 && hour < 21;
//               case 'Night':
//                 return hour >= 21 || hour < 6;
//               default:
//                 return true;
//             }
//           });
//           if (!hasMatchingShift) matchesFilters = false;
//         }

//         // Location filter
//         if (location.value.isNotEmpty && !useCurrentLocation.value) {
//           if (!job.location.toLowerCase().contains(location.value.toLowerCase())) {
//             matchesFilters = false;
//           }
//         }

//         // License filters
//         if (licenses.isNotEmpty) {
//           bool matchesLicense = licenses.any((license) =>
//               job.categoryName.toLowerCase().contains(license.toLowerCase()) ||
//               job.title.toLowerCase().contains(license.toLowerCase()));
//           if (!matchesLicense) matchesFilters = false;
//         }

//         // Premises filters
//         if (premises.isNotEmpty) {
//           bool matchesPremises = premises.any((premise) =>
//               job.premisesTypeName?.toLowerCase().contains(premise.toLowerCase()) ?? false ||
//               job.categoryName.toLowerCase().contains(premise.toLowerCase()));
//           if (!matchesPremises) matchesFilters = false;
//         }

//         return matchesFilters;
//       }).toList();
//     }

//     // Apply sorting
//     switch (sortBy.value) {
//       case 'Latest':
//         jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//         break;
//       case 'Oldest':
//         jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//         break;
//       case 'Pay Rate (High to Low)':
//         jobs.sort((a, b) => b.payPerHour.compareTo(a.payPerHour));
//         break;
//       case 'Pay Rate (Low to High)':
//         jobs.sort((a, b) => a.payPerHour.compareTo(b.payPerHour));
//         break;
//       case 'Most Relevant':
//         if (searchQuery.value.isNotEmpty) {
//           jobs.sort((a, b) => _calculateRelevanceScore(b).compareTo(_calculateRelevanceScore(a)));
//         } else {
//           jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//         }
//         break;
//     }

//     return jobs;
//   }

//   double _calculateRelevanceScore(JobData job) {
//     double score = 0.0;
    
//     if (searchQuery.value.isNotEmpty) {
//       final query = searchQuery.value.toLowerCase();
      
//       if (job.title.toLowerCase().contains(query)) {
//         score += 100.0;
//         if (job.title.toLowerCase() == query) {
//           score += 50.0;
//         }
//       }
      
//       if (job.contractorName.toLowerCase().contains(query)) {
//         score += 75.0;
//       }
      
//       if (job.categoryName.toLowerCase().contains(query)) {
//         score += 60.0;
//       }
      
//       if (job.location.toLowerCase().contains(query)) {
//         score += 40.0;
//       }
      
//       final daysSinceCreated = DateTime.now().difference(job.createdAt).inDays;
//       if (daysSinceCreated <= 7) {
//         score += 20.0;
//       } else if (daysSinceCreated <= 30) {
//         score += 10.0;
//       }

//       double jobPayRate = double.tryParse(job.payPerHour.toString()) ?? 0.0;
//       score += (jobPayRate / 10.0);
//     }
    
//     return score;
//   }

//   String _getCategoryType(JobData job) {
//     String categoryLower = job.categoryName.toLowerCase();
//     String titleLower = job.title.toLowerCase();
    
//     if (categoryLower.contains('armed') || titleLower.contains('armed')) {
//       return 'Armed';
//     } else if (categoryLower.contains('event') || titleLower.contains('event')) {
//       return 'Event';
//     } else if (categoryLower.contains('corporate') || titleLower.contains('corporate')) {
//       return 'Corporate';
//     } else {
//       return 'Other';
//     }
//   }

//   void addFilter(String filter) {
//     if (!appliedFilters.contains(filter)) {
//       appliedFilters.add(filter);
//     }
//     update(); // Force UI update when filter is added
//   }

//   void removeFilter(String filter) {
//     appliedFilters.remove(filter);
    
//     // Remove corresponding advanced filter properties when filter is removed
//     if (filter.contains('\$')) {
//       // This is a pay rate filter
//       usePayRateFilter.value = false;
//       payRateMin.value = 0.0;
//       payRateMax.value = 2000.0;
//     } else if (['Full Time', 'One Time', 'Part Time'].contains(filter)) {
//       jobType.value = '';
//     } else if (['Morning', 'Afternoon', 'Evening', 'Night'].contains(filter)) {
//       shiftTiming.value = '';
//     } else if (filter.startsWith('Level ')) {
//       requiredLevel.value = '';
//     } else if (filter.contains('years')) {
//       experience.value = '';
//     } else if (['Armed', 'Construction Site', 'Mining Site', 'Asset Protection', 'First Aid', 'Driving License'].contains(filter)) {
//       licenses.remove(filter);
//     } else if (['Event Security', 'Corporate Office', 'Mall Security', 'OnSite'].contains(filter)) {
//       premises.remove(filter);
//     } else {
//       // Might be a location filter
//       location.value = '';
//       useCurrentLocation.value = true;
//     }
    
//     update(); // Force UI update when filter is removed
//   }

//   void setSortBy(String sort) {
//     sortBy.value = sort;
//     update();
//   }

//   // Method to apply advanced filters
//   void applyAdvancedFilters(Map<String, dynamic> filters) {
//     payRateMin.value = filters['payRateMin'] ?? 0.0;
//     payRateMax.value = filters['payRateMax'] ?? 2000.0;
//     usePayRateFilter.value = filters['usePayRateFilter'] ?? false;
//     jobType.value = filters['jobType'] ?? '';
//     shiftTiming.value = filters['shiftTiming'] ?? '';
//     requiredLevel.value = filters['requiredLevel'] ?? '';
//     experience.value = filters['experience'] ?? '';
//     licenses.value = List<String>.from(filters['licenses'] ?? []);
//     premises.value = List<String>.from(filters['premises'] ?? []);
//     location.value = filters['location'] ?? '';
//     useCurrentLocation.value = filters['useCurrentLocation'] ?? true;

//     // Clear and rebuild applied filters
//     appliedFilters.clear();
    
//     if (usePayRateFilter.value) {
//       appliedFilters.add('\$${payRateMin.value.toInt()}-\$${payRateMax.value.toInt()}');
//     }
//     if (jobType.value.isNotEmpty) appliedFilters.add(jobType.value);
//     if (shiftTiming.value.isNotEmpty) appliedFilters.add(shiftTiming.value);
//     if (requiredLevel.value.isNotEmpty) appliedFilters.add('Level ${requiredLevel.value}');
//     if (experience.value.isNotEmpty) appliedFilters.add('${experience.value} years');
//     appliedFilters.addAll(licenses);
//     appliedFilters.addAll(premises);
//     if (location.value.isNotEmpty && !useCurrentLocation.value) {
//       appliedFilters.add(location.value);
//     }
    
//     update(); // Force UI update after applying filters
//   }

//   void performSearch() {
//     searchQuery.value = searchController.text;
//     update(); // Force UI update when search is performed
//   }

//   // Method for real-time search updates
//   void onSearchChanged(String value) {
//     searchQuery.value = value;
//     update(); // Force UI update for real-time search
//   }

//   void clearAllFilters() {
//     appliedFilters.clear();
//     selectedFilter.value = 'All';
//     payRateMin.value = 0.0;
//     payRateMax.value = 2000.0;
//     usePayRateFilter.value = false;
//     jobType.value = '';
//     shiftTiming.value = '';
//     requiredLevel.value = '';
//     experience.value = '';
//     licenses.clear();
//     premises.clear();
//     location.value = '';
//     useCurrentLocation.value = true;
//     searchQuery.value = '';
//     searchController.clear();
//     update(); // Force UI update after clearing all filters
//   }
// }

// class SearchView extends StatelessWidget {
//   final GuardsViewController guardsController;
  
//   final controller = Get.put(SearchViewController());

//   SearchView({Key? key, required this.guardsController}) : super(key: key) {
//     controller.initWithData(guardsController);
//     Get.put(SortController());
//   }
   
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildAppBar(context),
//               SizedBox(height: AppSpacing.tenVertical),
//               GetBuilder<SearchViewController>(
//                 builder: (controller) => controller.appliedFilters.isEmpty
//                     ? SizedBox()
//                     : _buildAppliedFilters(),
//               ),
//               SizedBox(height: AppSpacing.tenVertical),
//               Row(
//                 children: [
//                   GetBuilder<SearchViewController>(
//                     builder: (controller) => Text(
//                       '${controller.getFilteredJobs().length} records found',
//                       style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
//                     ),
//                   ),
//                   Spacer(),
//                   GetBuilder<SearchViewController>(
//                     builder: (controller) => TextButton.icon(
//                       onPressed: () {
//                         if (!Get.isRegistered<SortController>()) {
//                           Get.put(SortController());
//                         }
//                         showSortBottomSheet(context);
//                       },
//                       label: Text(
//                         'Sort by: ${_getSortDisplayName()}',
//                         style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
//                       ),
//                       icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSpacing.fiveVertical),
//               _buildFilterChips(),
//               SizedBox(height: AppSpacing.tenVertical),
//               // Row(
//               //   children: [
//               //     Expanded(
//               //       child: ElevatedButton(
//               //         style: ElevatedButton.styleFrom(
//               //           backgroundColor: Colors.transparent,
//               //           side: BorderSide(color: AppColors.kSkyBlue),
//               //           minimumSize: Size(double.infinity, 40),
//               //         ),
//               //         onPressed: () {
//               //           controller.clearAllFilters();
//               //         },
//               //         child: Text(
//               //           'Clear All Filters',
//               //           style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
//               //         ),
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               // SizedBox(height: AppSpacing.tenVertical),
//               Expanded(
//                 child: GetBuilder<SearchViewController>(
//                   builder: (controller) {
//                     final jobs = controller.getFilteredJobs();
//                     if (jobs.isEmpty) {
//                       return Center(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.search_off,
//                                 size: 64,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(height: 16),
//                               Text(
//                                 'No jobs found matching your criteria',
//                                 style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Try adjusting your filters or search terms',
//                                 style: AppTypography.kLight14.copyWith(color: Colors.grey),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//                     return ListView.separated(
//                       itemCount: jobs.length,
//                       separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
//                       itemBuilder: (context, index) {
//                         final job = jobs[index];
//                         return FutureBuilder<JobCardModel>(
//                           future: Get.find<GuardsViewController>().jobDataToCardModel(job),
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData) {
//                               return Container(
//                                 height: 120,
//                                 child: Center(
//                                   child: CircularProgressIndicator(color: AppColors.kSkyBlue),
//                                 ),
//                               );
//                             }
//                             return JobCard(
//                               jobTitle: snapshot.data!.jobTitle,
//                               perHourRate: snapshot.data!.perHourRate,
//                               companyName: snapshot.data!.companyName,
//                               rating: snapshot.data!.rating,
//                               hiringTag: snapshot.data!.hiringTag,
//                               jobType: snapshot.data!.jobType,
//                               location: snapshot.data!.location,
//                               distance: snapshot.data!.distance,
//                               day: snapshot.data!.day,
//                               shiftTime: snapshot.data!.shiftTime,
//                               requiredPersons: snapshot.data!.requiredPersons,
//                               jobDept: snapshot.data!.jobDept,
//                               jobData: job,
//                             );
//                           },
//                         );
//                       },
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

//   String _getSortDisplayName() {
//     switch (controller.sortBy.value) {
//       case 'Latest':
//         return 'Recent';
//       case 'Oldest':
//         return 'Oldest';
//       case 'Pay Rate (High to Low)':
//         return 'Pay ↓';
//       case 'Pay Rate (Low to High)':
//         return 'Pay ↑';
//       case 'Most Relevant':
//         return 'Relevant';
//       default:
//         return 'Recent';
//     }
//   }

//   Widget _buildAppBar(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             TextButton.icon(
//               onPressed: () => Get.back(canPop: true),
//               label: Text('Search', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
//               icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
//             ),
//           ],
//         ),
//         Divider(color: Colors.grey),
//         SizedBox(height: AppSpacing.tenVertical),
//         SearchField(
//           isBorderBlue: true,
//           isIconColorBlue: true,
//           text: 'Armed Security Jobs in Perth',
//           icon1: AppAssets.kCross,
//           icon2: AppAssets.kFilter,
//           leadingIcon: AppAssets.kSearch,
//           isEnabled: true,
//           controller: controller.searchController,
//           onChanged: (value) {
//             controller.onSearchChanged(value); // Use the new method for real-time updates
//           },
//           onSearchPressed: () {
//             controller.performSearch();
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildAppliedFilters() {
//     return Wrap(
//       spacing: 8,
//       children: controller.appliedFilters.map((filter) {
//         return Chip(
//           label: Text(filter),
//           onDeleted: () => controller.removeFilter(filter),
//           backgroundColor: AppColors.kSkyBlue,
//           labelStyle: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildFilterChips() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           _buildFilterChip("All"),
//           SizedBox(width: 10),
//           _buildFilterChip("Armed"),
//           SizedBox(width: 10),
//           _buildFilterChip("Event"),
//           SizedBox(width: 10),
//           _buildFilterChip("Corporate"),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String label) {
//     return GetBuilder<SearchViewController>(
//       builder: (controller) => FilterChip(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//           side: BorderSide(color: AppColors.kSkyBlue),
//         ),
//         label: Text(label),
//         selected: controller.selectedFilter.value == label,
//         onSelected: (bool selected) {
//           controller.updateFilter(label);
//         },
//         backgroundColor: AppColors.kDarkBlue,
//         selectedColor: AppColors.kSkyBlue,
//         disabledColor: AppColors.kDarkBlue,
//         showCheckmark: false,
//         surfaceTintColor: Colors.transparent,
//         labelStyle: AppTypography.kBold14.copyWith(
//           color: controller.selectedFilter.value == label ? Colors.white : AppColors.kSkyBlue,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/modules/home/components/search_field.dart';
import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

import '../../data/data/constants/app_colors.dart';
import '../../data/data/constants/app_typography.dart';
import '../../models/jobCard_model.dart';
import '../../models/job_model.dart';
import '../Guards/guards_view.dart';
import '../fiilters/sort_overlay.dart';

class SearchViewController extends GetxController {
  final RxList<JobData> jobList = <JobData>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'All'.obs;
  final RxList<String> appliedFilters = <String>[].obs;
  final RxString sortBy = 'Latest'.obs;

  // Advanced filter properties
  final RxDouble payRateMin = 0.0.obs;
  final RxDouble payRateMax = 2000.0.obs;
  final RxBool usePayRateFilter = false.obs; // Toggle for pay rate filter
  final RxString jobType = ''.obs;
  final RxString shiftTiming = ''.obs;
  final RxString requiredLevel = ''.obs;
  final RxString experience = ''.obs;
  final RxList<String> licenses = <String>[].obs;
  final RxList<String> premises = <String>[].obs;
  final RxString location = ''.obs;
  final RxBool useCurrentLocation = true.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    searchController.text = searchQuery.value;
    
    // Add listener for real-time search updates
    searchController.addListener(() {
      if (searchController.text != searchQuery.value) {
        searchQuery.value = searchController.text;
        update(); // Trigger UI rebuild
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    update(); // Force UI update when filter changes
  }

  void initWithData(GuardsViewController guardsController) {
    jobList.value = guardsController.jobList;

    if (guardsController.searchQuery.value.isNotEmpty) {
      searchQuery.value = guardsController.searchQuery.value;
      searchController.text = guardsController.searchQuery.value;
    }
  }

  List<JobData> getFilteredJobs() {
    // Start with all jobs from the main list
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

    // Apply category filter (Armed, Event, Corporate)
    if (selectedFilter.value != 'All') {
      jobs = jobs.where((job) {
        String categoryType = _getCategoryType(job);
        return categoryType == selectedFilter.value;
      }).toList();
    }

    // Apply advanced filters only if they are set
    if (appliedFilters.isNotEmpty || usePayRateFilter.value) {
      jobs = jobs.where((job) {
        bool matchesFilters = true;

        // Pay rate filter - only apply if toggle is enabled
        if (usePayRateFilter.value) {
          double jobPayRate = double.tryParse(job.payPerHour.toString()) ?? 0.0;
          if (jobPayRate < payRateMin.value || jobPayRate > payRateMax.value) {
            matchesFilters = false;
          }
        }

        // Job type filter
        if (jobType.value.isNotEmpty) {
          // Match based on job title or category
          if (!job.title.toLowerCase().contains(jobType.value.toLowerCase()) &&
              !job.categoryName.toLowerCase().contains(jobType.value.toLowerCase())) {
            matchesFilters = false;
          }
        }

        // Shift timing filter
        if (shiftTiming.value.isNotEmpty && job.shifts.isNotEmpty) {
          bool hasMatchingShift = job.shifts.any((shift) {
            String startHour = shift.startTime.split(':')[0];
            int hour = int.tryParse(startHour) ?? 0;
            
            switch (shiftTiming.value) {
              case 'Morning':
                return hour >= 6 && hour < 12;
              case 'Afternoon':
                return hour >= 12 && hour < 17;
              case 'Evening':
                return hour >= 17 && hour < 21;
              case 'Night':
                return hour >= 21 || hour < 6;
              default:
                return true;
            }
          });
          if (!hasMatchingShift) matchesFilters = false;
        }

        // Location filter
        if (location.value.isNotEmpty && !useCurrentLocation.value) {
          if (!job.location.toLowerCase().contains(location.value.toLowerCase())) {
            matchesFilters = false;
          }
        }

        // License filters
        if (licenses.isNotEmpty) {
          bool matchesLicense = licenses.any((license) =>
              job.categoryName.toLowerCase().contains(license.toLowerCase()) ||
              job.title.toLowerCase().contains(license.toLowerCase()));
          if (!matchesLicense) matchesFilters = false;
        }

        // Premises filters
        if (premises.isNotEmpty) {
          bool matchesPremises = premises.any((premise) =>
              job.premisesTypeName?.toLowerCase().contains(premise.toLowerCase()) ?? false ||
              job.categoryName.toLowerCase().contains(premise.toLowerCase()));
          if (!matchesPremises) matchesFilters = false;
        }

        return matchesFilters;
      }).toList();
    }

    // Apply sorting
    switch (sortBy.value) {
      case 'Latest':
        jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Oldest':
        jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Pay Rate (High to Low)':
        jobs.sort((a, b) => b.payPerHour.compareTo(a.payPerHour));
        break;
      case 'Pay Rate (Low to High)':
        jobs.sort((a, b) => a.payPerHour.compareTo(b.payPerHour));
        break;
      case 'Most Relevant':
        if (searchQuery.value.isNotEmpty) {
          jobs.sort((a, b) => _calculateRelevanceScore(b).compareTo(_calculateRelevanceScore(a)));
        } else {
          jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }
        break;
    }

    return jobs;
  }

  double _calculateRelevanceScore(JobData job) {
    double score = 0.0;
    
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      
      if (job.title.toLowerCase().contains(query)) {
        score += 100.0;
        if (job.title.toLowerCase() == query) {
          score += 50.0;
        }
      }
      
      if (job.contractorName.toLowerCase().contains(query)) {
        score += 75.0;
      }
      
      if (job.categoryName.toLowerCase().contains(query)) {
        score += 60.0;
      }
      
      if (job.location.toLowerCase().contains(query)) {
        score += 40.0;
      }
      
      final daysSinceCreated = DateTime.now().difference(job.createdAt).inDays;
      if (daysSinceCreated <= 7) {
        score += 20.0;
      } else if (daysSinceCreated <= 30) {
        score += 10.0;
      }

      double jobPayRate = double.tryParse(job.payPerHour.toString()) ?? 0.0;
      score += (jobPayRate / 10.0);
    }
    
    return score;
  }

  String _getCategoryType(JobData job) {
    String categoryLower = job.categoryName.toLowerCase();
    String titleLower = job.title.toLowerCase();
    
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

  void addFilter(String filter) {
    if (!appliedFilters.contains(filter)) {
      appliedFilters.add(filter);
    }
    update(); // Force UI update when filter is added
  }

  void removeFilter(String filter) {
    appliedFilters.remove(filter);
    
    // Remove corresponding advanced filter properties when filter is removed
    if (filter.contains('\$')) {
      // This is a pay rate filter
      usePayRateFilter.value = false;
      payRateMin.value = 0.0;
      payRateMax.value = 2000.0;
    } else if (['Full Time', 'One Time', 'Part Time'].contains(filter)) {
      jobType.value = '';
    } else if (['Morning', 'Afternoon', 'Evening', 'Night'].contains(filter)) {
      shiftTiming.value = '';
    } else if (filter.startsWith('Level ')) {
      requiredLevel.value = '';
    } else if (filter.contains('years')) {
      experience.value = '';
    } else if (['Armed', 'Construction Site', 'Mining Site', 'Asset Protection', 'First Aid', 'Driving License'].contains(filter)) {
      licenses.remove(filter);
    } else if (['Event Security', 'Corporate Office', 'Mall Security', 'OnSite'].contains(filter)) {
      premises.remove(filter);
    } else {
      // Might be a location filter
      location.value = '';
      useCurrentLocation.value = true;
    }

    // Check if we need to update the selectedFilter after removing a filter
    _updateSelectedFilterAfterRemoval(filter);
    
    update(); // Force UI update when filter is removed
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    update();
  }

  // Method to apply advanced filters
  void applyAdvancedFilters(Map<String, dynamic> filters) {
    payRateMin.value = filters['payRateMin'] ?? 0.0;
    payRateMax.value = filters['payRateMax'] ?? 2000.0;
    usePayRateFilter.value = filters['usePayRateFilter'] ?? false;
    jobType.value = filters['jobType'] ?? '';
    shiftTiming.value = filters['shiftTiming'] ?? '';
    requiredLevel.value = filters['requiredLevel'] ?? '';
    experience.value = filters['experience'] ?? '';
    licenses.value = List<String>.from(filters['licenses'] ?? []);
    premises.value = List<String>.from(filters['premises'] ?? []);
    location.value = filters['location'] ?? '';
    useCurrentLocation.value = filters['useCurrentLocation'] ?? true;

    // Clear and rebuild applied filters
    appliedFilters.clear();
    
    if (usePayRateFilter.value) {
      appliedFilters.add('\$${payRateMin.value.toInt()}-\$${payRateMax.value.toInt()}');
    }
    if (jobType.value.isNotEmpty) appliedFilters.add(jobType.value);
    if (shiftTiming.value.isNotEmpty) appliedFilters.add(shiftTiming.value);
    if (requiredLevel.value.isNotEmpty) appliedFilters.add('Level ${requiredLevel.value}');
    if (experience.value.isNotEmpty) appliedFilters.add('${experience.value} years');
    appliedFilters.addAll(licenses);
    appliedFilters.addAll(premises);
    if (location.value.isNotEmpty && !useCurrentLocation.value) {
      appliedFilters.add(location.value);
    }

    // Update selectedFilter based on applied category filters
    _updateSelectedFilterFromAppliedFilters();
    
    update(); // Force UI update after applying filters
  }

  // Helper method to update selectedFilter based on applied category filters
  void _updateSelectedFilterFromAppliedFilters() {
    // Check if any of the applied filters or licenses indicate a specific category
    if (licenses.contains('Armed') || 
        appliedFilters.any((filter) => filter.toLowerCase().contains('armed'))) {
      selectedFilter.value = 'Armed';
    } else if (premises.contains('Event Security') || 
               appliedFilters.any((filter) => filter.toLowerCase().contains('event'))) {
      selectedFilter.value = 'Event';
    } else if (premises.contains('Corporate Office') || 
               appliedFilters.any((filter) => filter.toLowerCase().contains('corporate'))) {
      selectedFilter.value = 'Corporate';
    } else {
      // If no specific category filter is applied, default to 'All'
      selectedFilter.value = 'All';
    }
  }

  // Helper method to update selectedFilter after removing a filter
  void _updateSelectedFilterAfterRemoval(String removedFilter) {
    // If the removed filter was a category-specific filter, re-evaluate
    if (removedFilter == 'Armed' || 
        appliedFilters.isEmpty ||
        (!licenses.contains('Armed') && 
         !premises.contains('Event Security') && 
         !premises.contains('Corporate Office'))) {
      // Re-check what category filters are still applied
      _updateSelectedFilterFromAppliedFilters();
    }
  }

  void performSearch() {
    searchQuery.value = searchController.text;
    update(); // Force UI update when search is performed
  }

  // Method for real-time search updates
  void onSearchChanged(String value) {
    searchQuery.value = value;
    update(); // Force UI update for real-time search
  }

  void clearAllFilters() {
    appliedFilters.clear();
    selectedFilter.value = 'All';
    payRateMin.value = 0.0;
    payRateMax.value = 2000.0;
    usePayRateFilter.value = false;
    jobType.value = '';
    shiftTiming.value = '';
    requiredLevel.value = '';
    experience.value = '';
    licenses.clear();
    premises.clear();
    location.value = '';
    useCurrentLocation.value = true;
    searchQuery.value = '';
    searchController.clear();
    update(); // Force UI update after clearing all filters
  }
}

class SearchView extends StatelessWidget {
  final GuardsViewController guardsController;
  
  final controller = Get.put(SearchViewController());

  SearchView({Key? key, required this.guardsController}) : super(key: key) {
    controller.initWithData(guardsController);
    Get.put(SortController());
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              SizedBox(height: AppSpacing.tenVertical),
              GetBuilder<SearchViewController>(
                builder: (controller) => controller.appliedFilters.isEmpty
                    ? SizedBox()
                    : _buildAppliedFilters(),
              ),
              SizedBox(height: AppSpacing.tenVertical),
              Row(
                children: [
                  GetBuilder<SearchViewController>(
                    builder: (controller) => Text(
                      '${controller.getFilteredJobs().length} records found',
                      style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                    ),
                  ),
                  Spacer(),
                  GetBuilder<SearchViewController>(
                    builder: (controller) => TextButton.icon(
                      onPressed: () {
                        if (!Get.isRegistered<SortController>()) {
                          Get.put(SortController());
                        }
                        showSortBottomSheet(context);
                      },
                      label: Text(
                        'Sort by: ${_getSortDisplayName()}',
                        style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
                      ),
                      icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.fiveVertical),
              // _buildFilterChips(),
              SizedBox(height: AppSpacing.tenVertical),
              // Row(
              //   children: [
              //     Expanded(
              //       child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.transparent,
              //           side: BorderSide(color: AppColors.kSkyBlue),
              //           minimumSize: Size(double.infinity, 40),
              //         ),
              //         onPressed: () {
              //           controller.clearAllFilters();
              //         },
              //         child: Text(
              //           'Clear All Filters',
              //           style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: AppSpacing.tenVertical),
              Expanded(
                child: GetBuilder<SearchViewController>(
                  builder: (controller) {
                    final jobs = controller.getFilteredJobs();
                    if (jobs.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No jobs found matching your criteria',
                                style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Try adjusting your filters or search terms',
                                style: AppTypography.kLight14.copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: jobs.length,
                      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return FutureBuilder<JobCardModel>(
                          future: Get.find<GuardsViewController>().jobDataToCardModel(job),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                height: 120,
                                child: Center(
                                  child: CircularProgressIndicator(color: AppColors.kSkyBlue),
                                ),
                              );
                            }
                            return JobCard(
                              jobTitle: snapshot.data!.jobTitle,
                              perHourRate: snapshot.data!.perHourRate,
                              companyName: snapshot.data!.companyName,
                              rating: snapshot.data!.rating,
                              hiringTag: snapshot.data!.hiringTag,
                              jobType: snapshot.data!.jobType,
                              location: snapshot.data!.location,
                              distance: snapshot.data!.distance,
                              day: snapshot.data!.day,
                              shiftTime: snapshot.data!.shiftTime,
                              requiredPersons: snapshot.data!.requiredPersons,
                              jobDept: snapshot.data!.jobDept,
                              jobData: job,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSortDisplayName() {
    switch (controller.sortBy.value) {
      case 'Latest':
        return 'Recent';
      case 'Oldest':
        return 'Oldest';
      case 'Pay Rate (High to Low)':
        return 'Pay ↓';
      case 'Pay Rate (Low to High)':
        return 'Pay ↑';
      case 'Most Relevant':
        return 'Relevant';
      default:
        return 'Recent';
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => Get.back(canPop: true),
              label: Text('Search', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
            ),
          ],
        ),
        Divider(color: Colors.grey),
        SizedBox(height: AppSpacing.tenVertical),
        SearchField(
          isBorderBlue: true,
          isIconColorBlue: true,
          text: 'Armed Security Jobs in Perth',
          icon1: AppAssets.kCross,
          icon2: AppAssets.kFilter,
          leadingIcon: AppAssets.kSearch,
          isEnabled: true,
          controller: controller.searchController,
          onChanged: (value) {
            controller.onSearchChanged(value); // Use the new method for real-time updates
          },
          onSearchPressed: () {
            controller.performSearch();
          },
        ),
      ],
    );
  }

  Widget _buildAppliedFilters() {
    return Wrap(
      spacing: 8,
      children: controller.appliedFilters.map((filter) {
        return Chip(
          label: Text(filter),
          onDeleted: () => controller.removeFilter(filter),
          backgroundColor: AppColors.kSkyBlue,
          labelStyle: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
        );
      }).toList(),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip("All"),
          SizedBox(width: 10),
          _buildFilterChip("Armed"),
          SizedBox(width: 10),
          _buildFilterChip("Event"),
          SizedBox(width: 10),
          _buildFilterChip("Corporate"),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return GetBuilder<SearchViewController>(
      builder: (controller) => FilterChip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.kSkyBlue),
        ),
        label: Text(label),
        selected: controller.selectedFilter.value == label,
        onSelected: (bool selected) {
          controller.updateFilter(label);
        },
        backgroundColor: AppColors.kDarkBlue,
        selectedColor: AppColors.kSkyBlue,
        disabledColor: AppColors.kDarkBlue,
        showCheckmark: false,
        surfaceTintColor: Colors.transparent,
        labelStyle: AppTypography.kBold14.copyWith(
          color: controller.selectedFilter.value == label ? Colors.white : AppColors.kSkyBlue,
        ),
      ),
    );
  }
}