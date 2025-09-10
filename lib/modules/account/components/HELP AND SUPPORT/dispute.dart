import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/dataproviders/api_service.dart';
import 'package:tac/models/job_model.dart';

class DisputeController extends GetxController {
  final selectedDisputeType = ''.obs;
  final agreeToTerms = false.obs;
  final jobsList = <JobData>[].obs;
  final selectedJobId = ''.obs;
  final selectedJobTitle = ''.obs;
  final isLoadingJobs = false.obs;

  static const List<String> disputeTypes = [
    'Job Related',
    'Earning Related',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoadingJobs.value = true;
      final apiService = MyApIService();
      
      final response = await apiService.getJobsList();
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final dataList = json['data'] as List;
        
        jobsList.value = dataList.map((jobJson) => JobData.fromJson(jobJson)).toList();
        debugPrint('Jobs fetched successfully: ${jobsList.length} jobs');
      } else {
        debugPrint('Error fetching jobs: ${response.statusCode} - ${response.body}');
        jobsList.clear();
      }
      
    } catch (e) {
      debugPrint('Error fetching jobs: ${e.toString()}');
      jobsList.clear();
    } finally {
      isLoadingJobs.value = false;
    }
  }
}

class DisputeScreen extends StatelessWidget {
  DisputeScreen({super.key});

