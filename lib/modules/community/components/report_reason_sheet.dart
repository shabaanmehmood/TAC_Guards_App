import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';

/// Professional single-select report bottom sheet.
/// Uses the exact 4 backend report reasons:
/// - 'spam'
/// - 'harassment'
/// - 'unsafe'
/// - 'other'
Future<String?> showReportReasonSheet({
  BuildContext? context,
  String title = 'Report post',
}) async {
  String? selectedReason;

  final options = [
    {
      'value': 'spam',
      'title': 'Spam',
      'subtitle': 'Scams, deceptive links, or repetitive promotional content',
      'icon': Icons.mark_email_unread_outlined,
    },
    {
      'value': 'harassment',
      'title': 'Harassment',
      'subtitle': 'Disparaging, attacking, or intimidating another member',
      'icon': Icons.dangerous_outlined,
    },
    {
      'value': 'unsafe',
      'title': 'Unsafe',
      'subtitle': 'Dangerous acts, threats, violence, or unlawful conduct',
      'icon': Icons.shield_outlined,
    },
    {
      'value': 'other',
      'title': 'Other',
      'subtitle': 'Violates community professional policies',
      'icon': Icons.flag_outlined,
    },
  ];

  Widget buildSheet(BuildContext sheetCtx, StateSetter setSheetState) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        decoration: const BoxDecoration(
          color: AppColors.kJobCardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select a reason for reporting. Help keep the community safe.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              ...options.map((opt) {
                final isSelected = selectedReason == opt['value'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setSheetState(() {
                        selectedReason = opt['value'] as String;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.kSkyBlue.withValues(alpha: 0.14)
                            : Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.kSkyBlue
                              : Colors.white.withValues(alpha: 0.08),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.kSkyBlue.withValues(alpha: 0.25)
                                  : Colors.white.withValues(alpha: 0.06),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              opt['icon'] as IconData,
                              size: 19,
                              color: isSelected
                                  ? AppColors.kSkyBlue
                                  : Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opt['title'] as String,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.kSkyBlue
                                        : Colors.white,
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  opt['subtitle'] as String,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.85)
                                        : Colors.white.withValues(alpha: 0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.kSkyBlue
                                    : Colors.white38,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.kSkyBlue,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedReason != null
                              ? AppColors.kSkyBlue
                              : Colors.white.withValues(alpha: 0.12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                        onPressed: selectedReason != null
                            ? () => Navigator.pop(sheetCtx, selectedReason)
                            : null,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: selectedReason != null
                                ? Colors.white
                                : Colors.white38,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.kSkyBlue,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                        onPressed: () => Navigator.pop(sheetCtx),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.kSkyBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  if (context != null) {
    return await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setSheetState) => buildSheet(sheetCtx, setSheetState),
      ),
    );
  }

  return await Get.bottomSheet<String>(
    StatefulBuilder(
      builder: (ctx, setSheetState) => buildSheet(ctx, setSheetState),
    ),
    isScrollControlled: true,
  );
}
