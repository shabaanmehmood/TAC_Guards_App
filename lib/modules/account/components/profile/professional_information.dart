import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../models/userupdate_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widhets/common widgets/buttons/adaptive_dialogue.dart';

class EditProfessionalInfoScreen extends StatefulWidget {
  const EditProfessionalInfoScreen({super.key});

  @override
  State<EditProfessionalInfoScreen> createState() =>
      _EditProfessionalInfoScreenState();
}

class _EditProfessionalInfoScreenState
    extends State<EditProfessionalInfoScreen> {
  final UserController userController = Get.find<UserController>();

  int? selectedExperience;
  final TextEditingController licenseNumber = TextEditingController();
  final TextEditingController expiryDate = TextEditingController();
  final TextEditingController abnNumber = TextEditingController();
  final TextEditingController preferredWorkLocation = TextEditingController();

  Future<void> updateProfessionalInfo() async {
    final apiService = MyApIService(); // create instance
    try {
      final userModel = UserUpdateModel(
        yearsOfExperience: selectedExperience,
        licenseNumber: licenseNumber.text,
        licenseExpiryDate: expiryDate.text,
        abn: abnNumber.text,
        preferredLocationAddresses: preferredWorkLocation.text.isNotEmpty
            ? [preferredWorkLocation.text]
            : null, // or [] for empty list
      );

      final response = await apiService.updatePersonalInfo(
        userController.userData.value!.id!,
        userModel,
      );

      if (response.statusCode == 200) {
        debugPrint("data from API ${response.body}");
        await apiService.getUserByID(userController.userData.value!.id!);
        Get.back(result: true);
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String errorMessage = responseBody['message'] ?? 'Unknown error';

        // Show dialog with one line call
        await AdaptiveAlertDialogWidget.show(
          context,
          title: 'Update Failed',
          content: errorMessage,
          yesText: 'OK',
          showNoButton: false,
          onYes: () {
            // Optional: do something on OK pressed
          },
        );
        debugPrint("data from API ${response.body}");
        debugPrint("data from API ${response.body}");
        debugPrint('Error update professional info failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error Network error: ${e.toString()}');
    }
  }

  Future<String?> selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.kSkyBlue,
              onPrimary: AppColors.kBlack,
              surface: AppColors.kDarkestBlue,
              onSurface: AppColors.kWhite,
            ),
            dialogBackgroundColor: AppColors.kDarkestBlue,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      expiryDate.text = formattedDate;
      return formattedDate;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    final userData = userController.userData.value;
    selectedExperience = userData!.personalDetails?.yearsOfExperience;
    licenseNumber.text = userData!.masterSecurityLicense ?? '';
    expiryDate.text = userData!.personalDetails?.licenseExpiryDate ?? '';
    abnNumber.text = userData!.personalDetails?.abn ?? '';
    preferredWorkLocation.text = userController
            .userData.value?.personalDetails?.preferredLocationAddresses
            ?.join(", ") ?? // Join with comma and space
        "-";
  }

  @override
  void dispose() {
    super.dispose();
    licenseNumber.dispose();
    expiryDate.dispose();
    abnNumber.dispose();
    preferredWorkLocation.dispose();
  }

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
          'Edit Professional Information',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update information according to your official document data.',
                    style: TextStyle(
                      color: AppColors.kWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Years of Experience Dropdown
                  buildDropdownField(
                      label: 'Years of Experience', icon: Icons.work),

                  const SizedBox(height: 14),
                  buildTextField(
                    label: 'License Number',
                    iconPath: AppAssets.klicense,
                    controller: licenseNumber,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                  const SizedBox(height: 14),
                  buildTextField(
                    label: 'Expiry Date',
                    iconPath: AppAssets.kCal,
                    controller: expiryDate,
                    isDate: true,
                  ),
                  const SizedBox(height: 14),
                  buildTextField(
                    label: 'ABN',
                    iconPath: AppAssets.kAbn,
                    controller: abnNumber,
                    maxLength: 20,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  buildTextField(
                    label: 'Preferred Work Location Address',
                    iconPath: AppAssets.kLoc,
                    controller: preferredWorkLocation,
                    inputFormatters: [LengthLimitingTextInputFormatter(180)],
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.kinput, thickness: 1),
          Container(
            color: AppColors.kDarkestBlue,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Row(
              children: [
                Expanded(
                  flex: 25,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.kSkyBlue),
                      foregroundColor: AppColors.kSkyBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 75,
                  child: ElevatedButton(
                    onPressed: () => {
                      updateProfessionalInfo(),
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kSkyBlue,
                      foregroundColor: AppColors.kBlack,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Update Information'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    String? iconPath,
    IconData? icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isDate = false,
    int? maxLength,
  }) {
    return GestureDetector(
      onTap: isDate ? () => selectExpiryDate(context) : null,
      child: AbsorbPointer(
        absorbing: isDate,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
          decoration: InputDecoration(
            labelText: label,
            labelStyle:
                AppTypography.kLight14.copyWith(color: AppColors.kinput),
            counterText: "",
            prefixIcon: iconPath != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      iconPath,
                      width: 24,
                      height: 24,
                      color: AppColors.kinput,
                    ),
                  )
                : Icon(icon, color: AppColors.kinput),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.kinput),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.kSkyBlue),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField({required String label, required IconData icon}) {
    return DropdownButtonFormField<String>(
      dropdownColor: const Color(0xFF1F2937),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.kinput),
        prefixIcon: Icon(icon, color: AppColors.kinput),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kinput),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
      ),
      style: const TextStyle(color: AppColors.kWhite),
      iconEnabledColor: AppColors.kinput,
      value: selectedExperience?.toString(),
      items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '10+']
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedExperience = int.tryParse(value!);
        });
      },
    );
  }
}
