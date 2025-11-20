import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';

import 'package:tac/modules/Guards/guards_view.dart';
import 'package:tac/modules/Jobs/myJobs_view.dart';
import 'package:tac/modules/Messages/messages.dart';
import 'package:tac/modules/account/account.dart';
import 'package:tac/modules/home/home_view.dart';

import '../jobApplications/my_jobs_view.dart';

class LandingPage extends StatefulWidget {
  final int selectedIndex; // <-- Add this

  const LandingPage({Key? key, this.selectedIndex = 0})
      : super(key: key); // <-- Accept in constructor

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late int _currentIndex;

  final List<Widget> _pages = [
    HomeView(),
    const GuardsView(),
    MyJobsView1(),
    MessagesScreen(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(LandingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        _currentIndex = widget.selectedIndex;
      });
    }
  }

  Widget _buildCustomBottomNav() {
    return Container(
      color: AppColors.kDarkBlue,
      height: Get.height * 0.08 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(
        top: AppSpacing.fiveVertical,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          _buildNavItem(0, AppAssets.kHome, 'Home'),
          _buildNavItem(1, AppAssets.kGuards, 'Find Jobs'),
          _buildNavItem(2, AppAssets.kJobs, 'My Jobs'),
          _buildNavItem(3, AppAssets.kMessages, 'Messages'),
          _buildNavItem(4, AppAssets.kAccount, 'Account'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: Material(
        color: AppColors.kDarkBlue, // Important: Set material background
        child: InkWell(
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          highlightColor: AppColors.kDarkBlue.withOpacity(0.1),
          splashColor: AppColors.kSkyBlue.withOpacity(0.2),
          child: Container(
            color: AppColors.kDarkBlue, // Ensure container background
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  color: isSelected ? AppColors.kSkyBlue : Colors.grey,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppColors.kSkyBlue : Colors.grey,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }
}
