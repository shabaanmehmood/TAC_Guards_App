import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/modules/account/components/profile/document.dart';
import 'package:tac/modules/account/components/profile/personal_information.dart';
import 'package:tac/modules/account/components/profile/professional_information.dart';
import 'package:tac/widhets/common%20overlays/uploadFile_overlay.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../data/data/constants/app_assets.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../models/profileImages_model.dart';
import '../../../../models/userupdate_model.dart';
import 'profile_dummy_data.dart';
import 'package:tac/data/data/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final UserController userController = Get.put(UserController());
  

  @override
  void initState() {
    super.initState();
    // Fetch user data when the screen is initialized
    userController.getUserData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        title: const Text("Profile",
            style: TextStyle(color: AppColors.kWhite, fontSize: 20)),
        // centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kWhite),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Display Picture Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.kJobCardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Obx((){
                      //   final imagePath = userController.userData.value?.profileImages?.first.imageUrl;
                      //   final imageUrl = MyApIService.fullImageUrl(imagePath);
                      //   return Container(
                      //     width: 48,
                      //     height: 48,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(8),
                      //       image: DecorationImage(
                      //         image:  imageUrl != null
                      //             ? NetworkImage(imageUrl)
                      //             : AssetImage(AppAssets.kUserPicture) as ImageProvider,
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   );
                      // }),
                       Builder(
        builder: (_) {
          final profileImages = userController.userData.value?.profileImages;
          final mainImage = profileImages?.firstWhereOrNull((img) => img.isMain == true);
          final imageUrl = (mainImage?.imageUrl != null && mainImage!.imageUrl!.isNotEmpty)
              ? '${MyApIService.imageBaseUrl}/${mainImage.imageUrl}'
              : null;

          return Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: imageUrl != null
                    ? NetworkImage(imageUrl)
                    :  AssetImage(AppAssets.kUserPicture) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Display Picture',
                              style: TextStyle(
                                color: AppColors.kWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Upload a clear and recent profile picture (JPG, PNG, max: 5MB).',
                              style: TextStyle(
                                  color: AppColors.ktextlight, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final UploadFileController uploadFileController = Get.put(UploadFileController());
                          String? base64image = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true, showPickFileOption: false);
                          if (base64image != null) {
                            await uploadFileController.updateFile(base64image);
                          }
                        },
                        // onPressed: () {
                        //   showUploadFileBottomSheet(context, true, false);
                        // },
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            color: AppColors.kSkyBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Documents Section
                GestureDetector(
                  onTap: () => Get.to(() => DocumentScreen()),
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.kJobCardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.folder_open, color: AppColors.kSkyBlue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Documents',
                                style: TextStyle(
                                  color: AppColors.kWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Manage your files and documents',
                                style: TextStyle(
                                    color: AppColors.ktextlight, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: AppColors.kWhite),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Personal Info Section
                buildDualColumnInfoSection(
                  title: "Personal Information",
                  info: [
                    {"label": "Full Name", "value": userController.userData.value?.fullName ?? "-"},
                    {"label": "Email Address", "value": userController.userData.value?.email ?? "-"},
                    {"label": "Gender", "value": userController.userData.value?.gender ?? "-"},
                    {"label": "Date of Birth", "value": userController.userData.value?.dob ?? "-"},
                    {"label": "Contact Number", "value": userController.userData.value?.phone ?? "-"},
                    {"label": "Postal Code", "value": userController.userData.value?.postalCode ?? "-"},
                    {"label": "Residential Address", "value": userController.userData.value?.postalAddress ?? "-"},
                  ],
                  onEdit: () {
                    Get.to(() => const EditPersonalInfoScreen())?.then((_) {
                      userController.getUserData(); // Refresh user data
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Professional Info Section
                buildDualColumnInfoSection(
                  title: "Professional Information",
                  info: [
                    {"label": "Year of Experience", "value": userController.userData.value?.personalDetails?.yearsOfExperience.toString() ?? "-"},
                    {"label": "Level", "value": userController.userData.value?.level ?? "-"},
                    {
                      "label": "Security Licence Number",
                      "value": userController.userData.value?.personalDetails?.licenseNumber.toString() ?? "-"
                    },
                    {"label": "Licence Expiry Date", "value": userController.userData.value?.personalDetails?.licenseExpiryDate.toString() ?? '-'},
                    {"label": "ABN", "value": userController.userData.value?.personalDetails?.abn.toString() ?? "-"},
                    {"label": "Professional Badge", "value": userController.userData.value?.professionalBadge ?? "-"},
                    {
                      "label": "Preferred Work Location",
                      "value": userController.userData.value?.personalDetails?.preferredLocationAddresses.toString() ?? "-"
                    },
                  ],
                  // onEdit: () => Get.to(() => const EditProfessionalInfoScreen()),
                  onEdit: () {
                    Get.to(() => const EditProfessionalInfoScreen())?.then((_) {
                      userController.getUserData(); // Refresh user data
                    });
                  },
                )
              ],
            ),
          ),
      )
    );
  }

  Widget buildDualColumnInfoSection({
    required String title,
    required List<Map<String, String>> info,
    required VoidCallback onEdit,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.kWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: onEdit,
                child: const Text(
                  "Edit",
                  style: TextStyle(
                    color: AppColors.kSkyBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          for (int i = 0; i < info.length; i += 2)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: buildKeyValue(info[i])),
                const SizedBox(width: 12),
                if (i + 1 < info.length)
                  Expanded(child: buildKeyValue(info[i + 1])),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildKeyValue(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item["label"]!,
            style: const TextStyle(color: AppColors.ktextlight, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            item["value"]!,
            style: const TextStyle(
                color: AppColors.ktextlight,
                fontSize: 13,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
