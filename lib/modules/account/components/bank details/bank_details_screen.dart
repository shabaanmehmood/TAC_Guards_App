import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/models/bankDetails_model.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../routes/app_routes.dart';
import 'add_bank_details_screen.dart';

class BankDetailsScreen extends StatefulWidget {
  BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  late Future<List<BankDetails>> bankDetailsFuture;

  @override
  void initState() {
    super.initState();
    bankDetailsFuture = fetchBankDetails();
  }

  Future<List<BankDetails>> fetchBankDetails() async {
    final apiService = MyApIService();
    final userId = Get.find<UserController>().userData.value?.id ?? '';
    final response = await apiService.getBankDetailsWithParams({'userId': userId});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final dataList = jsonResponse['data'];
      if (dataList != null && dataList is List) {
        debugPrint('Bank details fetched successfully: ${dataList.length} items');
        debugPrint('Bank details: $dataList');
        return dataList.map<BankDetails>((json) => BankDetails.fromJson(json)).toList();
      }
      return [];
    } else {
      debugPrint('Failed to fetch bank details: ${response.statusCode}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kWhite),
        title: const Text('Bank Details', style: TextStyle(color: AppColors.kWhite)),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => AddBankDetailsScreen())?.then((value) {
                if (value == true) {
                  setState(() {
                    bankDetailsFuture = fetchBankDetails();
                  });
                }
              });
            },
            child: const Text('Add', style: TextStyle(color: AppColors.kSkyBlue)),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white24, height: 1),
        ),
      ),
      body: FutureBuilder<List<BankDetails>>(
        future: bankDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading bank details',
                style: TextStyle(color: Colors.white54),
              ),
            );
          } else {
            final bankList = snapshot.data ?? [];

            if (bankList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, color: Colors.white38, size: 64),
                    SizedBox(height: 12),
                    Text('No bank details found', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: bankList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final bank = bankList[index];
                  return buildBankCard(
                    context,
                    bank.bankName ?? 'Bank Name',
                    bank.accountNumber ?? 'Account Number',
                    bank.accountTitle ?? 'Account Title',
                    bank.entityDate ?? 'Expiry Date',
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildBankCard(
      BuildContext context,
      String bankName,
      String accountNumber,
      String accountTitle,
      String expiryDate,
      ) {
    return Stack(
      children: [
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [AppColors.kSkyBlue, AppColors.kPrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    bankName,
                    style: const TextStyle(
                      color: AppColors.kWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.account_balance, color: AppColors.kWhite, size: 28),
                  InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => Container(
                decoration: const BoxDecoration(
                  color: AppColors.kDarkBlue,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ListTile(
                    //   leading: const Icon(Icons.edit, color: AppColors.kWhite),
                    //   title: const Text('Edit', style: TextStyle(color: AppColors.kWhite)),
                    //   onTap: () {
                    //     Get.back();
                    //     Get.snackbar('Edit', 'Edit feature coming soon',
                    //         snackPosition: SnackPosition.BOTTOM,
                    //         backgroundColor: AppColors.kgrey,
                    //         colorText: AppColors.kWhite);
                    //   },
                    // ),
                    ListTile(
                      leading: const Icon(Icons.delete_outline, color: AppColors.kRed),
                      title: const Text('Delete', style: TextStyle(color: AppColors.kRed)),
                      onTap: () {

                      },
                    ),
                  ],
                ),
              ),
            ),
            child: const Icon(Icons.more_vert, color: Colors.white70),
          ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                accountNumber,
                style: const TextStyle(
                  color: AppColors.kWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("VALID",
                              style: TextStyle(
                                  color: AppColors.ktextlight,
                                  fontSize: 10,
                                  letterSpacing: 1)),
                          const Text("THRU",
                              style: TextStyle(
                                  color: AppColors.ktextlight,
                                  fontSize: 10,
                                  letterSpacing: 1)),
                          const SizedBox(height: 4),
                          Text(
                            expiryDate,
                            style: const TextStyle(
                              color: AppColors.kWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    accountTitle,
                    style: const TextStyle(
                      color: AppColors.kWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Positioned(
        //   top: 12,
        //   right: 12,
        //   child: InkWell(
        //     onTap: () => showModalBottomSheet(
        //       context: context,
        //       backgroundColor: Colors.transparent,
        //       builder: (_) => Container(
        //         decoration: const BoxDecoration(
        //           color: AppColors.kDarkBlue,
        //           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        //         ),
        //         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             // ListTile(
        //             //   leading: const Icon(Icons.edit, color: AppColors.kWhite),
        //             //   title: const Text('Edit', style: TextStyle(color: AppColors.kWhite)),
        //             //   onTap: () {
        //             //     Get.back();
        //             //     Get.snackbar('Edit', 'Edit feature coming soon',
        //             //         snackPosition: SnackPosition.BOTTOM,
        //             //         backgroundColor: AppColors.kgrey,
        //             //         colorText: AppColors.kWhite);
        //             //   },
        //             // ),
        //             ListTile(
        //               leading: const Icon(Icons.delete_outline, color: AppColors.kRed),
        //               title: const Text('Delete', style: TextStyle(color: AppColors.kRed)),
        //               onTap: () {

        //               },
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     child: const Icon(Icons.more_vert, color: Colors.white70),
        //   ),
        // ),
      ],
    );
  }
}
