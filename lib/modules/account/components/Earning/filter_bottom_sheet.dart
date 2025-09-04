import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/data/constants/app_assets.dart';
import '../../../../data/data/constants/app_colors.dart';
import '../../../../data/data/constants/app_spacing.dart';
import '../../../../data/data/constants/app_typography.dart';
import 'earnings_controller.dart';

class EarningsFilterOverlay extends StatefulWidget {
  const EarningsFilterOverlay({super.key});

  @override
  State<EarningsFilterOverlay> createState() => _EarningsFilterOverlayState();
}

class _EarningsFilterOverlayState extends State<EarningsFilterOverlay> {
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final Rxn<String> selectedClient = Rxn<String>();
  final List<String> clients = ['Client A', 'Client B', 'Client C', 'Client D'];

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.kPrimary,
              surface: AppColors.kDarkestBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate.value = picked;
        } else {
          endDate.value = picked;
        }
      });
    }
  }

  Widget _buildUnderlinedField({required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        SizedBox(height: 4),
        Container(
          height: 1.5,
          color: AppColors.kSkyBlue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.twentyHorizontal),
      decoration: BoxDecoration(
        color: AppColors.kDarkestBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 40,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Custom Filter",
                  style: AppTypography.kBold18.copyWith(color: Colors.white)),
            ],
          ),
          SizedBox(height: AppSpacing.twentyVertical),

          /// Client Dropdown (underlined)
          Obx(
            () => _buildUnderlinedField(
              child: Row(
                children: [
                  Image.asset(AppAssets.kPer,
                      width: 20, color: AppColors.kinput),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedClient.value,
                        dropdownColor: AppColors.kDarkestBlue,
                        hint: Text("Select Client",
                            style: AppTypography.kLight14
                                .copyWith(color: AppColors.kinput)),
                        items: clients
                            .map((client) => DropdownMenuItem<String>(
                                  value: client,
                                  child: Text(client,
                                      style: AppTypography.kLight14
                                          .copyWith(color: AppColors.kinput)),
                                ))
                            .toList(),
                        onChanged: (value) => selectedClient.value = value,
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: AppColors.kinput),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.twentyVertical),

          /// From and To Dates
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDate(isStart: true),
                  child: Obx(() => _buildUnderlinedField(
                        child: Row(
                          children: [
                            Image.asset(AppAssets.kCal,
                                width: 20, color: AppColors.kinput),
                            SizedBox(width: 10),
                            Text(
                              startDate.value != null
                                  ? "${startDate.value!.toLocal()}"
                                      .split(' ')[0]
                                  : "From",
                              style: AppTypography.kLight14
                                  .copyWith(color: AppColors.kinput),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              SizedBox(width: AppSpacing.twelveHorizontal),
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDate(isStart: false),
                  child: Obx(() => _buildUnderlinedField(
                        child: Row(
                          children: [
                            Image.asset(AppAssets.kCal,
                                width: 20, color: AppColors.kinput),
                            SizedBox(width: 10),
                            Text(
                              endDate.value != null
                                  ? "${endDate.value!.toLocal()}".split(' ')[0]
                                  : "To",
                              style: AppTypography.kLight14
                                  .copyWith(color: AppColors.kinput),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.twentyVertical),

          /// Buttons
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kDarkestBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: AppColors.kWhite, // Your white color constant
                        width: 0.5, // Adjust the thickness as needed
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Get.back(),
                  child: Text("Cancel",
                      style:
                          AppTypography.kBold16.copyWith(color: Colors.white)),
                ),
              ),
              SizedBox(width: AppSpacing.twelveHorizontal),
              Expanded(
                flex: 7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kSkyBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (startDate.value != null && endDate.value != null) {
                      // You can add filter logic here
                      final controller = Get.find<EarningsController>();
                      controller.applyCustomFilter(
                        client: selectedClient.value,
                        from: startDate.value,
                        to: endDate.value,
                      );
                      Get.back();
                    }
                  },
                  child: Text("Apply Filter",
                      style:
                          AppTypography.kBold16.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
