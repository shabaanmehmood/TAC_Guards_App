// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/modules/account/components/Earning/earnings_screen.dart';
// import 'package:tac/modules/account/components/bank%20details/bank_details_screen.dart';
// import 'package:tac/modules/account/components/logout.dart';
// import 'package:tac/modules/account/components/profile/profile_screen.dart';
// import 'package:tac/modules/account/help_support.dart';
// import 'package:tac/modules/account/components/reviews/reviews_screen.dart';
// import 'package:tac/modules/alerts/notification_view.dart';

// import '../../controllers/user_controller.dart';
// import '../../data/data/constants/app_assets.dart';
// import '../../dataproviders/api_service.dart';
// import 'components/License/security_license_screen.dart';
// import 'components/Settings/SettingsScreen.dart';

// class AccountController extends GetxController {
//   final notificationsEnabled = false.obs;
// }

// class AccountScreen extends StatelessWidget {
//   const AccountScreen({super.key});

//   void navigateToPlaceholder(String screenName) {
//     Get.to(() => Scaffold(
//           appBar: AppBar(title: Text(screenName)),
//           body: Center(child: Text('$screenName Screen Coming Soon')),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final AccountController controller = Get.put(AccountController());
//     final userController = Get.find<UserController>().obs;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: AppColors.kDarkestBlue,
//       body: Column(
//         children: [
//           // Fixed Custom App Bar
//           Container(
//             width: double.infinity,
//             padding:
//                 const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
//             decoration: const BoxDecoration(
//               color: AppColors.kDarkestBlue,
//               border: Border(
//                 bottom: BorderSide(width: 0.5, color: AppColors.kgrey),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     // Square Profile Image
//                     Obx(() {
//                       final imagePath = userController
//                           .value.userData.value?.profileImages?.first.imageUrl;
//                       final imageUrl = MyApIService.fullImageUrl(imagePath);
//                       return Container(
//                         width: 34,
//                         height: 34,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                           image: DecorationImage(
//                             image: imageUrl != null
//                                 ? NetworkImage(imageUrl)
//                                 : AssetImage(AppAssets.kUserPicture)
//                                     as ImageProvider,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       );
//                     }),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'Account',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Stack(
//                   children: [
//                     GestureDetector(
//                       onTap: (){
//                          Get.to<void>(() => NotificationScreen());
//                       },
//                       child: const Icon(Icons.notifications_none,
//                           color: Colors.white, size: 24),
//                     ),
//                     Positioned(
//                       right: 0,
//                       top: 0,
//                       child: Container(
//                         width: 8,
//                         height: 8,
//                         decoration: const BoxDecoration(
//                           color: Colors.cyanAccent,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),

