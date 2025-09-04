// earnings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/modules/account/components/Earning/transcation.dart';

import '../../../../data/data/constants/app_spacing.dart';
import '../../../../data/data/constants/app_typography.dart';
import 'earnings_controller.dart';

class EarningsScreen extends StatelessWidget {
  final EarningsController controller = Get.put(EarningsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: Column(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.twentyHorizontal,
                    vertical: AppSpacing.tenVertical,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: AppColors.kWhite),
                        onPressed: () => Get.back(),
                      ),
                      SizedBox(width: AppSpacing.tenHorizontal),
                      Text('Earnings',
                          style: AppTypography.kBold20
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
                Divider(color: AppColors.kinput),
              ],
            ),
          ),

          // ---- Earnings Card ----
// ---- Earnings Card ----
          Container(
            margin: EdgeInsets.only(
              top: AppSpacing.twentyFiveHorizontal,
              left: AppSpacing.twentyFiveHorizontal,
              right: AppSpacing.twentyFiveHorizontal,
            ),
            padding: EdgeInsets.all(AppSpacing.twentyHorizontal),
            decoration: BoxDecoration(
              color: AppColors.kDarkestBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.kinput, width: 1),
            ),
            child: Obx(() {
              final guard = controller.earningsData.value?.guard;
              final balance = double.tryParse(guard?.totalBalance ?? '0.0') ?? 0.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Balance",
                              style: AppTypography.kLight14
                                  .copyWith(color: AppColors.ktextlight)),
                          const SizedBox(height: 6),
                          Text("\$${balance.toStringAsFixed(2)}",
                              style: AppTypography.kBold32
                                  .copyWith(color: AppColors.kPrimary)),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          // ---- Filter Chips (CUSTOM CHIP REMOVED) ----
          Obx(() {
            final chips = <Widget>[];
            if (controller.selectedClient.value != null) {
              chips.add(_buildChip(controller.selectedClient.value!, () {
                controller.clearFilters();
              }));
            }
            if (controller.startDate.value != null) {
              chips.add(_buildChip(
                  controller.startDate.value!.toString().split(' ')[0], () {
                controller.clearFilters();
              }));
            }
            if (controller.endDate.value != null) {
              chips.add(_buildChip(
                  controller.endDate.value!.toString().split(' ')[0], () {
                controller.clearFilters();
              }));
            }

            if (chips.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ...chips,
                  ActionChip(
                    label: const Text("Clear All"),
                    onPressed: () => controller.clearFilters(),
                  ),
                ],
              ),
            );
          }),

          // ---- Tabs (only 3 buttons now) ----
          SizedBox(height: AppSpacing.twentyVertical),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {   // 3 instead of 4
                  bool isSelected = controller.selectedIndex.value == index;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => controller.selectIndex(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.fiveVertical),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.kPrimary
                                : Colors.transparent,
                            border: Border.all(color: AppColors.kgrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            ["This Week", "Last Week", "All"][index],
                            style: AppTypography.kBold14.copyWith(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.ktextlight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),

          // ---- Recent Earnings Header ----
          SizedBox(height: AppSpacing.fifteenVertical),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Recent Earnings",
                    style: AppTypography.kBold18.copyWith(color: Colors.white)),
              ],
            ),
          ),

          // ---- Payments List ----
          Expanded(
            child: Obx(() {
              final payments = controller.currentPayments;
              if (payments.isEmpty) {
                return Center(
                  child: Text("No data available",
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kWhite)),
                );
              }
              return ListView.builder(
                itemCount: payments.length,
                itemBuilder: (_, index) {
                  final p = payments[index];
                  return GestureDetector(
                    onTap: () =>
                        Get.to(() => TransactionDetailsScreen(payment: p)),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: AppSpacing.tenVertical,
                        horizontal: AppSpacing.twentyHorizontal,
                      ),
                      padding: EdgeInsets.all(AppSpacing.fifteenHorizontal),
                      decoration: BoxDecoration(
                        color: AppColors.kJobCardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.contractor.name,
                              style: AppTypography.kBold16
                                  .copyWith(color: AppColors.kWhite)),
                          SizedBox(height: AppSpacing.fiveVertical),
                          Text(p.paymentDate,
                              style: AppTypography.kLight14
                                  .copyWith(color: AppColors.ktextlight)),
                          SizedBox(height: AppSpacing.fiveVertical),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("N/A",
                                  style:
                                  TextStyle(color: AppColors.ktextlight)),
                              Text(
                                  "\$${double.parse(p.amount).toStringAsFixed(2)}",
                                  style: AppTypography.kBold16
                                      .copyWith(color: AppColors.kWhite)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label,
          style: AppTypography.kBold14
              .copyWith(fontSize: 10, color: AppColors.kDarkestBlue)),
      backgroundColor: AppColors.kSkyBlue,
      deleteIcon: const Icon(Icons.close, color: Colors.white),
      onDeleted: onRemove,
    );
  }
}