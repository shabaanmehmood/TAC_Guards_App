// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/modules/account/components/Settings/DeleteAccountScreen.dart';
// import 'package:tac/modules/account/components/Settings/otp.dart';

// import '../../../../controllers/user_controller.dart';
// import '../../../../dataproviders/api_service.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool liveLocation = false;
//   bool biometricLogin = false;
//   final userController = Get.put(UserController());

//   Future<void> sendOtp() async {
//     final apiService = MyApIService(); // create instance
//     try{
//       final response = await apiService.sendOtp(
//         userController.userData.value!.email.toString(),
//       );

//       if (response.statusCode == 200) {
//         debugPrint("data from API ${response.body}");
//         Get.to(() => OtpScreen());
//       } else {
//         debugPrint("data from API ${response.body}");
//         debugPrint('Error login failed: ${response.body}');
//       }
//     }
//     catch(e){
//       debugPrint('Error Network error: ${e.toString()}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkestBlue,
//       appBar: AppBar(
//         backgroundColor: AppColors.kDarkestBlue,
//         surfaceTintColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           "Settings",
//           style: TextStyle(
//             color: AppColors.kWhite,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             color: Colors.white.withOpacity(0.1),
//             height: 1,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 _buildSwitchCard(
//                   icon: Icons.location_on_outlined,
//                   title: 'Live Location',
//                   subtitle:
//                       liveLocation ? 'Enabled' : 'Disabled', // ✅ Now dynamic
//                   value: liveLocation,
//                   onChanged: (val) => setState(() => liveLocation = val),
//                 ),
//                 const SizedBox(height: 12),
//                 _buildNavigationCard(
//                   icon: Icons.lock_outline,
//                   title: 'Update Password',
//                   subtitle: 'Manage your details',
//                   onTap: () {
//                     sendOtp();
//                   },
//                 ),
//                 const SizedBox(height: 12),
//                 _buildSwitchCard(
//                   icon: Icons.fingerprint,
//                   title: 'Biometric Login',
//                   subtitle: biometricLogin ? 'Enabled' : 'Disabled',
//                   value: biometricLogin,
//                   onChanged: (val) => setState(() => biometricLogin = val),
//                 ),
//                 const SizedBox(height: 12),
//                 _buildDeleteCard(),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.kJobCardColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "App Version",
//                         style: TextStyle(
//                           color: AppColors.kgrey,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "2.1.0",
//                         style: TextStyle(
//                           color: AppColors.kgrey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     "© 2024 TAC Solutions. All rights reserved.",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: AppColors.kgrey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildSwitchCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool value,
//     required Function(bool) onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.kJobCardColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Icon(icon, color: AppColors.kSkyBlue),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 2),
//                 Text(subtitle,
//                     style: const TextStyle(
//                         color: AppColors.ktextlight, fontSize: 12)),
//               ],
//             ),
//           ),
//           Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: AppColors.kSkyBlue,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavigationCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.kJobCardColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             Icon(icon, color: AppColors.kSkyBlue),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 2),
//                   Text(subtitle,
//                       style: const TextStyle(
//                           color: AppColors.ktextlight, fontSize: 12)),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios,
//                 size: 16, color: AppColors.kgrey),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeleteCard() {
//     return GestureDetector(
//       onTap: () {
//         showModalBottomSheet(
//           context: Get.context!,
//           isScrollControlled: true,
//           backgroundColor: AppColors.kBlack.withOpacity(0.05),
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//           ),
//           builder: (context) => DeleteAccountScreen(),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.kRed.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: const [
//             Icon(Icons.delete_forever_outlined, color: AppColors.kRed),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Delete Account",
//                       style: TextStyle(
//                           color: AppColors.kRed, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 2),
//                   Text("All your data will be permanently deleted",
//                       style: TextStyle(color: AppColors.kRed, fontSize: 12)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/modules/account/components/Settings/DeleteAccountScreen.dart';
import 'package:tac/modules/account/components/Settings/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool liveLocation = false;
  bool biometricLogin = false;
  final userController = Get.put(UserController());
  final LocalAuthentication auth = LocalAuthentication();

  // @override
  // void initState() {
  //   super.initState();
  //   _loadBiometricSetting();
  // }

  @override
  void initState() {
    super.initState();
    _loadBiometricSetting();
    _loadLocationSetting(); // ✅ new
  }

// ✅ Load location toggle from SharedPreferences
  Future<void> _loadLocationSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      liveLocation = prefs.getBool('live_location') ?? false;
    });
  }

