import 'dart:convert';
import 'dart:math';
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
        webAuthenticationOptions: WebAuthenticationOptions(
          // ✅ Use your Apple Service ID for web (if needed)
          clientId: 'com.yourcompany.taccontractor.service',
          redirectUri: Uri.parse(
            'https://your-domain.com/callbacks/sign_in_with_apple',
          ),
        ),
        // Nonce is important for security - generate a random one
        nonce: _generateNonce(),
      );

      debugPrint("Apple Sign-In success!");
      debugPrint("User Identifier: ${credential.userIdentifier}");
      debugPrint("Email: ${credential.email}");
      debugPrint("Given Name: ${credential.givenName}");
      debugPrint("Family Name: ${credential.familyName}");
      debugPrint(
          "Identity Token: ${credential.identityToken != null ? 'Received' : 'NULL'}");
      debugPrint("Authorization Code: ${'Received'}");

      // Check if we have the required tokens
      if (credential.identityToken == null &&
          credential.authorizationCode == null) {
        Get.snackbar("Error", "No authentication tokens received from Apple.");
        return;
      }

      // Get FCM token safely
      final fcmToken = signInViewController.fcmToken;
      if (fcmToken == null) {
        Get.snackbar("Error", "FCM token not available.");
        return;
      }

      debugPrint("Calling API with Apple credentials...");

      // Call your API with Apple credentials
      // You can send either identityToken or authorizationCode to your backend
      final response = await myApIService.appleLogin(
        identityToken: credential.identityToken,
        authorizationCode: credential.authorizationCode,
        fcmToken: fcmToken,
        email: credential.email,
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
        final userId = userDataModel.data!.id;
        debugPrint('User ID: $userId');

        final getUserResponse = await myApIService.getUserByID(userId!);

        if (getUserResponse.statusCode == 200) {
          final userData =
              GetUserById.fromJson(jsonDecode(getUserResponse.body)).data;

          if (userData != null) {
            Get.find<UserController>().setUser(userData);

            // Use name from Apple credential - access properties directly
            final displayName = credential.givenName ??
                credential.familyName ??
                userData.fullName ??
                'User';

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

  // Generate a cryptographically secure nonce for Apple Sign-In
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
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
