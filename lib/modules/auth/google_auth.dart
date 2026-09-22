import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tac/dataproviders/api_service.dart';
import 'package:tac/modules/auth/sign_in_view.dart';
import '../../controllers/user_controller.dart';
import '../../models/getUserById_model.dart';
import '../../models/userdata_model.dart';
import '../../routes/app_routes.dart';

class GoogleAuthService {
  MyApIService myApIService = MyApIService();
  SignInViewController signInViewController = Get.find<SignInViewController>();

  static String get androidClientId {
    // For debug builds (local development)
    if (kDebugMode) {
      return '255779318742-7j19eupdmc44q8fsavioskug65vaph9n.apps.googleusercontent.com';
    } else {
      // playstore(e.g., profile)
      return '255779318742-g4ohb1bqor12ff1s228cahru1va1iajl.apps.googleusercontent.com';
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
    // For iOS - use your REVERSED_CLIENT_ID
    clientId: androidClientId,
    // Optional: For server authentication web client id
    serverClientId:
        '255779318742-sfl9j075utqv88kp199l2s94bih1e5r7.apps.googleusercontent.com',
  );

  Future<void> signInWithGoogle() async {
    try {
      debugPrint("Starting Google sign-in...");
      bool isSignedIn = await _googleSignIn.isSignedIn();
      debugPrint("Is user signed in: $isSignedIn");

      if (isSignedIn) {
        debugPrint(
            "User is already signed in. Signing out to show account list...");
        await _googleSignIn.signOut();
        await Future.delayed(const Duration(milliseconds: 500));

        // ✅ OPTIONAL: Also disconnect to clear cached credentials
        try {
          await _googleSignIn.disconnect();
          await Future.delayed(const Duration(milliseconds: 300));
        } catch (e) {
          debugPrint("Disconnect error (normal): $e");
        }
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar("Sign-In Cancelled", "You cancelled the Google sign-in.");
        return;
      }

      debugPrint("Google user email: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        Get.snackbar("Error", "No ID token received from Google.");
        return;
      }

      debugPrint("ID Token received successfully");

      // Call your API
      final response = await myApIService.googleLogin(
          googleAuth.idToken!, signInViewController.fcmToken!);

      await _handleApiResponse(response, googleUser);
    } catch (error) {
      _handleError(error);
    }
  }

  Future<void> _handleApiResponse(
      response, GoogleSignInAccount googleUser) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      final userDataModel = UserDataModel.fromJson(jsonData);

      if (userDataModel.data != null) {
        final userId = userDataModel.data!.id;
        final getUserResponse = await myApIService.getUserByID(userId!);

        if (getUserResponse.statusCode == 200) {
          final userData =
              GetUserById.fromJson(jsonDecode(getUserResponse.body)).data;
          if (userData != null) {
            Get.find<UserController>().setUser(userData);
            Get.snackbar("Success", "Welcome ${googleUser.displayName}!");
            Get.offAndToNamed(AppRoutes.getLandingPageRoute());
          }
        } else {
          Get.snackbar("Error", "Failed to fetch user data.");
        }
      }
    } else {
      final errorResponse = jsonDecode(response.body);
      Get.snackbar("Error", errorResponse["message"] ?? "Google login failed.");
    }
  }

  void _handleError(error) {
    debugPrint('Google Sign-In Error: $error');
    final errStr = error.toString().toLowerCase();

    if (errStr.contains('cancel') || errStr.contains('12501')) {
      Get.snackbar("Cancelled", "Sign-in was cancelled.");
    } else if (errStr.contains('network')) {
      Get.snackbar("Network Error", "Please check your internet connection.");
    } else if (errStr.contains('sign_in_failed')) {
      Get.snackbar(
          "Sign-In Failed", "Please check your Google Console configuration.");
    } else {
      Get.snackbar(
          "Error", "An unexpected error occurred: ${error.toString()}");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    debugPrint("User signed out from Google");
  }
}