// ✅ Save location toggle to SharedPreferences
  Future<void> _saveLocationSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // If turning OFF, just save and show message
    if (!value) {
      await prefs.setBool('live_location', value);
      setState(() {
        liveLocation = value;
      });
      _showSnackbar('Live location disabled', isError: false);
      return;
    }

    // If turning ON, check service and show dialog
    final location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Service not enabled, keep toggle off
        setState(() {
          liveLocation = false;
        });
        _showSnackbar('Location service not enabled', isError: true);
        return;
      }
    }

    // Show permission dialog
    bool userAccepted = await _showLocationPermissionDialog();

    if (userAccepted) {
      // User clicked "Enable" - save and show success
      await prefs.setBool('live_location', true);
      setState(() {
        liveLocation = true;
      });
      _showSnackbar('Live location enabled', isError: false);
    } else {
      // User clicked "No Thanks" - DON'T save, keep toggle OFF
      await prefs.setBool('live_location', false);
      setState(() {
        liveLocation = false;
      });
      // DON'T show success message
    }
  }

  Future<bool> _showLocationPermissionDialog() async {
    bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kJobCardColor, // Changed background color
        title: Text(
          "Enable Live Location?",
          style: TextStyle(
            color: Colors.white, // Title text color for contrast
          ),
        ),
        content: Text(
          "Allow location access to see nearby guards and jobs on the map. This helps in tracking and navigation.",
          style: TextStyle(
            color: Colors.white.withOpacity(0.9), // Content text color
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // No Thanks
            },
            child: Text(
              "No Thanks",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Enable
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.kSkyBlue, // Button background color
              foregroundColor: Colors.white, // Button text color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              "Enable",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // ✅ Load biometric setting from SharedPreferences
  Future<void> _loadBiometricSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      biometricLogin = prefs.getBool('biometric_login') ?? false;
    });
  }

  // ✅ Save biometric setting to SharedPreferences
  Future<void> _saveBiometricSetting(bool value) async {
    if (value) {
      // User wants to enable biometric - check if device supports it
      bool canAuthenticate = await _checkBiometricSupport();
      if (!canAuthenticate) {
        _showBiometricUnavailableDialog();
        return;
      }

      // Test biometric authentication before enabling
      bool authenticated = await _authenticateWithBiometrics();
      if (!authenticated) {
        _showSnackbar('Biometric authentication failed', isError: true);
        return;
      }
    }

    // Save to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_login', value);

    setState(() {
      biometricLogin = value;
    });

    _showSnackbar(
      value
          ? 'Biometric login enabled successfully'
          : 'Biometric login disabled',
      isError: false,
    );
  }

  // ✅ Check if device supports biometrics
  Future<bool> _checkBiometricSupport() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('⚠️ Error checking biometric support: $e');
      return false;
    }
  }

  // ✅ Authenticate with biometrics
  Future<bool> _authenticateWithBiometrics() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to enable biometric login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('⚠️ Biometric authentication error: $e');
      return false;
    }
  }

  // ✅ Show dialog when biometric is unavailable
  void _showBiometricUnavailableDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.kJobCardColor,
        title: const Text(
          'Biometric Unavailable',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Your device does not support biometric authentication or it is not set up.',
          style: TextStyle(color: AppColors.ktextlight),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.kSkyBlue),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Show snackbar for feedback
  void _showSnackbar(String message, {required bool isError}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      backgroundColor: isError ? AppColors.kRed : AppColors.kSkyBlue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  bool isSendingOtp = false;

  Future<void> sendOtp() async {
    if (isSendingOtp) return;
    setState(() => isSendingOtp = true);
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppColors.kSkyBlue),
      ),
      barrierDismissible: false,
    );
    final apiService = MyApIService();
    try {
      final email = userController.userData.value?.email ?? '';
      if (email.isEmpty) {
        if (Get.isDialogOpen == true) Get.back();
        Get.snackbar("Error", "Email not found. Please log in again.",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      final response = await apiService.sendOtp(email);

      if (Get.isDialogOpen == true) Get.back();

      if (response.statusCode == 200) {
        debugPrint("data from API ${response.body}");
        Get.to(() => OtpScreen());
      } else {
        debugPrint("data from API ${response.body}");
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String errorMessage =
            responseBody['message'] ?? 'Failed to send OTP';
        Get.snackbar("Error", errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      debugPrint('Error Network error: ${e.toString()}');
      Get.snackbar("Network Error", "Unable to connect to server.",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if (mounted) {
        setState(() => isSendingOtp = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: AppColors.kWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // _buildSwitchCard(
                //   icon: Icons.location_on_outlined,
                //   title: 'Live Location',
                //   subtitle: liveLocation ? 'Enabled' : 'Disabled',
                //   value: liveLocation,
                //   onChanged: (val) => setState(() => liveLocation = val),
                // ),

                _buildSwitchCard(
                    icon: Icons.location_on_outlined,
                    title: 'Live Location',
                    subtitle: liveLocation ? 'Enabled' : 'Disabled',
                    value: liveLocation,
                    onChanged: (val) {
                      _saveLocationSetting(val);
                    }),

                const SizedBox(height: 12),
                _buildNavigationCard(
                  icon: Icons.lock_outline,
                  title: 'Update Password',
                  subtitle: 'Manage your details',
                  onTap: () {
                    sendOtp();
                  },
                ),
                const SizedBox(height: 12),
                _buildSwitchCard(
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  subtitle: biometricLogin ? 'Enabled' : 'Disabled',
                  value: biometricLogin,
                  onChanged: (val) => _saveBiometricSetting(val),
                ),
                const SizedBox(height: 12),
                _buildDeleteCard(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "App Version",
                        style: TextStyle(
                          color: AppColors.kgrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "2.1.0",
                        style: TextStyle(
                          color: AppColors.kgrey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "© 2024 Control1 Security. All rights reserved.",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.kgrey,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.kSkyBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.ktextlight, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.kSkyBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kJobCardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.kSkyBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.ktextlight, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.kgrey),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteCard() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: AppColors.kBlack.withOpacity(0.05),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => DeleteAccountScreen(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            Icon(Icons.delete_forever_outlined, color: AppColors.kRed),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Delete Account",
                      style: TextStyle(
                          color: AppColors.kRed, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text("All your data will be permanently deleted",
                      style: TextStyle(color: AppColors.kRed, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
