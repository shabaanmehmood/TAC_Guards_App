import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/modules/Guards/guards_view.dart';
import 'package:tac/modules/Jobs/jobs_page.dart';
import 'package:tac/modules/Jobs/myJobs_view.dart';
import 'package:tac/modules/Messages/messages.dart';
import 'package:tac/modules/account/account.dart';
import 'package:tac/modules/account/components/Earning/earnings_screen.dart';
import 'package:tac/modules/home/home_view.dart';
import 'package:tac/modules/jobApplications/my_jobs_view.dart';

import '../../controllers/user_controller.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<Widget> _pages = [
    const HomeView(),
    const GuardsView(),
    // const JobsView(),
    MyJobsView1(),
    // EarningsScreen(),
    MessagesScreen(),
    const AccountScreen(),
    // const ChatsScreen(),
    // const CourseSchedule(),
    // const MyProfileView(),
  ];

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    // bool isDarkMode(BuildContext context) =>
    //     Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      extendBody: false,
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: Get.height * 0.08,
          padding: EdgeInsets.only(top: AppSpacing.fiveVertical),
          child: ClipRRect(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 10.0,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              backgroundColor: AppColors.kDarkBlue,
              selectedLabelStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.kSkyBlue,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 13, color: Colors.grey),
              selectedFontSize: 14,
              unselectedFontSize: 13,
              unselectedItemColor: Colors.grey,
              currentIndex: _currentIndex,
              selectedItemColor: AppColors.kSkyBlue,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kHome,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Home',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kHome,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kGuards,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Jobs',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kGuards,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kJobs,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'My Jobs',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kJobs,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kMessages,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Messages',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kMessages,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
                BottomNavigationBarItem(
                  backgroundColor: AppColors.kDarkBlue,
                  icon: SvgPicture.asset(
                    AppAssets.kAccount,
                    color: Colors.grey,
                    height: 20,
                    width: 20,
                  ),
                  label: 'Account',
                  activeIcon: SvgPicture.asset(
                    AppAssets.kAccount,
                    color: AppColors.kSkyBlue,
                    height: 20,
                    width: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
