// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tac/data/data/constants/app_assets.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'package:tac/modules/account/components/License/add_license_screen.dart';
//
// import '../../controllers/user_controller.dart';
// import '../../dataproviders/api_service.dart';
// import '../../models/profileImages_model.dart';
// import '../../models/userupdate_model.dart';
// import '../../routes/app_routes.dart';
//
// class UploadFileController extends GetxController {
//   final ImagePicker imagePicker = ImagePicker();
//   final UserController userController = Get.find<UserController>();
//   final AddLicenseController addLicenseController = Get.put(AddLicenseController());
//
//   Future<void> updateFile(String base64Image) async {
//     final apiService = MyApIService();
//
//     try {
//       final userModel = UserUpdateModel(
//         profileImages: [
//           ProfileImages(
//             imageUrl: base64Image,
//             isMain: true,
//             // createdDate: DateTime.now().toString(),
//           ),
//         ],
//       );
//
//       final response = await apiService.updatePersonalInfo(
//         userController.userData.value!.id!,
//         userModel,
//       );
//
//       if (response.statusCode == 200) {
//         debugPrint("Data from API: ${response.body}");
//         final userdata = await apiService.getUserByID(userController.userData.value!.id!);
//         debugPrint('Raw user response: ${userdata.body}');
//         Get.offAndToNamed(AppRoutes.getLandingPageRoute());
//       } else {
//         debugPrint("Error response: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint('Network error: ${e.toString()}');
//     }
//   }
//
//   Future<void> uploadDocument(String filePath) async {
//     final apiService = MyApIService();
//
//     try {
//       final response = await apiService.uploadFile(
//         userController.userData.value!.id!,
//         addLicenseController.selectedLicenseType,
//         filePath,
//       );
//
//       if (response.statusCode == 201) {
//         debugPrint("Document uploaded successfully");
//         await apiService.getUserByID(userController.userData.value!.id!);
//         Get.offAndToNamed(AppRoutes.getProfilePageRoute());
//       } else {
//         final responseBody = await response.stream.bytesToString();
//         debugPrint("Upload failed: $responseBody");
//       }
//     } catch (e) {
//       debugPrint('Network error: ${e.toString()}');
//     }
//   }
// }
//
//   Future<String?> uploadFromGallery(bool base64conversion) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       File imageFile = File(image.path);
//       final imagePath = image.path;
//       if(base64conversion){
//         List<int> imageBytes = await imageFile.readAsBytes();
//         String base64Image = base64Encode(imageBytes);
//
//         if (kDebugMode) {
//           print('Camera image base64: $base64Image');
//         }
//
//         return base64Image;
//       }
//       else{
//         return imagePath;
//       }
//     } else {
//       if (kDebugMode) {
//         print('No image captured from camera.');
//       }
//       return null;
//     }
//   }
//
//   Future<String?> uploadFromCamera(bool base64conversion) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);
//
//     if (image != null) {
//       File imageFile = File(image.path);
//       final imagePath = image.path;
//       if(base64conversion){
//         List<int> imageBytes = await imageFile.readAsBytes();
//         String base64Image = base64Encode(imageBytes);
//
//         if (kDebugMode) {
//           print('Camera image base64: $base64Image');
//         }
//
//         return base64Image;
//       }
//       else{
//         return imagePath;
//       }
//     } else {
//       if (kDebugMode) {
//         print('No image captured from camera.');
//       }
//       return null;
//     }
//   }
//
//   String? base64Image;
//
//   void showUploadFileBottomSheet(BuildContext context, bool base64conversion, bool uploadFileAPI) {
//     final UploadFileController controller = Get.put(UploadFileController());
//     showModalBottomSheet(
//       context: context,
//       enableDrag: true,
//       isDismissible: true,
//       useSafeArea: true,
//       isScrollControlled: true,
//       backgroundColor: AppColors.kDarkBlue,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Divider(
//                 color: Colors.grey,
//                 thickness: 5,
//                 indent: 140,
//                 endIndent: 140,
//               ),
//               // Title & Done Button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Upload File",
//                     style: AppTypography.kBold18.copyWith(
//                         color: AppColors.kWhite
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => Get.back(),
//                     child: Text("Close", style: AppTypography.kBold16.copyWith(
//                       color: AppColors.kSkyBlue,
//                     )),
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSpacing.tenVertical),
//               // Sorting Options
//               _buildUploadOption("Upload from Gallery", () async {
//                 base64Image = await uploadFromGallery(base64conversion);
//                 if (base64Image != null) {
//                   debugPrint('Base64 Image: $base64Image');
//                   uploadFileAPI == true
//                       ? await controller.uploadDocument(base64Image!)
//                       : await controller.updateFile(base64Image!);
//                 }
//               }),
//               Divider(color: AppColors.kSkyBlue),
//               _buildUploadOption("Upload from Camera", () async {
//                 base64Image = await uploadFromCamera(base64conversion);
//                 if (base64Image != null) {
//                   debugPrint('Base64 Image: $base64Image');
//                   uploadFileAPI == true
//                       ? await controller.uploadDocument(base64Image!)
//                       : await controller.updateFile(base64Image!);
//                 }
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildUploadOption(String option, Function()? onTap) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(option, style: TextStyle(color: Colors.white)),
//           leading: Icon(
//             Icons.file_copy_outlined,
//             color: AppColors.kSkyBlue,
//           ),
//           onTap: onTap,
//         ),
//       ],
//     );
//   }

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart'; // ✅ added
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/account/components/License/add_license_screen.dart';