  final DisputeController controller = Get.put(DisputeController());
  final TextEditingController issueController = TextEditingController();
  final TextEditingController transactionIdController = TextEditingController();
  final TextEditingController transactionDateController = TextEditingController();
  final TextEditingController disputeAmountController = TextEditingController();

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
          'Dispute',
          style: TextStyle(
              color: AppColors.ktextlight,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Details",
                        style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    
                    // Dispute Type Field - Completely wrapped in Material for better tap detection
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          debugPrint("=== DISPUTE TYPE TAPPED ===");
                          _showDisputeTypeBottomSheet(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: _buildInputField(
                            icon: Icons.warning_amber_rounded,
                            hint: controller.selectedDisputeType.value.isEmpty
                                ? 'Select Dispute Type'
                                : controller.selectedDisputeType.value,
                            isDropdown: true,
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.kPrimary),
                    const SizedBox(height: 16),
                    
                    // Job Selection Field - Same approach
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          debugPrint("=== JOB SELECTION TAPPED ===");
                          _showJobSelectionBottomSheet(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: _buildInputField(
                            icon: Icons.work_outline,
                            hint: controller.selectedJobTitle.value.isEmpty
                                ? 'Select Job'
                                : controller.selectedJobTitle.value,
                            isDropdown: true,
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.kPrimary),
                    const SizedBox(height: 16),
                    
                    _buildInputField(
                        icon: Icons.calendar_today_outlined,
                        hint: "Date of Incident"),
                    const Divider(color: AppColors.kPrimary),
                    const SizedBox(height: 16),
                    _buildInputField(
                        icon: Icons.edit_outlined,
                        hint: "Please describe your issue in detail.",
                        controller: issueController,
                        maxLines: null),
                    const Divider(color: AppColors.kPrimary),
                    if (controller.selectedDisputeType.value == 'Earning Related') ...[
                      const SizedBox(height: 24),
                      const Text("Transaction Information",
                          style: TextStyle(
                              color: AppColors.kWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildInputField(
                          icon: Icons.numbers,
                          hint: "Enter transaction ID",
                          controller: transactionIdController),
                      const Divider(color: AppColors.kPrimary),
                      const SizedBox(height: 16),
                      _buildInputField(
                          icon: Icons.calendar_month,
                          hint: "Transaction Date",
                          controller: transactionDateController),
                      const Divider(color: AppColors.kPrimary),
                      const SizedBox(height: 16),
                      _buildInputField(
                          icon: Icons.attach_money,
                          hint: "Dispute Amount",
                          controller: disputeAmountController),
                      const Divider(color: AppColors.kPrimary),
                    ],
                    const SizedBox(height: 24),
                    const Text("Supporting Documents",
                        style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.kJobCardColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Attach Doc",
                                    style: TextStyle(
                                        color: AppColors.kWhite,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text(
                                    "Min 10MB. Upload only PDF, DOC, DOCX, JPG, PNG",
                                    style: TextStyle(
                                        color: AppColors.kinput, fontSize: 9)),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Browse",
                                style: TextStyle(color: AppColors.kSkyBlue)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  color: AppColors.kDarkestBlue,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(color: AppColors.kinput),
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: controller.agreeToTerms.value,
                                onChanged: (value) =>
                                    controller.agreeToTerms.value = value!,
                                activeColor: AppColors.kSkyBlue,
                              )),
                          const Expanded(
                            child: Text(
                                "I agree to the terms and conditions and confirm that all information provided is accurate",
                                style: TextStyle(
                                    color: AppColors.kinput, fontSize: 10.5)),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.transparent,
                                side: const BorderSide(color: AppColors.kSkyBlue),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => Get.back(),
                              child: const Text('Close',
                                  style: TextStyle(
                                      color: AppColors.kSkyBlue, fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 6,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: AppColors.kSkyBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                debugPrint("=== SUBMIT BUTTON TAPPED ===");
                                Get.snackbar('Info', 'Submit functionality not implemented yet');
                              },
                              child: const Text('Submit Dispute',
                                  style: TextStyle(color: AppColors.kDarkBlue)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  void _showDisputeTypeBottomSheet(BuildContext context) {
    debugPrint("=== SHOWING DISPUTE TYPE BOTTOM SHEET ===");
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kDarkBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return Obx(() => Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Dispute Type',
                            style: TextStyle(
                                color: AppColors.kWhite,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.kinput),
                  ...DisputeController.disputeTypes.map((type) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Radio<String>(
                            value: type,
                            groupValue: controller.selectedDisputeType.value,
                            onChanged: (value) {
                              debugPrint("=== DISPUTE TYPE SELECTED: $value ===");
                              controller.selectedDisputeType.value = value!;
                              Navigator.pop(context);
                            },
                            activeColor: AppColors.kSkyBlue,
                          ),
                          title: Text(type,
                              style: const TextStyle(color: AppColors.kWhite)),
                          onTap: () {
                            debugPrint("=== DISPUTE TYPE LIST ITEM TAPPED: $type ===");
                            controller.selectedDisputeType.value = type;
                            Navigator.pop(context);
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: AppColors.kPrimary),
                        ),
                      ],
                    );
                  }).toList()
                ],
              ),
            ));
      },
    );
  }

  void _showJobSelectionBottomSheet(BuildContext context) {
    debugPrint("=== SHOWING JOB SELECTION BOTTOM SHEET ===");
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kDarkBlue,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return Obx(() => Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Job',
                            style: TextStyle(
                                color: AppColors.kWhite,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.kinput),
                  
                  if (controller.isLoadingJobs.value) ...[
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.kSkyBlue,
                        ),
                      ),
                    ),
                  ] else if (controller.jobsList.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.work_off_outlined,
                            color: AppColors.kinput,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No Jobs Available',
                            style: TextStyle(
                              color: AppColors.kWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'You don\'t have any jobs to dispute at the moment.',
                            style: TextStyle(
                              color: AppColors.kinput,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              debugPrint("=== REFRESH JOBS TAPPED ===");
                              controller.fetchJobs();
                            },
                            child: const Text(
                              'Refresh',
                              style: TextStyle(
                                color: AppColors.kSkyBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.jobsList.length,
                        itemBuilder: (context, index) {
                          final job = controller.jobsList[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: Radio<String>(
                                  value: job.id,
                                  groupValue: controller.selectedJobId.value,
                                  onChanged: (value) {
                                    debugPrint("=== JOB SELECTED: ${job.title} ===");
                                    controller.selectedJobId.value = value!;
                                    controller.selectedJobTitle.value = job.title;
                                    Navigator.pop(context);
                                  },
                                  activeColor: AppColors.kSkyBlue,
                                ),
                                title: Text(
                                  job.title,
                                  style: const TextStyle(color: AppColors.kWhite),
                                ),
                                subtitle: job.description != null ? Text(
                                  job.description!,
                                  style: const TextStyle(color: AppColors.kinput, fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ) : null,
                                onTap: () {
                                  debugPrint("=== JOB LIST ITEM TAPPED: ${job.title} ===");
                                  controller.selectedJobId.value = job.id;
                                  controller.selectedJobTitle.value = job.title;
                                  Navigator.pop(context);
                                },
                              ),
                              if (index < controller.jobsList.length - 1)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Divider(color: AppColors.kinput),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ));
      },
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    TextEditingController? controller,
    bool readOnly = false,
    int? maxLines,
    bool isDropdown = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Icon(icon, color: AppColors.kSkyBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly || isDropdown, // Make dropdown fields read-only
            style: const TextStyle(color: AppColors.kWhite, fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.kinput, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              isDense: true,
              suffixIcon: isDropdown
                  ? const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.kinput)
                  : null,
            ),
          ),
        )
      ],
    );
  }
}

class DisputeScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DisputeScreen();
  }
}