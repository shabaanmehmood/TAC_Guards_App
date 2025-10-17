import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:tac/models/earning_model.dart';
import 'package:tac/models/nearbyjob.dart';
import 'package:tac/models/notification_model.dart';

import '../controllers/user_controller.dart';
import '../models/getUserById_model.dart';
import '../models/jobResponse_model.dart';
import '../models/userdata_model.dart';
import '../models/userupdate_model.dart';
import '../modules/Messages/socket_file.dart';

class MyApIService {
  Future<void> sendLocationToApi(String shiftId, String guardId, String jobId,
      double latitude, double longitude) async {
    final payload = {
      "guardId": guardId,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "shiftId": shiftId,
      "jobId": jobId,
    };
    try {
      final response = await http.post(
        Uri.parse("${baseurl}shiftAttendance/previewLocation"),
        body: payload,
      );
      print("📍 Sent location: ${response.statusCode} -> $payload");
    } catch (e) {
      print("❌ Failed to send location: $e");
    }
  }

  UserController get userController => Get.find<UserController>();

  //get access token url:
  ///this 'http://192.168.5.175/flutter' part of loginTokenUrl
  ///must match the same portion of your base URL.
  ///E.g: If the base URL is = 'http://192.168.5.171/RecruitziUI/api/mobile/
  ///then the loginTokenUrl must be = 'http://192.168.5.171/RecruitziUI/oauth/token';

  ///IIS server on Remote Desktop:
  //String loginTokenUrl= 'http://192.168.5.175/flutter/oauth/token';
  //String baseurl = 'http://192.168.5.175/flutter/api/mobile/';

  /// Live portal server:
  // String loginTokenUrl = 'https://truegigs.com/portal/oauth/token';
  String baseurl = 'http://148.66.158.113:3006/api/v1/'; //portal flutter.
  // String controllerBase = 'https://truegigs.com/portal/'; //baseUrl for other calls

