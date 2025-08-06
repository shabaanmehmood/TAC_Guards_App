import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/dataproviders/notification_services/notification_handler.dart';
import 'package:tac/dataproviders/notification_services/notification_services.dart';
import 'package:tac/firebase_options.dart';
import 'package:tac/routes/app_routes.dart';
import 'controllers/user_controller.dart';
import 'data/data/constants/app_theme.dart';

// Future<String> getInitialRoute() async {
//   final prefs = await SharedPreferences.getInstance();
//   final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//   final loginTime = prefs.getInt('loginTime');
//
//   if (!isLoggedIn || loginTime == null) {
//     return AppRoutes.getOnboardingRoute(); // User not logged in
//   }
//
//   final now = DateTime.now().millisecondsSinceEpoch;
//   if (now - loginTime < 4 * 60 * 60 * 1000) {
//     return AppRoutes.getLandingPageRoute(); // User logged in and session valid
//   } else {
//     // Session expired, clear stored session
//     await prefs.remove('isLoggedIn');
//     await prefs.remove('loginTime');
//     return AppRoutes.getOnboardingRoute();
//   }
// }


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

  
  // ✅ Background handler registration MUST be BEFORE runApp()
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

  Get.put(UserController(), permanent: true);
  // final initialRoute = await getInitialRoute();
  // runApp(Main(initialRoute: initialRoute,));
  runApp(
    Main(
      initialRoute: AppRoutes.splashScreen,
    ),
  );
}

class Main extends StatelessWidget {
  final String initialRoute;
  Main({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // final themeController = Get.put(ThemeController());
    // debugPrint(themeController.theme);
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
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        scrollBehavior: const ScrollBehavior()
            .copyWith(physics: const BouncingScrollPhysics()),
        defaultTransition: Transition.fadeIn,
        // theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        // themeMode: getThemeMode(themeController.theme),
        // initialRoute: AppRoutes.getOnboardingRoute(),
        initialRoute: AppRoutes.splashScreen,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
