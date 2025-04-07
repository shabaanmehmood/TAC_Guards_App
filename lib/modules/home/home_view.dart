import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/alerts/notification_view.dart';
import 'package:tac/modules/home/components/search_field.dart';

import '../../data/data/constants/app_colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(context),
            SizedBox(height: AppSpacing.tenVertical,),
            Expanded(
              child: Image.asset(
                AppAssets.kMapPicture,
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }

  int selectedIndex = 0;
}

Widget _appBar(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
    child: SizedBox(
      width: double.infinity, // Ensures full width
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents infinite height issue
        children: [
          Row(
            children: [
              Builder(
                builder: (BuildContext context) {
                  return Image.asset(
                    AppAssets.kTacHomeScreenLogo,
                    height: Get.height * 0.07,
                    width: Get.width * 0.25,
                    fit: BoxFit.contain,
                  );
                },
              ),
              const Spacer(),
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min, // Prevent infinite height
                    children: [
                      IconButton(
                        focusColor: AppColors.kPrimary,
                        color: AppColors.kPrimary,
                        icon: SvgPicture.asset(
                          width: 35,
                          height: 35,
                          AppAssets.kAlerts,
                        ),
                        onPressed: () {
                          Get.to<void>(() => NotificationScreen());
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // or 15.0
                child: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: Image.asset(AppAssets.kUserPicture),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.tenVertical),
          SearchField(
            isBorderBlue: false,
            text: 'Search for Security Guards',
            isIconColorBlue: false,
            icon2: AppAssets.kSearch,
          ),
        ],
      ),
    ),
  );
}

