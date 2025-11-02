import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/routes/app_routes.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    // Automatically trigger biometric on screen load
    Future.delayed(const Duration(milliseconds: 500), () {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    if (isAuthenticating) return;

    setState(() {
      isAuthenticating = true;
    });

    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (didAuthenticate) {
        // Authentication successful - navigate to main app
        Get.offAllNamed(AppRoutes.splashScreen);
      } else {
        setState(() {
          isAuthenticating = false;
        });
      }
    } on PlatformException catch (e) {
      debugPrint('⚠️ Biometric authentication error: $e');
      setState(() {
        isAuthenticating = false;
      });
      
      Get.snackbar(
        'Authentication Error',
        'Failed to authenticate. Please try again.',
        backgroundColor: AppColors.kRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint,
              size: 100,
              color: AppColors.kSkyBlue,
            ),
            const SizedBox(height: 32),
            const Text(
              'Biometric Authentication',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Please authenticate to access the app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.ktextlight,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 48),
            if (!isAuthenticating)
             ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint,size: 30,),
                // label: const Text('Authenticate'),
                label: Text(
                                'Authenticate',
                                style: AppTypography.customkBold16.copyWith(
                                  color: AppColors.kWhite,
                                ),
                              ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            else
              const CircularProgressIndicator(
                color: AppColors.kSkyBlue,
              ),
          ],
        ),
      ),
    );
  }
}