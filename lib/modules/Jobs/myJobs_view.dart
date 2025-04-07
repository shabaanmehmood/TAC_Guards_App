import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/Jobs/myJobs_dummy_data.dart';
import 'package:tac/modules/home/components/search_field.dart';
import 'package:tac/modules/reviews/submit_review.dart';
import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';
import 'package:tac/widhets/common%20widgets/buttons/myJob_card.dart';

import '../../data/data/constants/app_colors.dart';
import '../Guards/dummy_data.dart';
import '../alerts/notification_view.dart';

class MyJobsView extends StatefulWidget {
  const MyJobsView({super.key});

  @override
  State<MyJobsView> createState() => _MyJobsViewState();
}

class _MyJobsViewState extends State<MyJobsView> {


  List<JobCardController> jobCardControllers = [];
  String selectedFilter = "All"; // Default filter

  List<JobCardController> get filteredJobs {
    if (selectedFilter == "All") return jobCardControllers;
    return jobCardControllers
        .where((job) => job.statusLabel.value == selectedFilter)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    jobCardControllers = DummyJobCardData.getDummyData();
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
              _appBar(context),
              SizedBox(height: AppSpacing.fifteenVertical,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 10.0,
                  children: [
                    _buildFilterChip("All"),
                    _buildFilterChip("Active"),
                    _buildFilterChip("Pending"),
                    _buildFilterChip("Completed"),
                    _buildFilterChip("Cancelled"),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.tenVertical,),
              Flexible(
                child: ListView.separated(
                  itemCount: filteredJobs.length,
                  separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fifteenVertical),
                  itemBuilder: (context, index) {
                    return MyJobCard(
                      controller: filteredJobs[index],
                      onReviewSubmit: () {
                        Get.to(() => SubmitReview());
                      },
                    );
                  },
                ),
              ),
              // Flexible(
              //   child: ListView.separated(
              //     itemCount: 1,
              //     separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
              //     itemBuilder: (context, index) {
              //       return MyJobCard(controller: jobCardController);
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // BUILD FILTER CHIPS
  Widget _buildFilterChip(String label) {
    return FilterChip(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
              color: AppColors.kSkyBlue
          )
      ),
      label: Text(label,),
      selected: selectedFilter == label,
      onSelected: (bool selected) {
        setState(() {
          selectedFilter = label;
        });
      },
      backgroundColor: AppColors.kDarkBlue, // Unselected chips will have Dark Blue background
      selectedColor: AppColors.kSkyBlue, // Selected chip color
      disabledColor: AppColors.kDarkBlue, // Ensure disabled chips also have Dark Blue background
      showCheckmark: false, // No checkmark inside the chip
      surfaceTintColor: Colors.transparent, // Prevent unwanted overlay effects
      labelStyle: AppTypography.kBold14.copyWith(
        // color: selectedFilter == label ?
        color: Colors.white, // White text when selected, SkyBlue otherwise
      ),
    );
  }

  int selectedIndex = 0;
}

Widget _appBar(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          Builder(
            builder: (BuildContext context) {
              return Image.asset(
                AppAssets.kTacHomeScreenLogo,
                height: Get.height * 0.07,
                width: Get.width * 0.25,
                fit: BoxFit.contain,
              );
            },
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),//or 15.0
            child: SizedBox(
                height: 40.0,
                width: 40.0,
                child: Image.asset(AppAssets.kPlusSign)
            ),
          )
        ],
      ),
      SizedBox(height: AppSpacing.tenVertical,),
      SearchField(
        isBorderBlue: true,
        isIconColorBlue: true,
        icon2: AppAssets.kSearch,
        text: 'Armed Security Jobs in Perth',
      ),
    ],
  );
}

