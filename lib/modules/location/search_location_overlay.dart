import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/Guards/guards_view.dart';
import 'package:tac/widhets/buttons/buttons/buttons.dart';
import 'package:tac/widhets/common%20widgets/buttons/TextFormFieldWidget.dart';

import '../home/components/search_field.dart';

class SearchLocationOverlayController extends GetxController {
  var useSearchLocation = true.obs;
  void toggleUseSearchLocation() {
    useSearchLocation.value = !useSearchLocation.value;
    update();
  }

  TextEditingController addressController = TextEditingController();
  TextEditingController jobRadiusController = TextEditingController();
}

void showSearchLocationBottomSheet(BuildContext context) {
  SearchLocationOverlayController controller = Get.put(SearchLocationOverlayController());
  final GuardsViewController guardsController=  Get.put(GuardsViewController());

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
          children: [
            Divider(
              color: Colors.grey,
              thickness: 5,
              indent: 100,
              endIndent: 100,
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            SearchField(
              isEnabled: true,
              isBorderBlue: true,
              isIconColorBlue: true,
              text: 'Search Location..',
              leadingIcon: AppAssets.kSearch,
              guardsController: guardsController, // Pass the found controller
   
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                style: ListTileStyle.list,
                leading: Icon(Icons.location_on_outlined, color: AppColors.kSkyBlue),
                title: Text(
                  "Falcons Solutions Pvt. Ltd.",
                  style: AppTypography.kBold16.copyWith(
                    color: AppColors.kWhite
                  ),
                ),
                subtitle: Text(
                  "Perth, Australia",
                  style: AppTypography.kLight14.copyWith(
                    color: Colors.grey
                  ),
                ),
            )
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.kJobCardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  style: ListTileStyle.list,
                  leading: Icon(Icons.location_on_outlined, color: AppColors.kSkyBlue),
                  title: Text(
                    "Falcons Solutions Pvt. Ltd.",
                    style: AppTypography.kBold16.copyWith(
                        color: AppColors.kWhite
                    ),
                  ),
                  subtitle: Text(
                    "Perth, Australia",
                    style: AppTypography.kLight14.copyWith(
                        color: Colors.grey
                    ),
                  ),
                )
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.kJobCardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  style: ListTileStyle.list,
                  leading: Icon(Icons.location_on_outlined, color: AppColors.kSkyBlue),
                  title: Text(
                    "Falcons Solutions Pvt. Ltd.",
                    style: AppTypography.kBold16.copyWith(
                        color: AppColors.kWhite
                    ),
                  ),
                  subtitle: Text(
                    "Perth, Australia",
                    style: AppTypography.kLight14.copyWith(
                        color: Colors.grey
                    ),
                  ),
                )
            ),

          ],
        ),
      );
    },
  );
}

