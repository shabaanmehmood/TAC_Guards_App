
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tac/modules/Guards/guards_view.dart';
import 'package:tac/modules/account/account.dart';
import 'package:tac/modules/auth/sign_up_view.dart';
import 'package:tac/modules/auth/sign_in_view.dart';
import 'package:tac/modules/landing_page/landing_page.dart';
import 'package:tac/modules/splashScreen/splashScreen.dart';

import '../modules/onboarding/onboarding_view.dart';

class AppRoutes {
  static String onboarding = '/onboarding';
  static String splashScreen = '/';
  // static String welcome = '/auth';
  static String signIn = '/sign-in';
  static String signUp = '/sign-up';
  static String landing = '/landing-page';
  static String settings = '/settings';
  static String profile = '/profile';
  static String guards = '/guards';

  static List<GetPage> routes = [
    GetPage<Route<dynamic>>(
      name: splashScreen,
      page: () =>SplashScreen(),
    ),
    GetPage<Route<dynamic>>(
      name: onboarding,
      page: () => OnboardingView(),
    ),
    // GetPage<Route<dynamic>>(
    //   name: welcome,
    //   page: () => WelcomeView(),
    // ),
    GetPage<Route<dynamic>>(
      name: signIn,
      page: () => SignInView(),
    ),
    GetPage<Route<dynamic>>(
      name: signUp,
      page: () => SignUpView(),
    ),
    GetPage<Route<dynamic>>(
      name: profile,
      page: () => const AccountScreen(),
    ),
    GetPage<Route<dynamic>>(
      name: guards,
      page: () => const GuardsView(),
    ),

    GetPage(
      name: landing,
      page: () => LandingPage(
        // Check if arguments were passed & extract selectedIndex if present, otherwise default to 0
        selectedIndex: (Get.arguments != null && Get.arguments['selectedIndex'] != null) ? Get.arguments['selectedIndex'] : 0,
      ),
    ),

    // GetPage<Route<dynamic>>(
    //   name: settings,
    //   page: () => const SettingsView(),
    // ),
  ];

  static String getOnboardingRoute() => onboarding;
  // static String getWelcomeRoute() => welcome;
  static String getSignInRoute() => signIn;
  static String getSignUpRoute() => signUp;
  static String getLandingPageRoute() => landing;
  static String getSettingPageRoute() => settings;
  static String getProfilePageRoute() => profile;
  static String getGuardsPageRoute() => guards;
}
