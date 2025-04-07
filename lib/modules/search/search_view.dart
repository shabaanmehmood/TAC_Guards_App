import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/home/components/search_field.dart';
import 'package:tac/widhets/common%20widgets/buttons/custom_icon_button.dart';
import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

import '../../data/data/constants/app_colors.dart';
import '../Guards/dummy_data.dart';
import '../fiilters/sort_overlay.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SearchViewController extends GetxController {
  var selectedFilter = "All".obs;

  List<JobCard> get filteredList => selectedFilter.value == "All"
      ? jobList
      : jobList.where((job) => job.jobDept == selectedFilter.value).toList();

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }
}

class SearchView extends StatelessWidget {
  final SearchViewController controller = Get.put(SearchViewController());


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
              _appBar(context),
              SizedBox(height: AppSpacing.tenVertical),
              Row(
                children: [
                  Text(
                    '20 records found',
                    style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                  ),
                  Spacer(),
                  TextButton.icon(
                    iconAlignment: IconAlignment.end,
                    onPressed: () {
                      // Ensure SortController is initialized before using it
                      if (!Get.isRegistered<SortController>()) {
                        Get.put(SortController());
                      }
                      showSortBottomSheet(context);
                    },
                    label: Text(
                      'Sort by',
                      style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
                    ),
                    icon: Icon(Icons.filter_list_rounded, color: AppColors.kSkyBlue),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.fiveVertical),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 10.0,
                  children: [
                    _buildFilterChip("All"),
                    _buildFilterChip("Armed"),
                    _buildFilterChip("Event"),
                    _buildFilterChip("Corporate"),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.tenVertical),
              Expanded(
                child: Obx(
                      () => ListView.separated(
                    itemCount: controller.filteredList.length,
                    separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
                    itemBuilder: (context, index) {
                      final job = controller.filteredList[index];
                      return JobCard(
                        jobTitle: job.jobTitle,
                        perHourRate: job.perHourRate,
                        companyName: job.companyName,
                        rating: job.rating,
                        hiringTag: job.hiringTag,
                        jobType: job.jobType,
                        location: job.location,
                        distance: job.distance,
                        day: job.day,
                        shiftTime: job.shiftTime,
                        requiredPersons: job.requiredPersons,
                        jobDept: job.jobDept,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Obx(
          () => FilterChip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.kSkyBlue),
        ),
        label: Text('$label Jobs'),
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

Widget _appBar(BuildContext context) {
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
      ),
    ],
  );
}

