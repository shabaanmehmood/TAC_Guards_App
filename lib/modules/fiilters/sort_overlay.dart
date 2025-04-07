import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';

class SortController extends GetxController {
  var selectedSortOption = "".obs;

  void setSortOption(String option) {
    selectedSortOption.value = option;
  }
}

void showSortBottomSheet(BuildContext context) {
  final SortController sortController = Get.find<SortController>();

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: true,
    useSafeArea: true,
    backgroundColor: AppColors.kDarkBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: Colors.grey,
              thickness: 5,
              indent: 140,
              endIndent: 140,
            ),
            // Title & Done Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sort By",
                  style: AppTypography.kBold18.copyWith(
                    color: AppColors.kWhite
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text("Done", style: AppTypography.kBold16.copyWith(
                    color: AppColors.kSkyBlue,
                  )),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.tenVertical),
            // Sorting Options
            _buildSortOption(sortController, "Highest to Lowest Pay"),
            _buildSortOption(sortController, "Lowest to Highest Pay"),
            _buildSortOption(sortController, "Most Relevant"),
            _buildSortOption(sortController, "Most Recent"),
          ],
        ),
      );
    },
  );
}

Widget _buildSortOption(SortController controller, String option) {
  return Obx(() => Column(
    children: [
      ListTile(
        title: Text(option, style: TextStyle(color: Colors.white)),
        leading: Radio(
          value: option,
          groupValue: controller.selectedSortOption.value,
          onChanged: (val) {
            controller.setSortOption(val as String);
          },
          activeColor: AppColors.kSkyBlue,
        ),
        onTap: () {
          controller.setSortOption(option);
        },
      ),
      Divider(color: AppColors.kSkyBlue), // Divider as shown in image
    ],
  ));
}
