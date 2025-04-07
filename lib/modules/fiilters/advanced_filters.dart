import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/widhets/common%20widgets/buttons/TextFormFieldWidget.dart';

import '../../data/data/constants/app_assets.dart';
import '../../data/data/constants/app_spacing.dart';
import '../../data/data/constants/app_typography.dart';
import '../home/components/search_field.dart';

class AdvancedFiltersView extends StatefulWidget {
  const AdvancedFiltersView({super.key});

  @override
  State<AdvancedFiltersView> createState() => _AdvancedFiltersViewState();
}

class _AdvancedFiltersViewState extends State<AdvancedFiltersView> {
  double _payRate = 60;
  String selectedJobType = "Full Time";
  String selectedShift = "Morning";
  String selectedLevel = "5";
  String selectedExperience = "10+";
  String selectedLicense = "Armed";
  String selectedPremises = "Event Security";
  bool useCurrentLocation = true;
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String selectedFilter = "All"; // Default filter


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(context),
              SizedBox(height: AppSpacing.tenVertical,),
              CustomTextField(
                keyboardType: TextInputType.streetAddress,
                hintText: 'Enter Job Location',
                iconPath: AppAssets.kLocation,
                controller: locationController,
              ),
              SizedBox(height: AppSpacing.tenVertical,),
              CustomTextField(
                keyboardType: TextInputType.streetAddress,
                hintText: 'Enter Availability',
                iconPath: AppAssets.kCalender,
                controller: locationController,
              ),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildToggleSwitch('Use Current Location'),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSlider("Pay rate", "\$${_payRate.toInt()}/hr"),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Job Type", ["Full Time", "One Time", "Part Time"], selectedJobType, (val) {
                setState(() => selectedJobType = val);
              }),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Shift Timing", ["Morning", "Afternoon", "Evening", "Night",], selectedJobType, (val) {
                setState(() => selectedJobType = val);
              }),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Required Level", ["5", "4", "3", "2", "1"], selectedJobType, (val) {
                setState(() => selectedJobType = val);
              }),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Years of Experience", ["10+", "5+", "4-5", "2-4", "1-2", "0-1"], selectedJobType, (val) {
                setState(() => selectedJobType = val);
              }),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Licenses", ["Armed", "Construction Site", "Mining Site", "Asset Protection", "First Aid", "Driving License"], selectedJobType, (val) {
                setState(() => selectedJobType = val);
              }),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Premises / Site type", ["Event Security", "Corporate Office", "Mall Security"], selectedJobType, (val) {
                setState(() => selectedJobType = val);
              }),

            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: (){
                Get.back(
                    canPop: true
                );
              },
              label: Text('Search', style: AppTypography.kBold18.copyWith(
                  color: AppColors.kWhite
              ),),
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey,),
            ),
          ],
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildToggleSwitch(String title) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15 ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(31, 41, 55, 1)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.kBold16.copyWith(
            color: AppColors.kWhite
          )),
          Switch(
            thumbColor: WidgetStatePropertyAll(Colors.black),
            value: useCurrentLocation,
            onChanged: (value) => setState(() => useCurrentLocation = value),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.kBold16.copyWith(
          color: AppColors.kWhite
        )),
        SizedBox(height: AppSpacing.fiveVertical,),
        Container(
          padding: EdgeInsets.only(top: 8,right: 8, left: 8),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text("\$20/hr", style: AppTypography.kBold16.copyWith(
                    color: AppColors.kWhite
                  )),
                  Spacer(),
                  Text("\$60/hr", style: AppTypography.kBold16.copyWith(
                    color: AppColors.kWhite
                  )),
                  Spacer(),
                  Text("\$100/hr", style: AppTypography.kBold16.copyWith(
                    color: AppColors.kWhite
                  )),
                ],
              ),
              Slider(
                value: _payRate,
                min: 20,
                max: 100,
                divisions: 2,
                onChanged: (value) => setState(() => _payRate = value),
                activeColor: AppColors.kSkyBlue,
                inactiveColor: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableChips(String title, List<String> options, String selectedValue, Function(String) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.kBold16.copyWith(
          color: AppColors.kWhite
        )),
        const SizedBox(height: 5),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            return _buildFilterChip(option, option == selectedValue, () {
              setState(() => onSelected(option));
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onSelected) {
    return FilterChip(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.kSkyBlue)),
      label: Text('$label Jobs'),
      backgroundColor: isSelected ? AppColors.kSkyBlue : AppColors.kDarkBlue,
      selectedColor: AppColors.kSkyBlue,
      disabledColor: AppColors.kDarkBlue,
      showCheckmark: false,
      surfaceTintColor: Colors.transparent,
      labelStyle: AppTypography.kBold14.copyWith(
        color: isSelected ? AppColors.kBlack : AppColors.kWhite,
      ),
      selected: isSelected, // Important for state management
      onSelected: (_) => onSelected(), // Fix for selection
    );
  }
}
