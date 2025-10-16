import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tac/modules/Guards/guards_view.dart';
import 'package:tac/modules/account/account.dart';
import 'package:tac/modules/auth/sign_up_view.dart';
import 'package:tac/modules/auth/sign_in_view.dart';
import 'package:tac/modules/checkin/jobcheckin/job_status_error.dart';
import 'package:tac/modules/checkin/jobcheckin/job_status_screen.dart';
import 'package:tac/modules/checkin/jobcheckin/shift_close.dart';
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

  // Shift Flow Routes
  static String jobComplete = '/job-complete';
  static String jobError = '/job-error';
  static String closeShift = '/close-shift';
  static String nextJob = '/next-job';
  static String findJobs = '/find-jobs';

  static List<GetPage> routes = [
    GetPage<Route<dynamic>>(
      name: splashScreen,
      page: () => SplashScreen(),
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
        selectedIndex:
            (Get.arguments != null && Get.arguments['selectedIndex'] != null)
                ? Get.arguments['selectedIndex']
                : 0,
      ),
    ),

    // Shift Flow Routes
    GetPage<Route<dynamic>>(
      name: jobComplete,
      page: () => JobStatusScreenSuccess(),
    ),
    GetPage<Route<dynamic>>(
      name: jobError,
      page: () => JobStatusScreenError(),
    ),
    GetPage<Route<dynamic>>(
      name: closeShift,
      page: () => ShiftCloseBottomSheet(
          completionData: Get.arguments?['completionData']),
    ),
    GetPage<Route<dynamic>>(
      name: nextJob,
      page: () => LandingPage(selectedIndex: 0), // Navigate to jobs tab
    ),
    GetPage<Route<dynamic>>(
      name: findJobs,
      page: () => LandingPage(selectedIndex: 0), // Navigate to jobs tab
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

  // Shift Flow Route Getters
  static String getJobCompleteRoute() => jobComplete;
  static String getJobErrorRoute() => jobError;
  static String getCloseShiftRoute() => closeShift;
  static String getNextJobRoute() => nextJob;
  static String getFindJobsRoute() => findJobs;
}
