import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/fiilters/advanced_filters.dart';
import 'package:tac/modules/fiilters/sort_overlay.dart';
import 'package:tac/modules/search/search_view.dart';

import '../../../widhets/common widgets/buttons/primary_container.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';

// class SearchField extends StatelessWidget {
//   final TextEditingController? controller;
//   final void Function(String)? onChanged;
//   final String? text;
//   final String? leadingIcon;
//   final String? icon1;
//   final String? icon2;
//   final bool isIconColorBlue;
//   final bool isEnabled;
//
//   const SearchField({
//     this.leadingIcon,
//     this.icon1,
//     this.icon2,
//     this.text,
//     this.controller,
//     this.onChanged,
//     this.isEnabled = false,
//     required this.isIconColorBlue,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => const SearchView());
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: AppSpacing.fifteenHorizontal),
//         color: Colors.transparent, // Ensure it's tappable
//         child: ListTile(
//           tileColor: Colors.grey[800], // Slightly darker grey for contrast
//           leading: leadingIcon != null
//               ? SvgPicture.asset(
//             leadingIcon!,
//             width: 22,
//             height: 22,
//             color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
//           )
//               : null,
//           title: Text(
//             text ?? 'Search',
//             style: AppTypography.kLight16.copyWith(
//               color: Colors.grey,
//             ),
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min, // Fix infinite width issue
//             children: [
//               if (icon1 != null) // Avoid errors if icon is null
//                 SvgPicture.asset(
//                   icon1!,
//                   color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
//                   height: 22,
//                   width: 22,
//                 ),
//               const SizedBox(width: 10),
//               if (icon2 != null) // Corrected: Now using icon2
//                 SvgPicture.asset(
//                   icon2!,
//                   color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
//                   height: 22,
//                   width: 22,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? text;
  final String? leadingIcon;
  final String? icon1;
  final String? icon2;
  final bool isIconColorBlue;
  final bool isBorderBlue;
  final bool isEnabled;

  const SearchField({
    this.leadingIcon,
    this.icon1,
    this.icon2,
    this.text,
    this.controller,
    this.onChanged,
    this.isEnabled = false,
    required this.isIconColorBlue,
    required this.isBorderBlue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SearchView());
      },
      child: Container(
        width: double.infinity, // Ensure full width
        color: Colors.transparent, // Ensures tap works properly
        child: SizedBox(
          height: 55, // Define height to prevent expansion
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            tileColor: AppColors.kDarkBlue, // Light grey for better visibility
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isBorderBlue ? AppColors.kSkyBlue : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            leading: leadingIcon != null
                ? Image.asset(
              AppAssets.kSearch,
              height: 22,
              width: 22,
              color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
            )
                : null,
            title: Text(
              text ?? 'Search',
              style: AppTypography.kLight14.copyWith(
                color: Colors.grey,
              ),
            ),
            trailing: icon1 != null || icon2 != null
                ? Row(
              mainAxisSize: MainAxisSize.min, // Prevent infinite width
              children: [
                if (icon1 != null)
                  GestureDetector(
                    onTap: (){

                    },
                    child: Image.asset(
                      icon1!,
                      height: 22,
                      width: 22,
                      color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
                    ),
                  ),
                if (icon1 != null && icon2 != null) const SizedBox(width: 10),
                if (icon2 != null)
                  GestureDetector(
                    onTap: (){
                      Get.to(() => const AdvancedFiltersView());
                    },
                    child: Image.asset(
                      icon2!,
                      height: 22,
                      width: 22,
                      color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
                    ),
                  )
              ],
            )
                : null,
          ),
        ),
      ),
    );
  }
}

