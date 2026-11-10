import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tac/modules/auth/sign_in_view.dart';

import '../../../controllers/user_controller.dart';
import '../../../dataproviders/api_service.dart';
import '../../../models/getUserById_model.dart';
import '../../../models/userdata_model.dart';
import '../../../routes/app_routes.dart';

class AppleAuthService {
  MyApIService myApIService = MyApIService();

  SignInViewController get signInViewController =>
      Get.find<SignInViewController>();

  Future<void> signInWithApple() async {
    try {
      debugPrint("Starting Apple sign-in...");

      // Request Apple ID credential
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      debugPrint("Apple Sign-In success!");
      debugPrint(
          "Identity Token: ${credential.identityToken != null ? 'Received' : 'NULL'}");

      final identityToken = credential.identityToken;
      if (identityToken == null) {
        Get.snackbar("Error", "No identity token received from Apple.");
        return;
      }

      final fcmToken = signInViewController.fcmToken;

      debugPrint("Calling API with Apple credentials...");

      final response = await myApIService.appleLogin(
        identityToken: identityToken,
        fcmToken: fcmToken,
        firstName: credential.givenName,
        lastName: credential.familyName,
      );

      await _handleApiResponse(response, credential);
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> _handleApiResponse(dynamic response, dynamic credential) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      final userDataModel = UserDataModel.fromJson(jsonData);

      if (userDataModel.data != null) {
        final loginData = userDataModel.data!;
        final userId = loginData.id;
        final accessToken = loginData.accessToken;
        if (userId == null || accessToken == null || accessToken.isEmpty) {
          Get.snackbar("Error", "Apple login response is missing session data.");
          return;
        }
        debugPrint('User ID: $userId');
        Get.find<UserController>().setAuthentication(
          token: accessToken,
          id: userId,
          type: 'guard',
        );

        final getUserResponse = await myApIService.getUserByID(
          userId,
          accessToken: accessToken,
        );

        if (getUserResponse.statusCode == 200) {
          final userData =
              GetUserById.fromJson(jsonDecode(getUserResponse.body)).data;

          if (userData != null) {
            userData.accessToken = accessToken;
            Get.find<UserController>().setUser(userData);

            final credentialName = [
              credential.givenName,
              credential.familyName,
            ].whereType<String>().where((name) => name.isNotEmpty).join(' ');
            final displayName = credentialName.isNotEmpty
                ? credentialName
                : userData.fullName ?? 'User';

            Get.snackbar("Success", "Welcome $displayName!");
            debugPrint("Data from API: ${response.body}");
            Get.offAndToNamed(AppRoutes.getLandingPageRoute());
          } else {
            Get.snackbar("Error", "User data is null.");
          }
        } else {
          Get.snackbar("Error",
              "Failed to fetch user data. Status: ${getUserResponse.statusCode}");
        }
      } else {
        Get.snackbar("Error", "User data model is null.");
      }
    } else {
      try {
        final errorResponse = jsonDecode(response.body);
        Get.snackbar(
            "Error",
            errorResponse["message"] ??
                "Apple login failed. Status: ${response.statusCode}");
      } catch (e) {
        Get.snackbar(
            "Error", "Apple login failed. Status: ${response.statusCode}");
      }
    }
  }

  void _handleError(error) {
    debugPrint('Apple Sign-In Error: $error');

    if (error.toString().contains('canceled') ||
        error.toString().contains('cancelled')) {
      Get.snackbar("Cancelled", "Apple Sign-In was cancelled.");
    } else if (error.toString().contains('not_interactive')) {
      Get.snackbar("Error", "Apple Sign-In is not available on this device.");
    } else if (error.toString().contains('credentials')) {
      Get.snackbar("Error", "Invalid Apple credentials.");
    } else if (error.toString().contains('network')) {
      Get.snackbar("Network Error", "Please check your internet connection.");
    } else {
      Get.snackbar(
          "Error", "An unexpected error occurred: ${error.toString()}");
    }
  }

  // Check if Apple Sign-In is available on this device
  Future<bool> isAppleSignInAvailable() async {
    try {
      return await SignInWithApple.isAvailable();
    } catch (e) {
      debugPrint("Error checking Apple Sign-In availability: $e");
      return false;
    }
  }
}
