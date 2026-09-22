import 'package:tac/data/data/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../routes/app_routes.dart';

class DeleteAccountController extends GetxController {
  var selectedReason = ''.obs;
  var showPassword = false.obs;

  final otherReasonController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final userController = Get.find<UserController>();

  Future<void> deleteAccount() async {
    final apiService = MyApIService(); // create instance
    try{
      final response = await apiService.deleteAccount(
        userController.userData.value!.id!,
      );
      if (response.statusCode == 200) {
        debugPrint("data from delete API ${response.body}");
        // Clear user data
        userController.userData.value = null;
        Get.offAllNamed(AppRoutes.getOnboardingRoute());
      } else {
        debugPrint('Error delete API failed: ${response.body}');
      }
    }
    catch(e){
      debugPrint('Error Network error: ${e.toString()}');
    }
  }
}

class DeleteAccountScreen extends StatelessWidget {
  final controller = Get.put(DeleteAccountController());

  DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: AppColors.kDarkestBlue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 18, color: AppColors.kinput),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Delete Account",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.kinput,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.kinput, height: 1),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: const [
                          Icon(Icons.warning_amber_outlined,
                              color: AppColors.kRed),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "This action is irreversible. All your data, including account information, preferences, and history, will be permanently deleted.",
                              style: TextStyle(
                                  color: AppColors.kWhite, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Why are you leaving? (Optional)",
                      style: TextStyle(
                        color: AppColors.kWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...[
                      "I have another account",
                      "Privacy concerns",
                      "Not satisfied with the service",
                      "Other"
                    ].map((reason) {
                      return Obx(
                        () => RadioListTile<String>(
                          activeColor: AppColors.kSkyBlue,
                          contentPadding: EdgeInsets.zero,
                          title: Text(reason,
                              style: const TextStyle(
                                  color: AppColors.kWhite, fontSize: 14)),
                          value: reason,
                          groupValue: controller.selectedReason.value,
                          onChanged: (val) =>
                              controller.selectedReason.value = val ?? '',
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller.otherReasonController,
                      "Please tell us more...",
                      Icons.edit,
                      isPassword: false,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => _buildInputField(
                        controller.passwordController,
                        "Enter Your Password",
                        Icons.lock_outline,
                        isPassword: true,
                        obscureText: !controller.showPassword.value,
                        toggleVisibility: () =>
                            controller.showPassword.toggle(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller.confirmController,
                      "Type DELETE To Confirm",
                      Icons.delete_outline,
                      isPassword: false,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.kSkyBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: AppColors.kSkyBlue, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "You can restore your account within 7 days before permanent deletion. After this period, all data will be permanently erased.",
                              style: TextStyle(
                                  color: AppColors.kSkyBlue, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: AppColors.kinput),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Row(
              children: [
                Expanded(
                  flex: 3, // 30%
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.kWhite,
                        side: const BorderSide(color: AppColors.kWhite),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // rounded corners
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 7, // 70%
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _showDeleteConfirmationSheet(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Delete Account",
                        style: TextStyle(color: AppColors.kWhite),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.kinput),
      cursorColor: AppColors.kSkyBlue,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.kinput),
        prefixIcon: Icon(icon, color: AppColors.kinput),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: toggleVisibility,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.kSkyBlue,
                ),
              )
            : null,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
      ),
    );
  }

  void _showDeleteConfirmationSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.kDarkestBlue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline,
                      color: AppColors.kSkyBlue),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, color: AppColors.kSkyBlue),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Are you sure you want to delete your account?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "This action is irreversible. All your data will be permanently deleted, and you won’t be able to recover your account.",
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.deleteAccount();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.kRed,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Delete Account"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF064E3B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
