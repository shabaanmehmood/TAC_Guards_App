import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/modules/account/components/HELP%20AND%20SUPPORT/faqs.dart';
import 'package:tac/modules/account/components/HELP%20AND%20SUPPORT/report.dart';
import 'package:tac/modules/account/components/profile/HELP%20AND%20SUPPORT/dispute.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kWhite),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: AppColors.kWhite,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildHelpCard(
            icon: Icons.warning_amber_rounded,
            title: "Dispute",
            subtitle:
                "Tell us if you are facing any dispute with the client or job.",
            onTap: () {
              Get.to(() => DisputeScreen());
            },
          ),
          const SizedBox(height: 12),
          buildHelpCard(
            icon: Icons.report_gmailerrorred_outlined,
            title: "Report an Issue",
            subtitle:
                "Share your feedback if you have anything we can do to improve.",
            onTap: () {
              Get.to(() => ReportIssueScreen());
            },
          ),
          const SizedBox(height: 12),
          buildHelpCard(
            icon: Icons.question_answer_outlined,
            title: "FAQ",
            subtitle: "Manage your details",
            onTap: () {
              Get.to(() => FaqScreen());
            },
          ),
          const SizedBox(height: 12),
          buildHelpCard(
            icon: Icons.call_outlined,
            title: "24/7 Support",
            subtitle: "Manage your details",
            onTap: () {
              // Navigate to Support page
            },
          ),
          const SizedBox(height: 12),
          buildHelpCard(
            icon: Icons.email_outlined,
            title: "Email Us",
            subtitle: "Contact@tacsolution.com",
            onTap: () {
  //               final UserController userController = Get.put(UserController());
  // userController.userData.value?.email ?? "-"
            },
          ),
        ],
      ),
    );
  }

  Widget buildHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.kJobCardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 25, color: AppColors.kSkyBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.kWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.kinput,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.kWhite),
          ],
        ),
      ),
    );
  }
}
