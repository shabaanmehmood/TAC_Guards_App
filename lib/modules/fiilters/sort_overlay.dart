// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';

// class SortController extends GetxController {
//   var selectedSortOption = "".obs;

//   void setSortOption(String option) {
//     selectedSortOption.value = option;
//   }
// }

// void showSortBottomSheet(BuildContext context) {
//   final SortController sortController = Get.find<SortController>();

//   showModalBottomSheet(
//     context: context,
//     enableDrag: true,
//     isDismissible: true,
//     useSafeArea: true,
//     backgroundColor: AppColors.kDarkBlue,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Divider(
//               color: Colors.grey,
//               thickness: 5,
//               indent: 140,
//               endIndent: 140,
//             ),
//             // Title & Done Button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Sort By",
//                   style: AppTypography.kBold18.copyWith(
//                     color: AppColors.kWhite
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => Get.back(),
//                   child: Text("Done", style: AppTypography.kBold16.copyWith(
//                     color: AppColors.kSkyBlue,
//                   )),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//             // Sorting Options
//             _buildSortOption(sortController, "Highest to Lowest Pay"),
//             _buildSortOption(sortController, "Lowest to Highest Pay"),
//             _buildSortOption(sortController, "Most Relevant"),
//             _buildSortOption(sortController, "Most Recent"),
//           ],
//         ),
//       );
//     },
//   );
// }

// Widget _buildSortOption(SortController controller, String option) {
//   return Obx(() => Column(
//     children: [
//       ListTile(
//         title: Text(option, style: TextStyle(color: Colors.white)),
//         leading: Radio(
//           value: option,
//           groupValue: controller.selectedSortOption.value,
//           onChanged: (val) {
//             controller.setSortOption(val as String);
//           },
//           activeColor: AppColors.kSkyBlue,
//         ),
//         onTap: () {
//           controller.setSortOption(option);
//         },
//       ),
//       Divider(color: AppColors.kSkyBlue), // Divider as shown in image
//     ],
//   ));
// }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'package:tac/modules/search/search_view.dart';

// class SortController extends GetxController {
//   var selectedSortOption = "Most Recent".obs; // Set default value
  
//   void setSortOption(String option) {
//     selectedSortOption.value = option;
//   }
  
//   // Method to get the sort key for SearchViewController
//   String getSortKey() {
//     switch (selectedSortOption.value) {
//       case "Highest to Lowest Pay":
//         return "Pay Rate (High to Low)";
//       case "Lowest to Highest Pay":
//         return "Pay Rate (Low to High)";
//       case "Most Recent":
//         return "Latest";
//       case "Most Relevant":
//         return "Latest"; // You can implement relevance logic later
//       default:
//         return "Latest";
//     }
//   }
// }

// void showSortBottomSheet(BuildContext context) {
//   // Get or create the SortController
//   final SortController sortController = Get.put(SortController());
  
//   showModalBottomSheet(
//     context: context,
//     enableDrag: true,
//     isDismissible: true,
//     useSafeArea: true,
//     backgroundColor: AppColors.kDarkBlue,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Handle bar
//             Container(
//               width: 50,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//             // Title & Done Button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Sort By",
//                   style: AppTypography.kBold18.copyWith(
//                     color: AppColors.kWhite
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     // Apply the sort and close
//                     _applySortAndClose(sortController);
//                   },
//                   child: Text(
//                     "Done", 
//                     style: AppTypography.kBold16.copyWith(
//                       color: AppColors.kSkyBlue,
//                     )
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//             // Sorting Options
//             _buildSortOption(sortController, "Most Recent"),
//             _buildSortOption(sortController, "Highest to Lowest Pay"),
//             _buildSortOption(sortController, "Lowest to Highest Pay"),
//             _buildSortOption(sortController, "Most Relevant"),
//             SizedBox(height: AppSpacing.tenVertical),
//           ],
//         ),
//       );
//     },
//   );
// }

