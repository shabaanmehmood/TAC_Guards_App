// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:tac/controllers/mapController.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/dataproviders/notification_services/notification_handler.dart';
// import 'package:tac/dataproviders/notification_services/notification_services.dart';
// import 'package:tac/firebase_options.dart';
// import 'package:tac/modules/Guards/guards_view.dart';
// import 'package:tac/routes/app_routes.dart';
// import 'controllers/user_controller.dart';
// import 'data/data/constants/app_theme.dart';
// import './request_permissions.dart';
// import 'package:google_fonts/google_fonts.dart';


// // Future<String> getInitialRoute() async {
// //   final prefs = await SharedPreferences.getInstance();
// //   final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
// //   final loginTime = prefs.getInt('loginTime');
// //
// //   if (!isLoggedIn || loginTime == null) {
// //     return AppRoutes.getOnboardingRoute(); // User not logged in
// //   }
// //
// //   final now = DateTime.now().millisecondsSinceEpoch;
// //   if (now - loginTime < 4 * 60 * 60 * 1000) {
// //     return AppRoutes.getLandingPageRoute(); // User logged in and session valid
// //   } else {
// //     // Session expired, clear stored session
// //     await prefs.remove('isLoggedIn');
// //     await prefs.remove('loginTime');
// //     return AppRoutes.getOnboardingRoute();
// //   }
// // }

// // ✅ Top-level background handler
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(); // required in background isolate
//   print("📩 Background message received: ${message.notification?.title}");
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // Request location permissions at app startup
//   await requestPermissions();

//   // ✅ Background handler registration MUST be BEFORE runApp()
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
//   await SystemChrome.setPreferredOrientations(
//     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
//   );

//   // ✅ Initialize Local Notifications
//   NotificationServices.requestNotificationPermission();
//   NotificationServices.localNotiInit();

//   // ✅ FCM Foreground & Terminated State
//   NotificationHandlerController.initializeFCMHandlers();
//   await NotificationHandlerController.handleTerminatedState();
//   Get.put(UserController(), permanent: true);
//   Get.put(MapController(), permanent: true); // <-- Add this line here
//   // Get.put(GuardsViewController(),permanent: true);
//   // final initialRoute = await getInitialRoute();
//   // runApp(Main(initialRoute: initialRoute,));
//   runApp(
//     Main(
//       initialRoute: AppRoutes.splashScreen,
//     ),
//   );
// }

