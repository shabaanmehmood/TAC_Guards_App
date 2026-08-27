import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/modules/account/components/logoutConstant.dart';

import '../../../controllers/user_controller.dart';
import '../../../dataproviders/api_service.dart';
import '../../../routes/app_routes.dart';
import '../../Guards/guards_view.dart';
import '../../Messages/socket_file.dart';

class LogoutController extends GetxController {
  final userController = Get.find<UserController>();
  var isLoggingOut = false.obs;

  Future<void> clearLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('loginTime');
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;
    isLoggingOut.value = true;
    final apiService = MyApIService(); // create instance
    try {
      final userId = userController.userData.value?.id;
      if (userId != null) {
        final response = await apiService.logout(userId);
        debugPrint("data from logout API ${response.body}");
      }
      
      final prefs = await SharedPreferences.getInstance();
      // Use the shared constants to remove the data
      await prefs.remove(AppConstants.rememberEmailKey);
      await prefs.remove(AppConstants.rememberPasswordKey);
      await prefs.remove(AppConstants.loginTimeKey);

      // ✅ Remove biometric login setting
      await prefs.remove('biometric_login');
      await prefs.remove('live_location');

      userController.clearUser();
      SocketService().disconnect();

      // Clear the distance cache when logging out
      if (Get.isRegistered<GuardsViewController>()) {
        final guardsController = Get.find<GuardsViewController>();
        guardsController.clearDistanceCache();
      }

      Get.offAllNamed(AppRoutes.getSignInRoute());
    } catch (e) {
      debugPrint('Error Network error: ${e.toString()}');
      Get.offAllNamed(AppRoutes.getSignInRoute());
    } finally {
      isLoggingOut.value = false;
    }
  }
}

// Call this method from anywhere in your app to show the Logout Bottom Sheet
void showLogoutBottomSheet(BuildContext context) {
  final controller = Get.put(LogoutController());

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.kDarkestBlue,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3), // translucent background
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (modalContext) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Logout!',
                  style: TextStyle(
                    color: AppColors.kWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Obx(() => GestureDetector(
                      onTap: controller.isLoggingOut.value
                          ? null
                          : () {
                              if (Navigator.canPop(modalContext)) {
                                Navigator.pop(modalContext);
                              } else {
                                Get.back();
                              }
                            },
                      child: const Icon(Icons.close, color: AppColors.kinput),
                    )),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Are you sure you want to log out?',
              style: TextStyle(
                  color: AppColors.kWhite, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'You will need to log in again to access your account.',
              style: TextStyle(color: AppColors.kinput, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Obx(() => OutlinedButton(
                        onPressed: controller.isLoggingOut.value
                            ? null
                            : () {
                                if (Navigator.canPop(modalContext)) {
                                  Navigator.pop(modalContext);
                                } else {
                                  Get.back();
                                }
                              },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.transparent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'No, Cancel',
                          style: TextStyle(color: Colors.green),
                        ),
                      )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoggingOut.value
                            ? null
                            : controller.logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(235, 0, 0, 0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isLoggingOut.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Log Out',
                                style: TextStyle(color: Colors.red),
                              ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