import '../../controllers/user_controller.dart';
import '../../dataproviders/api_service.dart';
import '../../models/profileImages_model.dart';
import '../../models/userupdate_model.dart';
import '../../routes/app_routes.dart';
import 'package:mime/mime.dart';

class UploadFileController extends GetxController {
  final ImagePicker imagePicker = ImagePicker();
  final UserController userController = Get.find<UserController>();
  final AddLicenseController addLicenseController =
      Get.put(AddLicenseController());

  bool _isSupportedMimeType(String? mimeType) {
    return mimeType != null &&
        (mimeType == 'image/jpeg' ||
            mimeType == 'image/jpg' ||
            mimeType == 'image/png' ||
            mimeType == 'application/pdf');
  }

  /// ✅ Compress image before converting to base64 or returning path
  Future<File?> _compressImage(File file) async {
    try {
      final tempDir = Directory.systemTemp;
      final targetPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: 60, // adjust compression level as needed
        minWidth: 800,
        minHeight: 800,
      );

      if (result != null) {
        return File(result.path);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Image compression error: $e');
      return null;
    }
  }

  /// Picks image from gallery and returns base64 string or file path
  Future<String?> pickImageFromGallery({bool returnBase64 = false}) async {
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) {
      debugPrint('No file selected from gallery.');
      return null;
    }

    final mimeType = lookupMimeType(file.path);
    if (!_isSupportedMimeType(mimeType)) {
      debugPrint('Unsupported file type selected.');
      return null;
    }

    // if (returnBase64) {
    //   final bytes = await File(file.path).readAsBytes();
    //   final base64Data = base64Encode(bytes);
    //   final base64Image = 'data:$mimeType;base64,$base64Data';

    //   if (kDebugMode) {
    //     print('Gallery file base64: $base64Image');
    //   }

    //   return base64Image;
    // } else {
    //   return file.path;
    // }

    final originalFile = File(file.path);
    final originalSizeKB =
        (originalFile.lengthSync() / 1024).toStringAsFixed(2);
    print('🖼️ Original image size: $originalSizeKB KB');

    final compressedFile = await _compressImage(originalFile);
    final targetFile = compressedFile ?? originalFile;
    final compressedSizeKB =
        (targetFile.lengthSync() / 1024).toStringAsFixed(2);
    print('📦 Compressed image size: $compressedSizeKB KB');

