import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dataproviders/api_service.dart';

class CheckInController extends GetxController {
  var isChecked = false.obs;
  var isLoading = false.obs;
  final apiService = MyApIService();

  void toggleCheck(bool? value) {
    isChecked.value = value ?? false;
  }

  Future<void> checkIn(String shiftId, String guardId, String latitude, String longitude, String selfieBase64) async {
    isLoading.value = true;
    try {
      final response = await apiService.checkinGuard(shiftId, guardId, latitude, longitude, selfieBase64);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show a snackbar/toast or navigate as success
        Get.back();
        Get.snackbar(
          "Check-in Success",
          "You have successfully checked in.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Show error
        Get.snackbar(
          "Check-in Failed",
          "Could not check in. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Check-in Error",
        "An error occurred. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkOut(String shiftId, String guardId, String latitude, String longitude, String selfieBase64) async {
    isLoading.value = true;
    try {
      final response = await apiService.checkOutGuard(shiftId, guardId, latitude, longitude, selfieBase64);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show a snackbar/toast or navigate as success
        Get.back();
        Get.snackbar(
          "Check-out Success",
          "You have successfully checked in.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Show error
        Get.snackbar(
          "Check-out Failed",
          "Could not check in. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Check-out Error",
        "An error occurred. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
