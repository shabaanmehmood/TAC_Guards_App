import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/modules/checkin/check_in_controller.dart';
import 'package:tac/modules/checkin/jobcheckin/job_checkin_controller.dart';
import 'package:tac/modules/checkin/jobcheckin/job_live_screen.dart';
import 'package:tac/widhets/common%20overlays/uploadFile_overlay.dart';
// your next screen

class JobCheckinScreen extends StatelessWidget {
  final controller = Get.put(CheckInController());
  final UploadFileController uploadFileController =
      Get.put(UploadFileController());

  JobCheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String shiftId = args['shiftId'] ?? '';
    final String latitude = args['latitude'] ?? '';
    final String longitude = args['longitude'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: const Text('Check-in Selfie',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Take a Selfie for Verification",
              style: TextStyle(
                color: AppColors.kWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Please take a selfie to confirm your presence at the job location.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.kgrey),
            ),
            const SizedBox(height: 32),

            // Selfie Avatar + Button
            Obx(() => Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.kgrey,
                      backgroundImage: controller.selfieBase64.value != null
                          ? MemoryImage(controller.convertBase64ToImage(
                              controller.selfieBase64.value!))
                          : null,
                      child: controller.selfieBase64.value == null
                          ? Image.asset(AppAssets.kCam, width: 40, height: 40)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        String? selfie = await uploadFileController
                            .showUploadFileBottomSheet(
                          context,
                          returnBase64: true,
                          showPickFileOption: false,
                          showPickGalleryOption: false,
                        );

                        if (selfie != null) {
                          controller.selfieBase64.value = selfie;
                          Get.snackbar("Selfie Captured",
                              "Selfie successfully uploaded!",
                              backgroundColor: Colors.green,
                              colorText: Colors.white);
                        } else {
                          Get.snackbar(
                              "Error", "Please take a selfie to proceed.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        controller.selfieBase64.value != null
                            ? "Retake Selfie"
                            : "Take Selfie",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                )),

            const Spacer(),

            // Confirm Check-in button
            Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kSkyBlue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: controller.selfieBase64.value == null
                      ? null
                      : () async {
                          controller.isLoading.value = true;
                          Map<String, dynamic> m = await controller.checkIn(
                            shiftId,
                            Get.find<UserController>().userData.value!.id!,
                            double.parse(latitude),
                            double.parse(longitude),
                            controller.selfieBase64.value!,
                          );
                          controller.isLoading.value = false;
                          // After success
                          // Remove 'arguments' from JobLiveScreen constructor
                          Get.to(() => JobLiveScreen(Data: m));
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                      : const Text(
                          "Confirm Check-in",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                )),
          ],
        ),
      ),
    );
  }
}