    if (returnBase64) {
      final bytes = await targetFile.readAsBytes();
      final base64Data = base64Encode(bytes);
      final base64Image = 'data:$mimeType;base64,$base64Data';
      if (kDebugMode) {
        print('Gallery file base64 (compressed): $base64Image');
      }
      return base64Image;
    } else {
      return targetFile.path;
    }
  }

  /// Picks image from camera and returns base64 string or file path
  Future<String?> pickImageFromCamera({bool returnBase64 = false}) async {
    final XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file == null) {
      debugPrint('No file captured from camera.');
      return null;
    }

    final mimeType = lookupMimeType(file.path);
    if (!_isSupportedMimeType(mimeType)) {
      debugPrint('Unsupported file type captured.');
      return null;
    }

    final originalFile = File(file.path);
    final originalSizeKB = originalFile.lengthSync() / 1024;
    print('📸 Original image size: ${originalSizeKB.toStringAsFixed(2)} KB');

    final compressedFile = await _compressImage(originalFile);
    final targetFile = compressedFile ?? originalFile;
    final compressedSizeKB = targetFile.lengthSync() / 1024;
    print(
        '🗜️ Compressed image size: ${compressedSizeKB.toStringAsFixed(2)} KB');

    if (returnBase64) {
      final bytes = await targetFile.readAsBytes();
      final base64Data = base64Encode(bytes);
      final base64Image = 'data:$mimeType;base64,$base64Data';
      if (kDebugMode) {
        print('Camera file base64 (compressed): $base64Image');
      }
      return base64Image;
    } else {
      return targetFile.path;
    }

    // if (returnBase64) {
    //   final bytes = await File(file.path).readAsBytes();
    //   final base64Data = base64Encode(bytes);
    //   final base64Image = 'data:$mimeType;base64,$base64Data';

    //   if (kDebugMode) {
    //     print('Camera file base64: $base64Image');
    //   }

    //   return base64Image;
    // } else {
    //   return file.path;
    // }
  }

  /// Picks file and returns base64 string or file path
  Future<String?> pickFile({bool returnBase64 = false}) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx', 'pdf', 'jpeg', 'jpg', 'png'],
    );

    if (returnBase64) {
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final mimeType = lookupMimeType(file.path!);
        if (!_isSupportedMimeType(mimeType)) {
          debugPrint('Unsupported file type selected.');
          return null;
        }

        final bytes = await File(file.path!).readAsBytes();
        final base64Data = base64Encode(bytes);
        final base64File = 'data:$mimeType;base64,$base64Data';

        if (kDebugMode) {
          print('File base64: $base64File');
        }

        return base64File;
      } else {
        debugPrint('No file selected.');
        return null;
      }
    } else {
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final mimeType = lookupMimeType(file.path!);
        if (!_isSupportedMimeType(mimeType)) {
          debugPrint('Unsupported file type selected.');
          return null;
        }

        return file.path;
      } else {
        debugPrint('No file selected.');
        return null;
      }
    }
  }

  /// Update user profile image with base64 string
  Future<void> updateFile(String base64Image) async {
    final apiService = MyApIService();

    try {
      final userModel = UserUpdateModel(
        profileImages: [
          ProfileImages(
            imageUrl: base64Image,
            isMain: true,
          ),
        ],
      );

      final response = await apiService.updatePersonalInfo(
        userController.userData.value!.id!,
        userModel,
      );

      if (response.statusCode == 200) {
        debugPrint("Data from API: ${response.body}");
        final userdata =
            await apiService.getUserByID(userController.userData.value!.id!);
        debugPrint('Raw user response: ${userdata.body}');
        Get.back();
      } else {
        debugPrint("Error response: ${response.body}");
      }
    } catch (e) {
      debugPrint('Network error: ${e.toString()}');
    }
  }

  /// Upload document file by path
  Future<void> uploadDocument(String filePath,
      {String? userId, String? fileType}) async {
    final apiService = MyApIService();

    try {
      final response = await apiService.uploadFile(
        userId ?? userController.userData.value!.id!,
        fileType ?? addLicenseController.selectedLicenseType,
        filePath,
      );

      if (response.statusCode == 201) {
        debugPrint("Document uploaded successfully");
        await apiService.getUserByID(userController.userData.value!.id!);
        Get.back();
      } else {
        final responseBody = await response.stream.bytesToString();
        debugPrint("Upload failed: $responseBody");
      }
    } catch (e) {
      debugPrint('Network error: ${e.toString()}');
    }
  }

  /// Show bottom sheet to pick image and return base64 or path
  Future<String?> showUploadFileBottomSheet(BuildContext context,
      {bool returnBase64 = false,
      bool showPickFileOption = true,
      bool showPickGalleryOption = true}) async {
    final UploadFileController controller = Get.put(UploadFileController());

    return await showModalBottomSheet<String>(
      context: context,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.kDarkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                color: Colors.grey,
                thickness: 5,
                indent: 140,
                endIndent: 140,
              ),
              // Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upload File",
                    style:
                        AppTypography.kBold18.copyWith(color: AppColors.kWhite),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(null),
                    child: Text(
                      "Close",
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kSkyBlue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.tenVertical),
              if (showPickGalleryOption == true) ...[
                // Upload from Gallery option
                _buildUploadOption("Upload from Gallery", () async {
                  final result = await controller.pickImageFromGallery(
                      returnBase64: returnBase64);
                  Navigator.of(context).pop(result);
                }),
              ],
              Divider(color: AppColors.kSkyBlue),
              // Upload from Camera option
              _buildUploadOption("Upload from Camera", () async {
                final result = await controller.pickImageFromCamera(
                    returnBase64: returnBase64);
                Navigator.of(context).pop(result);
              }),
              if (showPickFileOption == true) ...[
                Divider(color: AppColors.kSkyBlue),
                _buildUploadOption("Pick a File", () async {
                  final result =
                      await controller.pickFile(returnBase64: returnBase64);
                  Navigator.of(context).pop(result);
                }),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadOption(String option, Function()? onTap) {
    return ListTile(
      title: Text(option, style: const TextStyle(color: Colors.white)),
      leading: const Icon(
        Icons.file_copy_outlined,
        color: AppColors.kSkyBlue,
      ),
      onTap: onTap,
    );
  }
}
