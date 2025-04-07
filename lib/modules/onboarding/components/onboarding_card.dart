import 'package:flutter/material.dart';
import 'package:tac/data/data/constants/app_spacing.dart';

import '../../../data/data/constants/app_colors.dart';
import '../../../data/data/constants/app_typography.dart';
import '../../../models/onboarding.dart';

class OnboardingCard extends StatelessWidget {
  final Onboarding onboarding;
  const OnboardingCard({
    required this.onboarding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
              text: TextSpan(
                style: AppTypography.kBold24.copyWith(
                  fontSize: 28,
                  color: AppColors.kWhite, // Default color
                ),
                children: highlightText(onboarding.title),
              ),
          ),
        ),
      ],
    );
  }

  /// **Function to highlight specific words in blue**
  List<TextSpan> highlightText(String text) {
    final Map<String, Color> highlights = {
      "Security": AppColors.kSkyBlue,
      "Seamless": AppColors.kSkyBlue,
      "Booking": AppColors.kSkyBlue,
      "Verified Guards": AppColors.kSkyBlue,
    };

    List<TextSpan> spans = [];
    text.split(' ').forEach((word) {
      bool isHighlighted = highlights.keys.any((key) => key.contains(word));

      spans.add(
        TextSpan(
          text: "$word ",
          style: TextStyle(
            color: isHighlighted ? highlights[word] ?? AppColors.kSkyBlue : AppColors.kWhite,
          ),
        ),
      );
    });

    return spans;
  }
}
