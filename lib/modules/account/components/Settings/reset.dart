import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/helpers/validators.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../routes/app_routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  final userController = Get.put(UserController());
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isResetting = false;

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isResetting) return;
    setState(() => _isResetting = true);

    final apiService = MyApIService();
    try {
      final response = await apiService.resetPassword(
        userController.userData.value!.email.toString(),
        passwordController.text.toString(),
        confirmPasswordController.text.toString(),
      );

      if (response.statusCode == 200) {
        debugPrint("data from API ${response.body}");
        Get.snackbar("Success", "Password updated successfully",
            backgroundColor: AppColors.kSkyBlue, colorText: Colors.black);
        Get.offAllNamed(AppRoutes.getLandingPageRoute());
      } else {
        debugPrint("data from API ${response.body}");
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String errorMessage =
            responseBody['message'] ?? 'Failed to reset password';
        Get.snackbar("Error", errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint('Error Network error: ${e.toString()}');
      Get.snackbar("Network Error", "Unable to connect to server.",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if (mounted) {
        setState(() => _isResetting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.kinput, size: 16),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Get.back();
            }
          },
        ),
        title: const Text('Verify Email',
            style: TextStyle(color: AppColors.kWhite)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.kinput, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Reset Password",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white)),
              const SizedBox(height: 4),
              const Text("Set new password here.",
                  style: TextStyle(color: AppColors.kinput, fontSize: 12)),
              const SizedBox(height: 24),

              // New Password Field
              TextFormField(
                controller: passwordController,
                obscureText: _obscureNewPassword,
                style: const TextStyle(color: Colors.white),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(64),
                ],
                validator: AppValidators.validateSignupPassword,
                onChanged: (val) {
                  _formKey.currentState?.validate();
                },
                decoration: InputDecoration(
                  hintText: 'New Password',
                  hintStyle: const TextStyle(color: AppColors.kinput),
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: AppColors.kinput),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.kinput,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.kinput),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.kSkyBlue),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password Field
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: const TextStyle(color: Colors.white),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(64),
                ],
                validator: (val) => AppValidators.validateConfirmPassword(
                    val, passwordController.text),
                onChanged: (val) {
                  _formKey.currentState?.validate();
                },
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: const TextStyle(color: AppColors.kinput),
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: AppColors.kinput),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.kinput,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.kinput),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.kSkyBlue),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Update Password Button
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kSkyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: _isResetting
                      ? null
                      : () {
                          resetPassword();
                        },
                  child: _isResetting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Update Password",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