// Widget _buildSortOption(SortController controller, String option) {
//   return Obx(() => Column(
//     children: [
//       ListTile(
//         contentPadding: EdgeInsets.zero,
//         title: Text(
//           option, 
//           style: AppTypography.kBold16.copyWith(color: Colors.white)
//         ),
//         leading: Radio<String>(
//           value: option,
//           groupValue: controller.selectedSortOption.value,
//           onChanged: (val) {
//             if (val != null) {
//               controller.setSortOption(val);
//             }
//           },
//           activeColor: AppColors.kSkyBlue,
//           fillColor: MaterialStateProperty.resolveWith<Color>((states) {
//             if (states.contains(MaterialState.selected)) {
//               return AppColors.kSkyBlue;
//             }
//             return Colors.grey;
//           }),
//         ),
//         onTap: () {
//           controller.setSortOption(option);
//         },
//       ),
//       if (option != "Most Relevant") // Don't show divider after last item
//         Divider(
//           color: Colors.grey.withOpacity(0.3), 
//           height: 1,
//         ),
//     ],
//   ));
// }

// // Helper function to apply sort and close
// void _applySortAndClose(SortController sortController) {
//   // Try to find SearchViewController and apply the sort
//   try {
//     if (Get.isRegistered<SearchViewController>()) {
//       final searchController = Get.find<SearchViewController>();
//       searchController.setSortBy(sortController.getSortKey());
//     }
//   } catch (e) {
//     print("SearchViewController not found: $e");
//   }
  
//   Get.back(); // Close the bottom sheet
// }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'package:tac/modules/search/search_view.dart';

// class SortController extends GetxController {
//   var selectedSortOption = "Most Recent".obs; // Set default value
  
//   void setSortOption(String option) {
//     selectedSortOption.value = option;
//   }
  
//   // Method to get the sort key for SearchViewController
//   String getSortKey() {
//     switch (selectedSortOption.value) {
//       case "Highest to Lowest Pay":
//         return "Pay Rate (High to Low)";
//       case "Lowest to Highest Pay":
//         return "Pay Rate (Low to High)";
//       case "Most Recent":
//         return "Latest";
//       case "Most Relevant":
//         return "Latest"; // You can implement relevance logic later
//       default:
//         return "Latest";
//     }
//   }
// }

// void showSortBottomSheet(BuildContext context) {
//   // Get or create the SortController
//   final SortController sortController = Get.put(SortController());
  
//   showModalBottomSheet(
//     context: context,
//     enableDrag: true,
//     isDismissible: true,
//     useSafeArea: true,
//     backgroundColor: AppColors.kDarkBlue,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Handle bar
//             Container(
//               width: 50,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//             // Title & Done Button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Sort By",
//                   style: AppTypography.kBold18.copyWith(
//                     color: AppColors.kWhite
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     // Apply the sort and close
//                     _applySortAndClose(sortController);
//                   },
//                   child: Text(
//                     "Done", 
//                     style: AppTypography.kBold16.copyWith(
//                       color: AppColors.kSkyBlue,
//                     )
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSpacing.tenVertical),
//             // Sorting Options
//             _buildSortOption(sortController, "Most Recent"),
//             _buildSortOption(sortController, "Highest to Lowest Pay"),
//             _buildSortOption(sortController, "Lowest to Highest Pay"),
//             _buildSortOption(sortController, "Most Relevant"),
//             SizedBox(height: AppSpacing.tenVertical),
//           ],
//         ),
//       );
//     },
//   );
// }

// Widget _buildSortOption(SortController controller, String option) {
//   return Obx(() => Column(
//     children: [
//       ListTile(
//         contentPadding: EdgeInsets.zero,
//         title: Text(
//           option, 
//           style: AppTypography.kBold16.copyWith(color: Colors.white)
//         ),
//         leading: Radio<String>(
//           value: option,
//           groupValue: controller.selectedSortOption.value,
//           onChanged: (val) {
//             if (val != null) {
//               controller.setSortOption(val);
//             }
//           },
//           activeColor: AppColors.kSkyBlue,
//           fillColor: MaterialStateProperty.resolveWith<Color>((states) {
//             if (states.contains(MaterialState.selected)) {
//               return AppColors.kSkyBlue;
//             }
//             return Colors.grey;
//           }),
//         ),
//         onTap: () {
//           controller.setSortOption(option);
//         },
//       ),
//       if (option != "Most Relevant") // Don't show divider after last item
//         Divider(
//           color: Colors.grey.withOpacity(0.3), 
//           height: 1,
//         ),
//     ],
//   ));
// }