  Future<http.Response> signUp(
    String fullName,
    String email,
    String phone,
    String postalAddress,
    String masterSecurityLicense,
    String password,
    String base64Image,
  ) async {
    var functionUrl = 'auth/signUp';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "postalAddress": postalAddress,
        "masterSecurityLicense": masterSecurityLicense,
        "password": password,
        "profileImages": [
          {
            "imageUrl": "data:image/png;base64,$base64Image",
            "isMain": true,
          }
        ]
      }),
    );
    return response;
  }

  Future<http.Response> login(
      String email, String password, String fcmToken) async {
    var functionUrl = 'auth/login';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        // Encode body as JSON string
        "email": email,
        "password": password,
        "fcmToken": fcmToken,
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final userDataModel = UserDataModel.fromJson(jsonData);

      if (userDataModel.data != null) {
        final userId = userDataModel.data!.id;
        debugPrint('User ID: $userId');
        // userController.setUser(userDataModel.data!);
        // final getuserbyid = await getUserByID(userId!);
        // debugPrint('get user by ID called $getuserbyid');
        // Get complete user data including image
        final getUserResponse = await getUserByID(userId!);
        if (getUserResponse.statusCode == 200) {
          final userData =
              GetUserById.fromJson(jsonDecode(getUserResponse.body)).data;
          if (userData != null) {
            Get.find<UserController>().setUser(userData);
            SocketService().initialize();
          }
        }
      }
    } else {
      debugPrint('inside Login method call: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> googleLogin(String token, String fcmToken) async {
    var functionUrl = 'auth/google-Auth';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "token": token,
        "fcmToken": fcmToken,
      }),
    );
    return response;
  }

  Future<http.Response> sendOtp(String email) async {
    var functionUrl = 'users/sendOtp';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        // Encode body as JSON string
        "email": email,
      }),
    );
    return response;
  }

  Future<http.Response> verifyOtp(String email, String otp) async {
    var functionUrl = 'users/verifyOtp';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        // Encode body as JSON string
        "email": email,
        "otp": otp,
      }),
    );
    return response;
  }

  Future<http.Response> resetPassword(
      String email, String password, String confirmPassword) async {
    var functionUrl = 'users/resetPassword';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        // Encode body as JSON string
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final userDataModel = UserDataModel.fromJson(jsonData);

      if (userDataModel.data != null) {
        final userId = userDataModel.data!.id;
        debugPrint('User ID: $userId');
        userController.setUser(userDataModel.data!);
        final getuserbyid = await getUserByID(userId!);
        debugPrint('get user by ID called $getuserbyid');
      }
    } else {
      debugPrint('inside Reset Password method call: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> logout(String userId) async {
    var functionUrl = 'auth/logOut/$userId';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    return response;
  }

  Future<http.StreamedResponse> uploadFile(
      String userId, String fileType, String filePath) async {
    var functionUrl = 'user-documents/upload';
    final request =
        http.MultipartRequest('POST', Uri.parse(baseurl + functionUrl))
          ..fields['userId'] = userId
          ..fields['type'] = fileType
          ..files.add(await http.MultipartFile.fromPath('file', filePath));

    request.headers.addAll({
      'ngrok-skip-browser-warning': 'true',
    });
    final response = await request.send();
    return response;
  }

  Future<http.Response> getUserByID(String userId) async {
    var functionUrl = 'users/$userId';
    final response = await http.get(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final userData = GetUserById.fromJson(json).data;
      if (userData != null) {
        Get.find<UserController>().setUser(userData);
        debugPrint('User loaded and stored in session');
      }
    } else {
      // handle error
    }
    return response;
  }

  // static const String imageBaseUrl = 'http://148.66.158.113:3006/';
  static const String imageBaseUrl = 'http://148.66.158.113:3006/uploads';

  static String? fullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    return '$imageBaseUrl$imagePath';
  }

  Future<http.Response> addBankDetails(
      String bankName,
      String accountTitle,
      String accountNumber,
      String iban,
      String expiryDate,
      String userId) async {
    var functionUrl = 'userBankDetails';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "bankName": bankName,
        "accountTitle": accountTitle,
        "accountNumber": accountNumber,
        "IBAN": iban,
        "entityDate": expiryDate,
        "userId": userId,
      }),
    );
    return response;
  }

  Future<http.Response> getBankDetails(String userId) async {
    var functionUrl = 'userBankDetails/$userId';
    final response = await http.get(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final userData = GetUserById.fromJson(json).data;
      debugPrint('User data: $userData');

      if (userData != null) {
        Get.find<UserController>().setUser(userData);
        debugPrint('User bank details loaded and stored in session');
      }
    } else {
      // handle error
    }
    return response;
  }

  Future<http.Response> getBankDetailsWithParams(
      Map<String, String> queryParams) async {
    var functionUrl = 'userBankDetails/';
    final uri =
        Uri.parse(baseurl + functionUrl).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> addDispute(
      String disputeType,
      String jobId,
      String incidentDate,
      String userId,
      String description,
      List<String> supportDocuments,
      String? transactionId,
      String? transactionDate,
      String? disputeAmount) async {
    var functionUrl = 'userDisputes';

    // Build the request body dynamically
    final Map<String, dynamic> body = {
      "type": disputeType,
      "jobId": jobId,
      "incidentDate": incidentDate,
      "userId": userId,
      "description": description,
      "supportDocuments": supportDocuments,
    };

    // Add optional fields only if they are not null or empty
    if (transactionId != null && transactionId.isNotEmpty) {
      body["transactionId"] = transactionId;
    }
    if (transactionDate != null && transactionDate.isNotEmpty) {
      body["transactionDate"] = transactionDate;
    }
    if (disputeAmount != null && disputeAmount.isNotEmpty) {
      body["disputeAmount"] = disputeAmount;
    }

    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(body), // Encode body as JSON string
    );
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      debugPrint('Dispute response: $jsonData');
    } else {
      debugPrint('inside dispute method call: ${response.statusCode}');
    }
    return response;
  }

  // Future<http.Response> updatePersonalInfo(
  //     String? userId,
  //     String? fullName,
  //     String? email,
  //     String? phone,
  //     String? postalAddress,
  //     String? masterSecurityLicense,
  //     String? password,
  //     String? role,
  //     String? dob,
  //     String? gender,
  //     String? fcmToken,
  //     String? appleId,
  //     int? yearsOfExperience,
  //     String? licenseNumber,
  //     String? abn,
  //     List<String>? preferredLocationAddresses,
  //     ) async {
  //   var functionUrl = 'users/$userId';
  //
  //   Map<String, dynamic> body = {};
  //
  //   if (fullName != null) body['fullName'] = fullName;
  //   if (email != null) body['email'] = email;
  //   if (phone != null) body['phone'] = phone;
  //   if (postalAddress != null) body['postalAddress'] = postalAddress;
  //   if (masterSecurityLicense != null) body['masterSecurityLicense'] = masterSecurityLicense;
  //   if (password != null) body['password'] = password;
  //   if (role != null) body['role'] = role;
  //   if (dob != null) body['dob'] = dob;
  //   if (gender != null) body['gender'] = gender;
  //   if (fcmToken != null) body['fcmToken'] = fcmToken;
  //   if (appleId != null) body['appleId'] = appleId;
  //
  //   Map<String, dynamic> personalDetails = {};
  //   if (yearsOfExperience != null) personalDetails['yearsOfExperience'] = yearsOfExperience;
  //   if (licenseNumber != null) personalDetails['licenseNumber'] = licenseNumber;
  //   if (abn != null) personalDetails['abn'] = abn;
  //   if (preferredLocationAddresses != null) personalDetails['preferredLocationAddresses'] = preferredLocationAddresses;
  //
  //   if (personalDetails.isNotEmpty) body['personalDetails'] = personalDetails;
  //
  //   final response = await http.patch(
  //     Uri.parse(baseurl + functionUrl),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'ngrok-skip-browser-warning': 'true',
  //     },
  //     body: jsonEncode(body),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     final userData = GetUserById.fromJson(json).data;
  //
  //     if (userData != null) {
  //       Get.find<UserController>().setUser(userData);
  //       debugPrint('User loaded and stored in session');
  //     }
  //   } else {
  //     debugPrint('Error updating user: ${response.statusCode}');
  //   }
  //
  //   return response;
  // }

  Future<http.Response> updatePersonalInfo(
      String userId, UserUpdateModel userModel) async {
    final functionUrl = 'users/$userId';
    final response = await http.patch(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(userModel.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // final userData = GetUserById.fromJson(json).data;
      // if (userData != null) {
      //   Get.find<UserController>().setUser(userData);
      //   debugPrint('User loaded and stored in session');
      // }
      debugPrint('Response in updatePersonalInfo: $json');
    } else {
      debugPrint('Error updating user: ${response.statusCode}');
    }

    return response;
  }

  Future<http.Response> deleteAccount(String userId) async {
    var functionUrl = 'users/$userId';
    final response = await http.delete(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      debugPrint('User account deleted successfully');
    } else {
      debugPrint('Error deleting user: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> getAllLicense() async {
    var functionUrl = 'license/';
    final response = await http.get(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('Response in getAllLicense: $json');
    } else {
      // handle error
    }
    return response;
  }

  Future<http.Response> addSecurityLicense(
      String licenseNumber,
      String expiryDate,
      String licenseTypeId,
      String userId,
      String licenseDocumentPath) async {
    var functionUrl = 'userLicenses/';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "licenseNumber": licenseNumber,
        "expiryDate": expiryDate,
        "licenseTypeId": licenseTypeId,
        "userId": userId,
        "licenseDocumentPath": licenseDocumentPath,
      }),
    );
    if (response.statusCode == 201) {
      debugPrint('User security license added successfully');
      final json = jsonDecode(response.body);
      debugPrint('Response in addSecurityLicense: $json');
    } else {
      debugPrint('Error adding user security license: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> getUserSecurityLicenses(String userId) async {
    var functionUrl = 'userLicenses/user/$userId';

    final response = await http.get(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<NearbyJobsResponses?> JobsLocations(
      String latitude, String longitude) async {
    var functionUrl = 'jobs/findNearBy';
    try {
      final response = await http.post(
        Uri.parse(baseurl + functionUrl),
        headers: {
          "Content-Type": "application/json",
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "latitude": latitude,
          "longitude": longitude,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final jobsResponse = NearbyJobsResponses.fromJson(jsonData);
        return jobsResponse;
      } else {
        print('Failed to load jobs. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching jobs: $e');
      return null;
    }
  }

  Future<http.Response> getJobsList() async {
    var functionUrl = 'jobs';

    final response = await http.get(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> applyJob(
      String userId, String jobId, List<String> shiftId) async {
    var functionUrl = 'jobApplication/apply';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "userId": userId,
        "jobId": jobId,
        "shiftId": shiftId,
      }),
    );
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      debugPrint('Job application response: $jsonData');
    } else {
      debugPrint('inside job Apply method call: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> getJobApplicationStatus(
      String userId, String jobId, List<String> shiftId) async {
    var functionUrl = 'jobApplication/apply';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "userId": userId,
        "jobId": jobId,
        "shiftId": shiftId,
      }),
    );
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      debugPrint('Job application response: $jsonData');
    } else {
      debugPrint('inside job Apply method call: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> addReportAnIssue(
    String subject,
    String userId,
    String issueDate,
    String description, {
    String? supportDocumentPath,
  }) async {
    var functionUrl = 'reportAnIssue/';

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      "subject": subject,
      "userId": userId,
      "issueDate": issueDate,
      "description": description,
    };

    // Add supportDocuments only if provided
    if (supportDocumentPath != null && supportDocumentPath.isNotEmpty) {
      requestBody["supportDocuments"] = [
        "data:image/png;base64,$supportDocumentPath"
      ];
    }

    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 201) {
      debugPrint('User report issue added successfully');
      final json = jsonDecode(response.body);
      debugPrint('Response in add report: $json');
    } else {
      debugPrint('Error adding user report issue: ${response.statusCode}');
    }

    return response;
  }

  Future<http.Response> getUserDocuments(String userId) async {
    var functionUrl = 'user-documents/$userId';

    final response = await http.get(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];
      debugPrint('User documents: $dataList');
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> getJobApplicationsByGuardId(String userId) async {
    var functionUrl = 'jobApplication/applications/$userId';

    final response = await http.get(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('Job applications: $json');
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> checkinGuard(String shiftId, String guardId,
      String latitude, String longitude, String image) async {
    var functionUrl = 'shiftAttendance';

    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "shiftId": shiftId,
        "guardId": guardId,
        "latitude": latitude,
        "longitude": longitude,
        'image': image,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('Check-in response: $json');
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> checkOutGuard(String shiftId, String guardId,
      String latitude, String longitude, String notes) async {
    var functionUrl = 'shiftAttendance/checkout';

    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "shiftId": shiftId,
        "guardId": guardId,
        "latitude": latitude,
        "longitude": longitude,
        'notes': notes
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('Check-out response: $json');
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> getAllContractorsList() async {
    var functionUrl = 'contractors';

    final response = await http.get(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];
      debugPrint('Contractors list: $dataList');
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<GuardPaymentData?> getEarnings(String userId) async {
    var functionUrl = 'payment/guard/payments/$userId';

    final response = await http.get(Uri.parse(baseurl + functionUrl), headers: {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('Earnings data: ${json['data']}');
      return GuardPaymentData.fromJson(json['data']);
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }

  Future<List<GuardNotification>> fetchNotifications(String guardId) async {
    final uri = Uri.parse("${baseurl}notification/user/$guardId");
// http://148.66.158.113:3006/api/v1/notification/user/16b7043b-9aab-4902-b2a7-b19cdac99b00
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> dataList = jsonData['data'];
      return dataList.map((item) => GuardNotification.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    final uri = Uri.parse("${baseurl}notification/user/$userId/read-all");

    try {
      final response = await http.patch(
        uri,
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
      );

      print('Mark all read response status code: ${response.statusCode}');
      print('Mark all read response body: ${response.body}');

      if (response.statusCode == 200) {
        print("All notifications marked as read successfully.");
      } else {
        throw Exception(
            'Failed to mark notifications as read: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking notifications as read: $e');
      throw Exception('Network error: Could not mark all as read.');
    }
  }
}
