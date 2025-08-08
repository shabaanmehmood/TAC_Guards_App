// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'dart:convert';
//
import 'package:tac/dataproviders/api_service.dart';
import 'package:tac/modules/auth/sign_in_view.dart';
import '../../controllers/user_controller.dart';
import '../../models/getUserById_model.dart';
import '../../models/userdata_model.dart';
import '../../routes/app_routes.dart';
//
// class GoogleAuthService {
//   MyApIService myApIService = MyApIService();
//
//   // Use the singleton instance
//   final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//
//   bool _isInitialized = false;
//
//   // Replace with your actual Web client ID from Google Cloud Console
//   final String _serverClientId = '129556296565-kqkltik9ofd8hjhpre5ng0c1n7gcagou.apps.googleusercontent.com'; // Required!
//
//   Future<void> _ensureInitialized() async {
//     if (!_isInitialized) {
//       try {
//         await _googleSignIn.initialize(
//           serverClientId: _serverClientId,
//         );
//         _isInitialized = true;
//       } catch (e) {
//         Get.snackbar("Error", "Google Sign-In initialization failed: $e");
//         return;
//       }
//     }
//   }
//
//   Future<void> signInWithGoogle() async {
//     try {
//       await _ensureInitialized();
//       debugPrint("Google sign-in initialized");
//
//       final googleUser = await _googleSignIn.authenticate(scopeHint: ['email', 'profile']);
//       debugPrint("Google user selected: $googleUser");
//
//       if (googleUser == null) {
//         Get.snackbar("Sign-In Cancelled", "You cancelled the Google sign-in.");
//         return;
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//       final response = await myApIService.googleLogin(googleAuth.idToken!);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final jsonData = jsonDecode(response.body);
//         final userDataModel = UserDataModel.fromJson(jsonData);
//
//         if (userDataModel.data != null) {
//           final userId = userDataModel.data!.id;
//           debugPrint('User ID: $userId');
//           final getUserResponse = await myApIService.getUserByID(userId!);
//           if (getUserResponse.statusCode == 200) {
//             final userData = GetUserById.fromJson(jsonDecode(getUserResponse.body)).data;
//             if (userData != null) {
//               Get.find<UserController>().setUser(userData);
//               Get.snackbar("Success", "Google sign-in successful!");
//               debugPrint("data from API ${response.body}");
//               Get.offAndToNamed(AppRoutes.getLandingPageRoute());
//             }
//           } else {
//             Get.snackbar("Error", "Failed to fetch user data.");
//           }
//         }
//       } else {
//         final errorResponse = jsonDecode(response.body);
//         Get.snackbar("Error", errorResponse["message"] ?? "Google login failed.");
//       }
//     } on GoogleSignInException catch (e) {
//       Get.snackbar("Error", "Google sign-in failed: ${e}");
//       debugPrint('GoogleSignInException: $e');
//     } catch (error) {
//       Get.snackbar("Error", "An unexpected error occurred: $error");
//       debugPrint('Error signing in: $error');
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  MyApIService myApIService = MyApIService();
  SignInViewController signInViewController = Get.find<SignInViewController>();

  // Use the singleton instance
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isInitialized = false;

  // Your actual Web client ID from Google Cloud Console
  final String _serverClientId = '129556296565-kqkltik9ofd8hjhpre5ng0c1n7gcagou.apps.googleusercontent.com'; // Required!

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      try {
        // Initialize with your server client ID
        await _googleSignIn.initialize(
          serverClientId: _serverClientId,
        );
        _isInitialized = true;
      } catch (e) {
        Get.snackbar("Error", "Google Sign-In initialization failed: $e");
        return;
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _ensureInitialized();
      debugPrint("Google sign-in initialized");

      // Use scopeHint for required scopes (email and profile)
      final googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile', 'openid'], // recommended for user identity
      );
      debugPrint("Google user selected: $googleUser");

      if (googleUser == null) {
        Get.snackbar("Sign-In Cancelled", "You cancelled the Google sign-in.");
        return;
      }

      final email = googleUser.email;
      debugPrint("User email: $email");

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final response = await myApIService.googleLogin(googleAuth.idToken!, signInViewController.fcmToken!);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final userDataModel = UserDataModel.fromJson(jsonData);

        if (userDataModel.data != null) {
          final userId = userDataModel.data!.id;
          debugPrint('User ID: $userId');
          final getUserResponse = await myApIService.getUserByID(userId!);
          if (getUserResponse.statusCode == 200) {
            final userData = GetUserById.fromJson(jsonDecode(getUserResponse.body)).data;
            if (userData != null) {
              Get.find<UserController>().setUser(userData);
              Get.snackbar("Success", "Google sign-in successful!");
              debugPrint("data from API ${response.body}");
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
    } on GoogleSignInException catch (e) {
      Get.snackbar("Error", "Google sign-in failed: ${e}");
      debugPrint('GoogleSignInException: $e');
    } catch (error) {
      Get.snackbar("Error", "An unexpected error occurred: $error");
      debugPrint('Error signing in: $error');
    }
  }
}