// // Helper function to apply sort and close - Fixed to ensure proper update
// void _applySortAndClose(SortController sortController) {
//   // Try to find SearchViewController and apply the sort
//   try {
//     if (Get.isRegistered<SearchViewController>()) {
//       final searchController = Get.find<SearchViewController>();
//       String sortKey = sortController.getSortKey();
//       print("Applying sort: ${sortController.selectedSortOption.value} -> $sortKey"); // Debug print
      
//       searchController.setSortBy(sortKey);
      
//       // Force UI refresh
//       searchController.update();
      
//       print("Sort applied successfully"); // Debug print
//     } else {
//       print("SearchViewController not registered"); // Debug print
//     }
//   } catch (e) {
//     print("Error applying sort: $e");
//   }
  
//   Get.back(); // Close the bottom sheet
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/search/search_view.dart';

class SortController extends GetxController {
  var selectedSortOption = "Most Recent".obs; // Set default value
  
  void setSortOption(String option) {
    selectedSortOption.value = option;
  }
  
  // Method to get the sort key for SearchViewController
  String getSortKey() {
    switch (selectedSortOption.value) {
      case "Highest to Lowest Pay":
        return "Pay Rate (High to Low)";
      case "Lowest to Highest Pay":
        return "Pay Rate (Low to High)";
      case "Most Recent":
        return "Latest";
      case "Most Relevant":
        return "Most Relevant"; // Changed from "Latest" to have its own key
      default:
        return "Latest";
    }
  }
}

void showSortBottomSheet(BuildContext context) {
  // Get or create the SortController
  final SortController sortController = Get.put(SortController());
  
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
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: AppSpacing.tenVertical),
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
                  onTap: () {
                    // Apply the sort and close
                    _applySortAndClose(sortController);
                  },
                  child: Text(
                    "Done", 
                    style: AppTypography.kBold16.copyWith(
                      color: AppColors.kSkyBlue,
                    )
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.tenVertical),
            // Sorting Options
             _buildSortOption(sortController, "Highest to Lowest Pay"),
              _buildSortOption(sortController, "Lowest to Highest Pay"),
              _buildSortOption(sortController, "Most Relevant"),
             _buildSortOption(sortController, "Most Recent"),
            SizedBox(height: AppSpacing.tenVertical),
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
        contentPadding: EdgeInsets.zero,
        title: Text(
          option, 
          style: AppTypography.kBold16.copyWith(color: Colors.white)
        ),
        leading: Radio<String>(
          value: option,
          groupValue: controller.selectedSortOption.value,
          onChanged: (val) {
            if (val != null) {
              controller.setSortOption(val);
            }
          },
          activeColor: AppColors.kSkyBlue,
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.kSkyBlue;
            }
            return Colors.grey;
          }),
        ),
        onTap: () {
          controller.setSortOption(option);
        },
      ),
      if (option != "Lowest to Highest Pay") // Don't show divider after last item
        Divider(
          color: Colors.grey.withOpacity(0.3), 
          height: 1,
        ),
    ],
  ));
}

// Helper function to apply sort and close - Fixed to ensure proper update
void _applySortAndClose(SortController sortController) {
  // Try to find SearchViewController and apply the sort
  try {
    if (Get.isRegistered<SearchViewController>()) {
      final searchController = Get.find<SearchViewController>();
      String sortKey = sortController.getSortKey();
      print("Applying sort: ${sortController.selectedSortOption.value} -> $sortKey"); // Debug print
      
      searchController.setSortBy(sortKey);
      
      // Force UI refresh
      searchController.update();
      
      print("Sort applied successfully"); // Debug print
    } else {
      print("SearchViewController not registered"); // Debug print
    }
  } catch (e) {
    print("Error applying sort: $e");
  }
  
  Get.back(); // Close the bottom sheet
}