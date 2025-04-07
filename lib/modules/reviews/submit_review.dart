import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/reviews/review_submitted.dart';
import 'package:tac/widhets/buttons/buttons/buttons.dart';

import '../../data/data/constants/app_assets.dart';
import '../../data/data/constants/app_colors.dart';
import '../../widhets/common widgets/buttons/TextFormFieldWidget.dart';

class SubmitReview extends StatelessWidget {

  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal, vertical: AppSpacing.twentyVertical),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _appBar(context),
              SizedBox(height: AppSpacing.tenVertical,),
              // Job Title & Per Hour Rate
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Security Escort for Actor - Airport to Residence',
                      softWrap: true,
                      style: AppTypography.kBold24.copyWith(color: AppColors.kWhite),
                    ),
                  ),
                  Text(
                    '\$28/hr',
                    style: AppTypography.kBold24.copyWith(
                        color: AppColors.kSkyBlue
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.fiveVertical),
              // Company Name
              Row(
                children: [
                  Text(
                    'Huge Jackman',
                    style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.tenVertical),
              // Day & Date
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        '24 March 2025',
                        style: AppTypography.kLight14.copyWith(
                            color: Colors.grey
                        ),
                      ),
                      const SizedBox(width: 20,),
                      const Icon(Icons.access_time, color: Colors.grey, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        '9:00 AM - 6:00 PM',
                        style: AppTypography.kLight14.copyWith(
                            color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.thirtyVertical),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rate this Job',
                  style: AppTypography.kBold20.copyWith(
                      color: AppColors.kWhite
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.fiveVertical),
              Align(
                alignment: Alignment.centerLeft,
                child: RatingBar.builder(
                  wrapAlignment: WrapAlignment.start,
                  glow: true,
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: AppSpacing.fiveHorizontal),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ),
              SizedBox(height: AppSpacing.thirtyVertical),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Write your review',
                  style: AppTypography.kBold20.copyWith(
                      color: AppColors.kWhite
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.tenVertical),
              CustomTextField(
                keyboardType: TextInputType.name,
                controller: reviewController,
                hintText: 'Share your experience with this job and employer',
                iconPath: AppAssets.kPen,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1000)
                ],
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Submit Review',
                onTap: (){
                  Get.to(() => ReviewSubmitted());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _appBar(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          GestureDetector(
            onTap: (){
              Get.back(
                canPop: true,
              );
            },
            child: SizedBox(
                height: 40.0,
                width: 40.0,
                child: Image.asset(AppAssets.kArrowBackward)
            ),
          ),
          SizedBox(width: AppSpacing.fiveHorizontal,),
          Text('Submit your Review', style: AppTypography.kBold18.copyWith(
            color: AppColors.kWhite
          ),)
        ],
      ),
      Divider(
        color: Colors.grey,
      ),
    ],
  );
}