//           // Scrollable content
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Profile Header
//                   Container(
//                     width: screenWidth * 0.92,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: AppColors.kDarkestBlue,
//                       border: Border.all(color: AppColors.kgrey, width: 0.5),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               userController.value.userData.value?.fullName ??
//                                   '',
//                               style: const TextStyle(
//                                   color: AppColors.kWhite,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(width: 6),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 6, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: AppColors.kSkyBlue,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 userController.value.userData.value?.professionalBadge ??
//                                     'Leader',
//                                 style: TextStyle(
//                                     color: AppColors.kWhite, fontSize: 12),
//                               ),
//                             )
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Text("Security Professional · ${userController.value.userData.value?.level}",
//                             style: TextStyle(color: AppColors.ktextlight)),
//                         const SizedBox(height: 8),
//                         GestureDetector(
//                           onTap: () => Get.to(() => const ReviewsScreen()),
//                           child: Row(
//                             children: [
//                               for (int i = 0; i < 5; i++)
//                                 const Icon(Icons.star,
//                                     size: 16, color: AppColors.kSkyBlue),
//                               const SizedBox(width: 4),
//                               const Text(
//                                 "5.0 ",
//                                 style: TextStyle(
//                                     color: AppColors.ktextlight,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               const Text("(12 reviews)",
//                                   style: TextStyle(
//                                       color: AppColors.ktextlight,
//                                       decoration: TextDecoration.underline))
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Cards
//                   buildCard(
//                     screenWidth,
//                     'Profile',
//                     Icons.person,
//                     'Manage your profile and documents',
//                     'Profile',
//                     onTap: () => Get.to(() => const ProfileScreen()),
//                   ),
//                   buildCard(screenWidth, 'Security Licences', Icons.badge,
//                       'Update security licences here', 'Licences',
//                       onTap: () => Get.to(() => SecurityLicenseScreen())),
//                   buildCard(screenWidth, 'Earnings', Icons.attach_money,
//                       'See all your earning here', 'Earnings',
//                       onTap: () => Get.to(() => EarningsScreen())),
//                   buildCard(
//                       screenWidth,
//                       'Bank Details',
//                       Icons.account_balance,
//                       'Set payment method and withdrawal settings',
//                       'Bank Details',
//                       onTap: () => Get.to(() => BankDetailsScreen())),
//                   buildCard(screenWidth, 'Help & Support', Icons.help,
//                       'Get assistance', 'Help',
//                       onTap: () => Get.to(() => const HelpSupportScreen())),
//                   buildCard(
//                     screenWidth,
//                     'Settings',
//                     Icons.settings,
//                     'Manage your account',
//                     'Settings',
//                     onTap: () => Get.to(() => const SettingsScreen()),
//                   ),
//                   buildCard(screenWidth, 'Logout', Icons.logout,
//                       'Sign Out securely', 'Logout',
//                       onTap: () => showLogoutBottomSheet(context)),

//                   const SizedBox(height: 5),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildCard(
//     double screenWidth,
//     String title,
//     IconData icon,
//     String subtitle,
//     String screenName, {
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap ?? () => navigateToPlaceholder(screenName),
//       child: Container(
//         width: screenWidth * 0.92,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.kJobCardColor,
//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: AppColors.kPrimary),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 4),
//                   Text(subtitle,
//                       style:
//                           const TextStyle(color: Colors.white54, fontSize: 12)),
//                 ],
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Colors.white)
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildNotificationCard(
//       double screenWidth, AccountController controller) {
//     return Container(
//       width: screenWidth * 0.92,
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: AppColors.kJobCardColor,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.notifications, color: AppColors.kPrimary),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text('Notifications',
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 4),
//                 Text('Allow or mute notifications',
//                     style: TextStyle(color: Colors.white54, fontSize: 12)),
//               ],
//             ),
//           ),
//           Obx(() => Switch(
//                 value: controller.notificationsEnabled.value,
//                 onChanged: (value) =>
//                     controller.notificationsEnabled.value = value,
//                 activeColor: Colors.tealAccent,
//               ))
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // ✅ Added
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/account/components/Earning/earnings_screen.dart';
import 'package:tac/modules/account/components/bank%20details/bank_details_screen.dart';
import 'package:tac/modules/account/components/logout.dart';
import 'package:tac/modules/account/components/profile/profile_screen.dart';
import 'package:tac/modules/account/help_support.dart';
import 'package:tac/modules/account/components/reviews/reviews_screen.dart';
import 'package:tac/modules/alerts/notification_view.dart';

import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_assets.dart';
import '../../dataproviders/api_service.dart';
import 'components/License/security_license_screen.dart';
import 'components/Settings/SettingsScreen.dart';