// class Main extends StatelessWidget {
//   final String initialRoute;
//   Main({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     // final themeController = Get.put(ThemeController());
//     // debugPrint(themeController.theme);
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: GetMaterialApp(
//         color: AppColors.kDarkBlue,
//         title: 'TAC',
//         debugShowCheckedModeBanner: false,
//         useInheritedMediaQuery: true,
//         // locale: DevicePreview.locale(context),
//         // builder: DevicePreview.appBuilder,
//         scrollBehavior: const ScrollBehavior()
//             .copyWith(physics: const BouncingScrollPhysics()),
//         defaultTransition: Transition.fadeIn,
//         // theme: AppTheme.lightTheme,
//         // darkTheme: AppTheme.darkTheme,
//         // themeMode: getThemeMode(themeController.theme),
//         // initialRoute: AppRoutes.getOnboardingRoute(),
//         initialRoute: AppRoutes.splashScreen,
//         getPages: AppRoutes.routes,

//               theme: ThemeData(
//         fontFamily: GoogleFonts.outfit().fontFamily,
//         textTheme: GoogleFonts.outfitTextTheme(),
//         primaryTextTheme: GoogleFonts.outfitTextTheme(),
//         useMaterial3: true,
//       ),

//       ),
//     );
//   }
// }

// main code

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:tac/controllers/mapController.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/dataproviders/notification_services/notification_handler.dart';
// import 'package:tac/dataproviders/notification_services/notification_services.dart';
// import 'package:tac/firebase_options.dart';
// import 'package:tac/modules/Guards/guards_view.dart';
// import 'package:tac/routes/app_routes.dart';
// import 'controllers/user_controller.dart';
// import 'data/data/constants/app_theme.dart';
// import './request_permissions.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:local_auth/local_auth.dart';

// // ✅ Top-level background handler
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(); // required in background isolate
//   print("📩 Background message received: ${message.notification?.title}");
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // Request location permissions at app startup
//   await requestPermissions();

//   // ✅ Background handler registration MUST be BEFORE runApp()
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//   SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
//   await SystemChrome.setPreferredOrientations(
//     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
//   );

//   // ✅ Initialize Local Notifications
//   NotificationServices.requestNotificationPermission();
//   NotificationServices.localNotiInit();

//   // ✅ FCM Foreground & Terminated State
//   NotificationHandlerController.initializeFCMHandlers();
//   await NotificationHandlerController.handleTerminatedState();
  
//   Get.put(UserController(), permanent: true);
//   Get.put(MapController(), permanent: true);

//   // ✅ Check Biometric Setting
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool? biometricEnabled = prefs.getBool('biometric_login');
  
//   String initialRoute = AppRoutes.splashScreen;
  
//   // If biometric is enabled (true), check authentication
//   if (biometricEnabled == true) {
//     bool authenticated = await _authenticateWithBiometrics();
//     if (!authenticated) {
//       // User failed biometric, stay on biometric screen
//       initialRoute = AppRoutes.biometricLock;
//     }
//   }
//   // If null or false, proceed normally

//   runApp(
//     Main(
//       initialRoute: initialRoute,
//     ),
//   );
// }

// // ✅ Biometric Authentication Function
// Future<bool> _authenticateWithBiometrics() async {
//   final LocalAuthentication auth = LocalAuthentication();
  
//   try {
//     // Check if device supports biometrics
//     final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
//     final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    
//     if (!canAuthenticate) {
//       debugPrint('⚠️ Device does not support biometrics');
//       return true; // Allow access if device doesn't support biometrics
//     }

//     // Authenticate
//     final bool didAuthenticate = await auth.authenticate(
//       localizedReason: 'Please authenticate to access the app',
//       options: const AuthenticationOptions(
//         stickyAuth: true,
//         biometricOnly: false,
//       ),
//     );

//     return didAuthenticate;
//   } on PlatformException catch (e) {
//     debugPrint('⚠️ Biometric authentication error: $e');
//     return false;
//   }
// }

// class Main extends StatelessWidget {
//   final String initialRoute;
//   Main({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: GetMaterialApp(
//         color: AppColors.kDarkBlue,
//         title: 'TAC',
//         debugShowCheckedModeBanner: false,
//         useInheritedMediaQuery: true,
//         scrollBehavior: const ScrollBehavior()
//             .copyWith(physics: const BouncingScrollPhysics()),
//         defaultTransition: Transition.fadeIn,
//         initialRoute: initialRoute,
//         getPages: AppRoutes.routes,
//         theme: ThemeData(
//           fontFamily: GoogleFonts.outfit().fontFamily,
//           textTheme: GoogleFonts.outfitTextTheme(),
//           primaryTextTheme: GoogleFonts.outfitTextTheme(),
//           useMaterial3: true,
//         ),
//       ),
//     );
//   }
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:tac/controllers/mapController.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/dataproviders/notification_services/notification_handler.dart';
import 'package:tac/dataproviders/notification_services/notification_services.dart';
import 'package:tac/firebase_options.dart';
import 'package:tac/modules/Guards/guards_view.dart';
import 'package:tac/routes/app_routes.dart';
import 'controllers/user_controller.dart';
import 'data/data/constants/app_theme.dart';
import './request_permissions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

// ✅ Top-level background handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // required in background isolate
  print("📩 Background message received: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request location permissions at app startup
  await requestPermissions();

  // ✅ Background handler registration
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // ✅ Initialize Local Notifications
  NotificationServices.requestNotificationPermission();
  NotificationServices.localNotiInit();

  // ✅ FCM Foreground & Terminated State
  NotificationHandlerController.initializeFCMHandlers();
  await NotificationHandlerController.handleTerminatedState();

  // ✅ Base Controllers
  Get.put(UserController(), permanent: true);

  
  // ✅ Check SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? biometricEnabled = prefs.getBool('biometric_login');
  bool liveLocationEnabled = prefs.getBool('live_location') ?? false;



  // ✅ Conditionally enable location
  if (liveLocationEnabled) {
    try {
      final location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }

      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
      }

      if (permission == PermissionStatus.granted && serviceEnabled) {
        Get.put(MapController(), permanent: true);
        debugPrint("📍 MapController initialized (Live Location ON)");
      } else {
        debugPrint("⚠️ Location permission denied or service off");
      }
    } catch (e) {
      debugPrint("⚠️ Auto-enable location failed: $e");
    }
  } else {
    Get.put(MapController(), permanent: true);
    debugPrint("📍 Live location disabled, MapController not initialized");
  }

  String initialRoute = AppRoutes.splashScreen;

  // ✅ Biometric Handling
  if (biometricEnabled == true) {
    bool authenticated = await _authenticateWithBiometrics();
    if (!authenticated) {
      initialRoute = AppRoutes.biometricLock;
    }
  }

  runApp(Main(initialRoute: initialRoute));
}

// ✅ Biometric Authentication Function
Future<bool> _authenticateWithBiometrics() async {
  final LocalAuthentication auth = LocalAuthentication();

  try {
    // Check if device supports biometrics
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    if (!canAuthenticate) {
      debugPrint('⚠️ Device does not support biometrics');
      return true; // Allow access if device doesn't support biometrics
    }

    // Authenticate
    final bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Please authenticate to access the app',
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

class Main extends StatelessWidget {
  final String initialRoute;
  const Main({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetMaterialApp(
        color: AppColors.kDarkBlue,
        title: 'TAC',
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        scrollBehavior: const ScrollBehavior()
            .copyWith(physics: const BouncingScrollPhysics()),
        defaultTransition: Transition.fadeIn,
        initialRoute: initialRoute,
        getPages: AppRoutes.routes,
        theme: ThemeData(
          fontFamily: GoogleFonts.outfit().fontFamily,
          textTheme: GoogleFonts.outfitTextTheme(),
          primaryTextTheme: GoogleFonts.outfitTextTheme(),
          useMaterial3: true,
        ),
      ),
    );
  }
}
