// transaction.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../data/data/constants/app_assets.dart';
import '../../../../data/data/constants/app_colors.dart';
import '../../../../data/data/constants/app_spacing.dart';
import '../../../../data/data/constants/app_typography.dart';
import '../../../../models/earning_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Payment payment;

  const TransactionDetailsScreen({Key? key, required this.payment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(AppAssets.kBack,
              color: AppColors.kWhite, height: 30, width: 30),
          onPressed: () => Get.back(),
        ),
        title: Text('Transaction Details',
            style: AppTypography.kBold20.copyWith(color: AppColors.kWhite)),
      ),
      body: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSpacing.twentyVertical),
              padding: EdgeInsets.all(AppSpacing.fifteenHorizontal),
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text('Bank: ${payment.bankName}',
                      style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                  Text('Account: ${payment.accountNumber}',
                      style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                  Text('Reference: ${payment.reference}',
                      style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => Get.toNamed('/jobDetails'),
                    child: Text('Job Details',
                        style: AppTypography.kBold14.copyWith(
                            color: AppColors.kPrimary,
                            decoration: TextDecoration.underline)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('#${payment.id}',
                          style: AppTypography.kLight14
                              .copyWith(color: AppColors.kgrey)),
                      const Spacer(),
                      GestureDetector(
                          child: const Icon(Icons.copy, color: AppColors.kWhite, size: 16),
                          onTap: () => Clipboard.setData(ClipboardData(text: payment.id)).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(
                                  'Payment ID copied to clipboard')),
                            );
                          }
                          )
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('\$${double.parse(payment.amount).toStringAsFixed(2)}',
                      style: AppTypography.kBold24
                          .copyWith(color: AppColors.kPrimary)),
                ],
              ),
            ),
            Text('Screenshot',
                style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
            const SizedBox(height: 10),
            Container(
              height: Get.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.kJobCardColor,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.tenHorizontal),
                  child: Image.asset('assets/apple.png', fit: BoxFit.contain),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                  EdgeInsets.symmetric(vertical: AppSpacing.fifteenVertical),
                ),
                child: Text('Close',
                    style:
                    AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}