class AccountController extends GetxController {
  final notificationsEnabled = false.obs;
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  void navigateToPlaceholder(String screenName) {
    Get.to(() => Scaffold(
          appBar: AppBar(title: Text(screenName, style: GoogleFonts.outfit())),
          body: Center(
              child: Text('$screenName Screen Coming Soon',
                  style: GoogleFonts.outfit())),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.put(AccountController());
    final userController = Get.put(UserController());
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Custom App Bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.twentyHorizontal, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.kTacLogo,
                        height: Get.height * 0.045,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Account',
                        style: AppTypography.kBold16.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    focusColor: AppColors.kPrimary,
                    color: AppColors.kPrimary,
                    icon: SvgPicture.asset(
                      width: 35,
                      height: 35,
                      AppAssets.kAlerts,
                    ),
                    onPressed: () {
                      Get.to<void>(() => NotificationScreen());
                    },
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Header
                  Container(
                    width: screenWidth * 0.92,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.kDarkestBlue,
                      border: Border.all(color: AppColors.kgrey, width: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              userController.userData.value?.fullName ??
                                  '',
                              style: GoogleFonts.outfit(
                                  color: AppColors.kWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.kSkyBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                userController.userData.value
                                        ?.professionalBadge ??
                                    'Leader',
                                style: GoogleFonts.outfit(
                                    color: AppColors.kWhite, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Security Professional · ${userController.userData.value?.level}",
                          style: GoogleFonts.outfit(
                              color: AppColors.ktextlight, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => Get.to(() => const ReviewsScreen()),
                          child: Row(
                            children: [
                              for (int i = 0; i < 5; i++)
                                const Icon(Icons.star,
                                    size: 16, color: AppColors.kSkyBlue),
                              const SizedBox(width: 4),
                              Text(
                                "5.0 ",
                                style: GoogleFonts.outfit(
                                    color: AppColors.ktextlight,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "(12 reviews)",
                                style: GoogleFonts.outfit(
                                    color: AppColors.ktextlight,
                                    decoration: TextDecoration.underline),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cards
                  buildCard(
                    screenWidth,
                    'Profile',
                    Icons.person,
                    'Manage your profile and documents',
                    'Profile',
                    onTap: () => Get.to(() => const ProfileScreen()),
                  ),
                  buildCard(screenWidth, 'Security Licences', Icons.badge,
                      'Update security licences here', 'Licences',
                      onTap: () => Get.to(() => SecurityLicenseScreen())),
                  buildCard(screenWidth, 'Earnings', Icons.attach_money,
                      'See all your earning here', 'Earnings',
                      onTap: () => Get.to(() => EarningsScreen())),
                  buildCard(
                      screenWidth,
                      'Bank Details',
                      Icons.account_balance,
                      'Set payment method and withdrawal settings',
                      'Bank Details',
                      onTap: () => Get.to(() => BankDetailsScreen())),
                  buildCard(screenWidth, 'Help & Support', Icons.help,
                      'Get assistance', 'Help',
                      onTap: () => Get.to(() => const HelpSupportScreen())),
                  buildCard(
                    screenWidth,
                    'Settings',
                    Icons.settings,
                    'Manage your account',
                    'Settings',
                    onTap: () => Get.to(() => const SettingsScreen()),
                  ),
                  buildCard(screenWidth, 'Logout', Icons.logout,
                      'Sign Out securely', 'Logout',
                      onTap: () => showLogoutBottomSheet(context)),

                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget buildCard(
    double screenWidth,
    String title,
    IconData icon,
    String subtitle,
    String screenName, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () => navigateToPlaceholder(screenName),
      child: Container(
        width: screenWidth * 0.92,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.kJobCardColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.kPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.outfit(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: GoogleFonts.outfit(
                          color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white)
          ],
        ),
      ),
    );
  }

  Widget buildNotificationCard(
      double screenWidth, AccountController controller) {
    return Container(
      width: screenWidth * 0.92,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: AppColors.kPrimary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notifications',
                    style: GoogleFonts.outfit(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Allow or mute notifications',
                    style: GoogleFonts.outfit(
                        color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Obx(() => Switch(
                value: controller.notificationsEnabled.value,
                onChanged: (value) =>
                    controller.notificationsEnabled.value = value,
                activeColor: Colors.tealAccent,
              ))
        ],
      ),
    );
  }
}
