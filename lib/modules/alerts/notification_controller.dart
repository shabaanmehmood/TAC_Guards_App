// // controllers/notification_controller.dart
// import 'package:get/get.dart';
// import 'package:tac/controllers/user_controller.dart';
// import 'package:tac/dataproviders/api_service.dart';
// import 'package:tac/models/notification_model.dart';

// class NotificationController extends GetxController {
//   var notifications = <GuardNotification>[].obs;
//   var isLoading = false.obs;

//   final MyApIService _notificationService = MyApIService();
//   UserController userController = Get.find<UserController>();
  
//   Future<void> loadNotifications() async {
//     try {
//       isLoading.value = true;
//       final String guardId = userController.userData.value!.id!;
//       final fetched = await _notificationService.fetchNotifications(guardId);
//       notifications.assignAll(fetched);
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


// controllers/notification_controller.dart
import 'package:get/get.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/dataproviders/api_service.dart';
import 'package:tac/models/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <GuardNotification>[].obs;
  var isLoading = false.obs;

  final MyApIService _notificationService = MyApIService();
  UserController userController = Get.find<UserController>();

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final String guardId = userController.userData.value!.id!;
      final fetched = await _notificationService.fetchNotifications(guardId);
      notifications.assignAll(fetched);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> markAllRead() async {
  //   try {
  //     final String guardId = userController.userData.value!.id!;
      
  //     // Call the API service to mark all notifications as read
  //     await _notificationService.markAllNotificationsAsRead(guardId);
      
  //     // Clear the local list to update the UI
  //     notifications.clear();
      
  //     Get.snackbar("Success", "All notifications have been marked as read.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.kGreenS,
  //       colorText: AppColors.kWhite
  //     );

  //   } catch (e) {
  //     Get.snackbar("Error", e.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: AppColors.kRed,
  //       colorText: AppColors.kWhite,
  //     );
  //   }
  // }

  Future<void> markAllRead() async {
  // 1. If already empty → do nothing, no toast
  if (notifications.isEmpty) {
    return;
  }

  try {
    final String guardId = userController.userData.value!.id!;

    // 2. Prevent double taps: loading lock
    if (isLoading.value) return;
    isLoading.value = true;

    await _notificationService.markAllNotificationsAsRead(guardId);

    // 3. Clear local data so no repeat toast next time
    notifications.clear();

    // 4. Show success toast only once
    Get.closeAllSnackbars();         // <--- PREVENT QUEUED SNACKBARS
    Get.snackbar(
      "Success",
      "All notifications have been marked as read.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.kGreenS,
      colorText: AppColors.kWhite,
      duration: const Duration(seconds: 2),
    );

  } catch (e) {
    Get.closeAllSnackbars();         // prevent duplicate error messages
    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.kRed,
      colorText: AppColors.kWhite,
    );
  } finally {
    isLoading.value = false;
  }
}

}