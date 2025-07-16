import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/dataproviders/api_service.dart';
import '../../models/jobApplications/jobApplications_model.dart';
import 'job_model.dart';
import 'job_dummy_data.dart';

class JobController extends GetxController {
  var selectedFilter = 'Active'.obs;
  var isLoading = false.obs;
  var allApplications = <JobApplication>[].obs;
  final apiService = MyApIService();
  UserController userController = Get.find<UserController>();

  Future<void> fetchJobApplications(String userId) async {
    isLoading.value = true;
    try {
      var functionUrl = 'jobApplication/applications/$userId';
      final response = await http.get(Uri.parse(apiService.baseurl + functionUrl),
        headers: {
          "Content-Type": "application/json",
          'ngrok-skip-browser-warning': 'true',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final data = jsonMap['data'];
        if (data is List) {
          allApplications.value = data.map((e) => JobApplication.fromJson(e)).toList();
        } else if (data is Map) {
          allApplications.value = [JobApplication.fromJson(data)];
        } else {
          allApplications.clear();
        }
      } else {
        allApplications.clear();
      }
    } catch (e) {
      allApplications.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Map filter label to API status value
  final Map<String, String> statusMap = {
    'Active': 'approved',
    'Pending': 'pending',
    'Completed': 'completed',
    'Cancelled': 'cancelled',
  };

  @override
  void onInit() {
    super.onInit();
    fetchJobApplications(userController.userData.value!.id!);
  }

  List<JobApplication> get filteredJobs {
    final status = statusMap[selectedFilter.value] ?? '';
    return allApplications
        .where((j) => j.currentStatus.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
