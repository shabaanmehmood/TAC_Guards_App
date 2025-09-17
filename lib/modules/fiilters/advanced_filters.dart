// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:get/get_core/src/get_main.dart';
// // import 'package:tac/data/data/constants/app_colors.dart';
// // import 'package:tac/widhets/common%20widgets/buttons/TextFormFieldWidget.dart';

// // import '../../data/data/constants/app_assets.dart';
// // import '../../data/data/constants/app_spacing.dart';
// // import '../../data/data/constants/app_typography.dart';
// // import '../home/components/search_field.dart';

// // class AdvancedFiltersView extends StatefulWidget {
// //   const AdvancedFiltersView({super.key});

// //   @override
// //   State<AdvancedFiltersView> createState() => _AdvancedFiltersViewState();
// // }

// // class _AdvancedFiltersViewState extends State<AdvancedFiltersView> {
// //   double _payRate = 60;
// //   String selectedJobType = "Full Time";
// //   String selectedShift = "Morning";
// //   String selectedLevel = "5";
// //   String selectedExperience = "10+";
// //   String selectedLicense = "Armed";
// //   String selectedPremises = "Event Security";
// //   bool useCurrentLocation = true;
// //   TextEditingController locationController = TextEditingController();
// //   TextEditingController dateController = TextEditingController();
// //   String selectedFilter = "All"; // Default filter
// //   final Set<String> selectedFilters = <String>{};



// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.kDarkBlue,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _appBar(context),
// //               SizedBox(height: AppSpacing.tenVertical,),
// //               CustomTextField(
// //                 keyboardType: TextInputType.streetAddress,
// //                 hintText: 'Enter Job Location',
// //                 iconPath: AppAssets.kLocation,
// //                 controller: locationController,
// //               ),
// //               SizedBox(height: AppSpacing.tenVertical,),
// //               CustomTextField(
// //                 keyboardType: TextInputType.streetAddress,
// //                 hintText: 'Enter Availability',
// //                 iconPath: AppAssets.kCalender,
// //                 controller: locationController,
// //               ),
// //               SizedBox(height: AppSpacing.fifteenVertical,),
// //               _buildToggleSwitch('Use Current Location'),
// //               SizedBox(height: AppSpacing.fifteenVertical,),
// //               _buildSlider("Pay rate", "\$${_payRate.toInt()}/hr"),
// //               SizedBox(height: AppSpacing.fifteenVertical,),
// //               _buildSelectableChips("Job Type", ["Full Time", "One Time", "Part Time"], selectedJobType, (val) {
// //                 setState(() => selectedJobType = val);
// //               }),
// //               SizedBox(height: AppSpacing.fifteenVertical,),
// //               _buildSelectableChips("Shift Timing", ["Morning", "Afternoon", "Evening", "Night",], selectedJobType, (val) {
// //                 setState(() => selectedJobType = val);
// //               }),
// //               SizedBox(height: AppSpacing.fifteenVertical,),
// //               _buildSelectableChips("Required Level", ["5", "4", "3", "2", "1"], selectedJobType, (val) {
// //                 setState(() => selectedJobType = val);
// //               }),
// //               SizedBox(height: AppSpacing.fifteenVertical,),
// //               _buildSelectableChips("Years of Experience", ["10+", "5+", "4-5", "2-4", "1-2", "0-1"], selectedJobType, (val) {
// //                 setState(() => selectedJobType = val);
// //               }),
// //               SizedBox(height: AppSpacing.fifteenVertical,),
// //               _buildSelectableChips("Licenses", ["Armed", "Construction Site", "Mining Site", "Asset Protection", "First Aid", "Driving License"], selectedJobType, (val) {
// //                 setState(() => selectedJobType = val);
// //               }),
// //               SizedBox(height: AppSpacing.fifteenVertical,),
// //               _buildSelectableChips("Premises / Site type", ["Event Security", "Corporate Office", "Mall Security"], selectedJobType, (val) {
// //                 setState(() => selectedJobType = val);
// //               }),
// //               SizedBox(height: AppSpacing.fifteenVertical,),
// //               ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: AppColors.kSkyBlue,
// //                   minimumSize: Size(double.infinity, 50),
// //                 ),
// //                 onPressed: () {
// //                   Get.back(result: selectedFilters.toList());
// //                 },
// //                 child: Text(
// //                   'Apply Filters',
// //                   style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
// //                 ),
// //               ),

// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _appBar(BuildContext context) {
// //     return Column(
// //       children: [
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.start,
// //           children: [
// //             TextButton.icon(
// //               onPressed: (){
// //                 Get.back(
// //                     canPop: true
// //                 );
// //               },
// //               label: Text('Search', style: AppTypography.kBold18.copyWith(
// //                   color: AppColors.kWhite
// //               ),),
// //               icon: Icon(Icons.arrow_back_ios, color: Colors.grey,),
// //             ),
// //           ],
// //         ),
// //         Divider(
// //           color: Colors.grey,
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildToggleSwitch(String title) {
// //     return Container(
// //       padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15 ),
// //       decoration: BoxDecoration(
// //         color: Color.fromRGBO(31, 41, 55, 1)
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(title, style: AppTypography.kBold16.copyWith(
// //             color: AppColors.kWhite
// //           )),
// //           Switch(
// //             thumbColor: WidgetStatePropertyAll(Colors.black),
// //             value: useCurrentLocation,
// //             onChanged: (value) => setState(() => useCurrentLocation = value),
// //             activeColor: Colors.green,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSlider(String title, String value) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(title, style: AppTypography.kBold16.copyWith(
// //           color: AppColors.kWhite
// //         )),
// //         SizedBox(height: AppSpacing.fiveVertical,),
// //         Container(
// //           padding: EdgeInsets.only(top: 8,right: 8, left: 8),
// //           decoration: BoxDecoration(
// //             shape: BoxShape.rectangle,
// //             border: Border.all(color: Colors.grey),
// //             borderRadius: BorderRadius.circular(8)
// //           ),
// //           child: Column(
// //             children: [
// //               Row(
// //                 children: [
// //                   Text("\$20/hr", style: AppTypography.kBold16.copyWith(
// //                     color: AppColors.kWhite
// //                   )),
// //                   Spacer(),
// //                   Text("\$60/hr", style: AppTypography.kBold16.copyWith(
// //                     color: AppColors.kWhite
// //                   )),
// //                   Spacer(),
// //                   Text("\$100/hr", style: AppTypography.kBold16.copyWith(
// //                     color: AppColors.kWhite
// //                   )),
// //                 ],
// //               ),
// //               Slider(
// //                 value: _payRate,
// //                 min: 20,
// //                 max: 100,
// //                 divisions: 2,
// //                 onChanged: (value) => setState(() => _payRate = value),
// //                 activeColor: AppColors.kSkyBlue,
// //                 inactiveColor: Colors.grey,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildSelectableChips(String title, List<String> options, String selectedValue, Function(String) onSelected) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(title, style: AppTypography.kBold16.copyWith(
// //           color: AppColors.kWhite
// //         )),
// //         const SizedBox(height: 5),
// //         Wrap(
// //           spacing: 8,
// //           children: options.map((option) {
// //             return _buildFilterChip(option, option == selectedValue, () {
// //               setState(() => onSelected(option));
// //             });
// //           }).toList(),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildFilterChip(String label, bool isSelected, VoidCallback onSelected) {
// //     return FilterChip(
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(8),
// //         side: BorderSide(color: AppColors.kSkyBlue),
// //       ),
// //       label: Text(label),
// //       selected: selectedFilters.contains(label),
// //       onSelected: (bool selected) {
// //         setState(() {
// //           if (selected) {
// //             selectedFilters.add(label);
// //           } else {
// //             selectedFilters.remove(label);
// //           }
// //         });
// //       },
// //       backgroundColor: AppColors.kDarkBlue,
// //       selectedColor: AppColors.kSkyBlue,
// //       labelStyle: AppTypography.kBold14.copyWith(
// //         color: selectedFilters.contains(label) ? Colors.white : AppColors.kSkyBlue,
// //       ),
// //     );
// //   }}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/widhets/common%20widgets/buttons/TextFormFieldWidget.dart';

// import '../../data/data/constants/app_assets.dart';
// import '../../data/data/constants/app_spacing.dart';
// import '../../data/data/constants/app_typography.dart';
// import '../home/components/search_field.dart';
// import '../search/search_view.dart';

// class AdvancedFiltersView extends StatefulWidget {
//   const AdvancedFiltersView({super.key});

//   @override
//   State<AdvancedFiltersView> createState() => _AdvancedFiltersViewState();
// }

// class _AdvancedFiltersViewState extends State<AdvancedFiltersView> {
//   double _payRate = 60;
//   String selectedJobType = "";
//   String selectedShift = "";
//   String selectedLevel = "";
//   String selectedExperience = "";
//   final Set<String> selectedLicenses = <String>{};
//   final Set<String> selectedPremises = <String>{};
//   bool useCurrentLocation = true;
//   TextEditingController locationController = TextEditingController();
//   TextEditingController dateController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize with existing filters if coming from search view
//     if (Get.isRegistered<SearchViewController>()) {
//       final searchController = Get.find<SearchViewController>();
//       _payRate = searchController.payRateMax.value;
//       selectedJobType = searchController.jobType.value;
//       selectedShift = searchController.shiftTiming.value;
//       selectedLevel = searchController.requiredLevel.value;
//       selectedExperience = searchController.experience.value;
//       selectedLicenses.addAll(searchController.licenses);
//       selectedPremises.addAll(searchController.premises);
//       locationController.text = searchController.location.value;
//       useCurrentLocation = searchController.useCurrentLocation.value;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _appBar(context),
//               SizedBox(height: AppSpacing.tenVertical,),
//               CustomTextField(
//                 keyboardType: TextInputType.streetAddress,
//                 hintText: 'Enter Job Location',
//                 iconPath: AppAssets.kLocation,
//                 controller: locationController,
//               ),
//               SizedBox(height: AppSpacing.tenVertical,),
//               CustomTextField(
//                 keyboardType: TextInputType.streetAddress,
//                 hintText: 'Enter Availability',
//                 iconPath: AppAssets.kCalender,
//                 controller: dateController,
//               ),
//               SizedBox(height: AppSpacing.fifteenVertical,),
//               _buildToggleSwitch('Use Current Location'),
//               SizedBox(height: AppSpacing.fifteenVertical,),
//               _buildSlider("Pay rate", "\$${_payRate.toInt()}/hr"),
//               SizedBox(height: AppSpacing.fifteenVertical,),
//               _buildSelectableChips("Job Type", ["Full Time", "One Time", "Part Time"], selectedJobType, (val) {
//                 setState(() => selectedJobType = val);
//               }, isSingleSelect: true),
//               SizedBox(height: AppSpacing.fifteenVertical,),
//               _buildSelectableChips("Shift Timing", ["Morning", "Afternoon", "Evening", "Night"], selectedShift, (val) {
//                 setState(() => selectedShift = val);
//               }, isSingleSelect: true),
//               SizedBox(height: AppSpacing.fifteenVertical,),
//               _buildSelectableChips("Required Level", ["5", "4", "3", "2", "1"], selectedLevel, (val) {
//                 setState(() => selectedLevel = val);
//               }, isSingleSelect: true),
//               SizedBox(height: AppSpacing.fifteenVertical,),
//               _buildSelectableChips("Years of Experience", ["10+", "5+", "4-5", "2-4", "1-2", "0-1"], selectedExperience, (val) {
//                 setState(() => selectedExperience = val);
//               }, isSingleSelect: true),
//               SizedBox(height: AppSpacing.fifteenVertical,),
//               _buildMultiSelectChips("Licenses", ["Armed", "Construction Site", "Mining Site", "Asset Protection", "First Aid", "Driving License"], selectedLicenses),
//               SizedBox(height: AppSpacing.fifteenVertical,),
//               _buildMultiSelectChips("Premises / Site type", ["Event Security", "Corporate Office", "Mall Security"], selectedPremises),
//               SizedBox(height: AppSpacing.fifteenVertical,),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         side: BorderSide(color: AppColors.kSkyBlue),
//                         minimumSize: Size(double.infinity, 50),
//                       ),
//                       onPressed: () {
//                         _clearAllFilters();
//                       },
//                       child: Text(
//                         'Clear All',
//                         style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.kSkyBlue,
//                         minimumSize: Size(double.infinity, 50),
//                       ),
//                       onPressed: () {
//                         _applyFilters();
//                       },
//                       child: Text(
//                         'Apply Filters',
//                         style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSpacing.twentyVertical),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _appBar(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             TextButton.icon(
//               onPressed: (){
//                 Get.back(canPop: true);
//               },
//               label: Text('Advanced Filters', style: AppTypography.kBold18.copyWith(
//                   color: AppColors.kWhite
//               ),),
//               icon: Icon(Icons.arrow_back_ios, color: Colors.grey,),
//             ),
//           ],
//         ),
//         Divider(
//           color: Colors.grey,
//         ),
//       ],
//     );
//   }

//   Widget _buildToggleSwitch(String title) {
//     return Container(
//       padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
//       decoration: BoxDecoration(
//         color: Color.fromRGBO(31, 41, 55, 1)
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: AppTypography.kBold16.copyWith(
//             color: AppColors.kWhite
//           )),
//           Switch(
//             thumbColor: WidgetStatePropertyAll(Colors.black),
//             value: useCurrentLocation,
//             onChanged: (value) => setState(() => useCurrentLocation = value),
//             activeColor: Colors.green,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSlider(String title, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: AppTypography.kBold16.copyWith(
//           color: AppColors.kWhite
//         )),
//         SizedBox(height: AppSpacing.fiveVertical,),
//         Container(
//           padding: EdgeInsets.only(top: 8, right: 8, left: 8),
//           decoration: BoxDecoration(
//             shape: BoxShape.rectangle,
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(8)
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text("\$20/hr", style: AppTypography.kBold16.copyWith(
//                     color: AppColors.kWhite
//                   )),
//                   Spacer(),
//                   Text("\$60/hr", style: AppTypography.kBold16.copyWith(
//                     color: AppColors.kWhite
//                   )),
//                   Spacer(),
//                   Text("\$100/hr", style: AppTypography.kBold16.copyWith(
//                     color: AppColors.kWhite
//                   )),
//                 ],
//               ),
//               Slider(
//                 value: _payRate,
//                 min: 20,
//                 max: 100,
//                 divisions: 80,
//                 onChanged: (value) => setState(() => _payRate = value),
//                 activeColor: AppColors.kSkyBlue,
//                 inactiveColor: Colors.grey,
//               ),
//               Text(
//                 "\$${_payRate.toInt()}/hr",
//                 style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSelectableChips(String title, List<String> options, String selectedValue, Function(String) onSelected, {bool isSingleSelect = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: AppTypography.kBold16.copyWith(
//           color: AppColors.kWhite
//         )),
//         const SizedBox(height: 5),
//         Wrap(
//           spacing: 8,
//           children: options.map((option) {
//             bool isSelected = selectedValue == option;
//             return _buildFilterChip(option, isSelected, () {
//               onSelected(option);
//             });
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildMultiSelectChips(String title, List<String> options, Set<String> selectedSet) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: AppTypography.kBold16.copyWith(
//           color: AppColors.kWhite
//         )),
//         const SizedBox(height: 5),
//         Wrap(
//           spacing: 8,
//           children: options.map((option) {
//             bool isSelected = selectedSet.contains(option);
//             return _buildFilterChip(option, isSelected, () {
//               setState(() {
//                 if (isSelected) {
//                   selectedSet.remove(option);
//                 } else {
//                   selectedSet.add(option);
//                 }
//               });
//             });
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterChip(String label, bool isSelected, VoidCallback onSelected) {
//     return FilterChip(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(color: AppColors.kSkyBlue),
//       ),
//       label: Text(label),
//       selected: isSelected,
//       onSelected: (bool selected) => onSelected(),
//       backgroundColor: AppColors.kDarkBlue,
//       selectedColor: AppColors.kSkyBlue,
//       labelStyle: AppTypography.kBold14.copyWith(
//         color: isSelected ? Colors.white : AppColors.kSkyBlue,
//       ),
//     );
//   }

//   void _clearAllFilters() {
//     setState(() {
//       _payRate = 60;
//       selectedJobType = "";
//       selectedShift = "";
//       selectedLevel = "";
//       selectedExperience = "";
//       selectedLicenses.clear();
//       selectedPremises.clear();
//       useCurrentLocation = true;
//       locationController.clear();
//       dateController.clear();
//     });
//   }

//   void _applyFilters() {
//     // Create filter data to pass back
//     Map<String, dynamic> filterData = {
//       'payRateMin': 20.0,
//       'payRateMax': _payRate,
//       'jobType': selectedJobType,
//       'shiftTiming': selectedShift,
//       'requiredLevel': selectedLevel,
//       'experience': selectedExperience,
//       'licenses': selectedLicenses.toList(),
//       'premises': selectedPremises.toList(),
//       'location': locationController.text,
//       'useCurrentLocation': useCurrentLocation,
//       'availability': dateController.text,
//     };

//     // Apply filters to search controller if it exists
//     if (Get.isRegistered<SearchViewController>()) {
//       final searchController = Get.find<SearchViewController>();
//       searchController.applyAdvancedFilters(filterData);
//     }

//     // Return to previous screen
//     Get.back(result: _getSelectedFilterLabels());
//   }

//   List<String> _getSelectedFilterLabels() {
//     List<String> labels = [];
    
//     if (_payRate != 60) labels.add('\$${_payRate.toInt()}/hr max');
//     if (selectedJobType.isNotEmpty) labels.add(selectedJobType);
//     if (selectedShift.isNotEmpty) labels.add(selectedShift);
//     if (selectedLevel.isNotEmpty) labels.add('Level $selectedLevel');
//     if (selectedExperience.isNotEmpty) labels.add('$selectedExperience years');
//     labels.addAll(selectedLicenses);
//     labels.addAll(selectedPremises);
//     if (locationController.text.isNotEmpty && !useCurrentLocation) {
//       labels.add(locationController.text);
//     }
    
//     return labels;
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/widhets/common%20widgets/buttons/TextFormFieldWidget.dart';

import '../../data/data/constants/app_assets.dart';
import '../../data/data/constants/app_spacing.dart';
import '../../data/data/constants/app_typography.dart';
import '../home/components/search_field.dart';
import '../search/search_view.dart';

class AdvancedFiltersView extends StatefulWidget {
  const AdvancedFiltersView({super.key});

  @override
  State<AdvancedFiltersView> createState() => _AdvancedFiltersViewState();
}

class _AdvancedFiltersViewState extends State<AdvancedFiltersView> {
  double _payRateMin = 0.0;
  double _payRateMax = 2000.0;
  bool _usePayRateFilter = false; // Toggle for pay rate filter
  String selectedJobType = "";
  String selectedShift = "";
  String selectedLevel = "";
  String selectedExperience = "";
  final Set<String> selectedLicenses = <String>{};
  final Set<String> selectedPremises = <String>{};
  bool useCurrentLocation = true;
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with existing filters if coming from search view
    if (Get.isRegistered<SearchViewController>()) {
      final searchController = Get.find<SearchViewController>();
      _payRateMin = searchController.payRateMin.value;
      _payRateMax = searchController.payRateMax.value;
      _usePayRateFilter = searchController.usePayRateFilter.value;
      selectedJobType = searchController.jobType.value;
      selectedShift = searchController.shiftTiming.value;
      selectedLevel = searchController.requiredLevel.value;
      selectedExperience = searchController.experience.value;
      selectedLicenses.addAll(searchController.licenses);
      selectedPremises.addAll(searchController.premises);
      locationController.text = searchController.location.value;
      useCurrentLocation = searchController.useCurrentLocation.value;
    }
  }

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
                controller: dateController,
              ),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildToggleSwitch('Use Current Location'),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildPayRateToggle(),
              if (_usePayRateFilter) ...[
                SizedBox(height: AppSpacing.tenVertical,),
                _buildPayRateSlider(),
              ],
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Job Type", ["Full Time", "One Time", "Part Time"], selectedJobType, (val) {
                setState(() => selectedJobType = val);
              }, isSingleSelect: true),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Shift Timing", ["Morning", "Afternoon", "Evening", "Night"], selectedShift, (val) {
                setState(() => selectedShift = val);
              }, isSingleSelect: true),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Required Level", ["5", "4", "3", "2", "1"], selectedLevel, (val) {
                setState(() => selectedLevel = val);
              }, isSingleSelect: true),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildSelectableChips("Years of Experience", ["10+", "5+", "4-5", "2-4", "1-2", "0-1"], selectedExperience, (val) {
                setState(() => selectedExperience = val);
              }, isSingleSelect: true),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildMultiSelectChips("Licenses", ["Armed", "Construction Site", "Mining Site", "Asset Protection", "First Aid", "Driving License"], selectedLicenses),
              SizedBox(height: AppSpacing.fifteenVertical,),
              _buildMultiSelectChips("Premises / Site type", ["Event Security", "Corporate Office", "Mall Security", "OnSite", "OffSite"], selectedPremises),
              SizedBox(height: AppSpacing.fifteenVertical,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: AppColors.kSkyBlue),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        _clearAllFilters();
                      },
                      child: Text(
                        'Clear All',
                        style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        _applyFilters();
                      },
                      child: Text(
                        'Apply Filters',
                        style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.twentyVertical),
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
                Get.back(canPop: true);
              },
              label: Text('Advanced Filters', style: AppTypography.kBold18.copyWith(
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
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
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

  Widget _buildPayRateToggle() {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Color.fromRGBO(31, 41, 55, 1)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Filter by Pay Rate', style: AppTypography.kBold16.copyWith(
            color: AppColors.kWhite
          )),
          Switch(
            thumbColor: WidgetStatePropertyAll(Colors.black),
            value: _usePayRateFilter,
            onChanged: (value) => setState(() => _usePayRateFilter = value),
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPayRateSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pay Rate Range', style: AppTypography.kBold16.copyWith(
          color: AppColors.kWhite
        )),
        SizedBox(height: AppSpacing.fiveVertical,),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$0", style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                  Text("\$1000", style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                  Text("\$2000", style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                ],
              ),
              SizedBox(height: 10),
              // Min Range Slider
              Text('Min: \$${_payRateMin.toStringAsFixed(1)}/hr', 
                style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue)),
              Slider(
                value: _payRateMin,
                min: 0,
                max: 1999,
                divisions: 1999,
                onChanged: (value) => setState(() {
                  _payRateMin = value;
                  if (_payRateMin >= _payRateMax) {
                    _payRateMax = _payRateMin + 1;
                  }
                }),
                activeColor: AppColors.kSkyBlue,
                inactiveColor: Colors.grey,
              ),
              SizedBox(height: 10),
              // Max Range Slider
              Text('Max: \$${_payRateMax.toStringAsFixed(1)}/hr', 
                style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue)),
              Slider(
                value: _payRateMax,
                min: 1,
                max: 2000,
                divisions: 1999,
                onChanged: (value) => setState(() {
                  _payRateMax = value;
                  if (_payRateMax <= _payRateMin) {
                    _payRateMin = _payRateMax - 1;
                  }
                }),
                activeColor: AppColors.kSkyBlue,
                inactiveColor: Colors.grey,
              ),
              SizedBox(height: 10),
              // Range Display
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              //   decoration: BoxDecoration(
              //     color: AppColors.kSkyBlue.withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Text(
              //     'Range: \$${_payRateMin.toStringAsFixed(1)} - \$${_payRateMax.toStringAsFixed(1)} per hour',
              //     style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
              //     textAlign: TextAlign.center,
              //   ),
              // ),

               Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kSkyBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Range: \$${_payRateMin.toStringAsFixed(1)} - \$${_payRateMax.toStringAsFixed(1)}",
                  style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectableChips(String title, List<String> options, String selectedValue, Function(String) onSelected, {bool isSingleSelect = false}) {
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
            bool isSelected = selectedValue == option;
            return _buildFilterChip(option, isSelected, () {
              onSelected(option);
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMultiSelectChips(String title, List<String> options, Set<String> selectedSet) {
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
            bool isSelected = selectedSet.contains(option);
            return _buildFilterChip(option, isSelected, () {
              setState(() {
                if (isSelected) {
                  selectedSet.remove(option);
                } else {
                  selectedSet.add(option);
                }
              });
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
        side: BorderSide(color: AppColors.kSkyBlue),
      ),
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) => onSelected(),
      backgroundColor: AppColors.kDarkBlue,
      selectedColor: AppColors.kSkyBlue,
      labelStyle: AppTypography.kBold14.copyWith(
        color: isSelected ? Colors.white : AppColors.kSkyBlue,
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _payRateMin = 0.0;
      _payRateMax = 2000.0;
      _usePayRateFilter = false;
      selectedJobType = "";
      selectedShift = "";
      selectedLevel = "";
      selectedExperience = "";
      selectedLicenses.clear();
      selectedPremises.clear();
      useCurrentLocation = true;
      locationController.clear();
      dateController.clear();
    });

    // Clear filters in search controller if it exists
    if (Get.isRegistered<SearchViewController>()) {
      final searchController = Get.find<SearchViewController>();
      searchController.clearAllFilters();
    }
  }

  void _applyFilters() {
    // Create filter data to pass back
    Map<String, dynamic> filterData = {
      'payRateMin': _payRateMin,
      'payRateMax': _payRateMax,
      'usePayRateFilter': _usePayRateFilter,
      'jobType': selectedJobType,
      'shiftTiming': selectedShift,
      'requiredLevel': selectedLevel,
      'experience': selectedExperience,
      'licenses': selectedLicenses.toList(),
      'premises': selectedPremises.toList(),
      'location': locationController.text,
      'useCurrentLocation': useCurrentLocation,
      'availability': dateController.text,
    };

    // Apply filters to search controller if it exists
    if (Get.isRegistered<SearchViewController>()) {
      final searchController = Get.find<SearchViewController>();
      searchController.applyAdvancedFilters(filterData);
    }

    // Return to previous screen
    Get.back(result: _getSelectedFilterLabels());
  }

  List<String> _getSelectedFilterLabels() {
    List<String> labels = [];
    
    if (_usePayRateFilter) {
       labels.add('\$${_payRateMin.toStringAsFixed(1)} - \$${_payRateMax.toStringAsFixed(1)}');
      // labels.add('\${_payRateMin.toStringAsFixed(1)}-\${_payRateMax.toStringAsFixed(1)}');
    }
    if (selectedJobType.isNotEmpty) labels.add(selectedJobType);
    if (selectedShift.isNotEmpty) labels.add(selectedShift);
    if (selectedLevel.isNotEmpty) labels.add('Level $selectedLevel');
    if (selectedExperience.isNotEmpty) labels.add('$selectedExperience years');
    labels.addAll(selectedLicenses);
    labels.addAll(selectedPremises);
    if (locationController.text.isNotEmpty && !useCurrentLocation) {
      labels.add(locationController.text);
    }
    
    return labels;
  }
}