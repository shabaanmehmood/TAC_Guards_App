import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/dataproviders/api_service.dart';
import '../../models/jobApplications/jobApplications_model.dart';
import 'job_model.dart';

class JobController extends GetxController {
  var selectedFilter = 'Active'.obs;
  var isLoading = false.obs;
  var allApplications = <JobApplication>[].obs;
  final apiService = MyApIService();
  UserController userController = Get.find<UserController>();
  Timer? _pollingTimer;
  var lastAutoRefreshTime = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobApplications(userController.userData.value!.id!);
    startPolling();
  }

  @override
  void onClose() {
    _stopPolling();
    super.onClose();
  }

  void startPolling() {
    _stopPolling();
    
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!isLoading.value) {
        debugPrint('=== Auto-refresh triggered at ${DateTime.now()} ===');
        _autoRefreshJobs();
      }
    });
  }

  void _stopPolling() {
    if (_pollingTimer != null) {
      _pollingTimer!.cancel();
      _pollingTimer = null;
    }
  }

  Future<void> _autoRefreshJobs() async {
    try {
      debugPrint('Fetching updated jobs...');
      var functionUrl = 'jobApplication/applications/${userController.userData.value!.id!}';
      final response = await http.get(
        Uri.parse(apiService.baseurl + functionUrl),
        headers: {
          "Content-Type": "application/json",
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final data = jsonMap['data'];

        List<JobApplication> newApplications = [];
        if (data is List) {
          newApplications = data.map((e) => JobApplication.fromJson(e)).toList();
        } else if (data is Map) {
          newApplications = [JobApplication.fromJson(data)];
        }

        debugPrint('Current jobs: ${allApplications.length}, New jobs: ${newApplications.length}');
        
        // Always update the list to trigger UI rebuild
        // This ensures jobs move between tabs when status changes
        allApplications.value = newApplications;
        lastAutoRefreshTime.value = DateTime.now();
        
        // Force UI to rebuild
        update();
        
        debugPrint('✅ Jobs updated! Status changes will now reflect in UI');
        
        // Log status changes for debugging
        _logStatusChanges(allApplications, newApplications);
      } else {
        debugPrint('❌ Auto-refresh failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Auto refresh error: $e');
    }
  }

  // Helper to log status changes for debugging
  void _logStatusChanges(List<JobApplication> oldList, List<JobApplication> newList) {
    Map<String, String> oldStatusMap = {};
    Map<String, String> newStatusMap = {};
    
    for (var app in oldList) {
      if (app.job.id != null) {
        oldStatusMap[app.job.id!] = app.job.status;
      }
    }
    
    for (var app in newList) {
      if (app.job.id != null) {
        newStatusMap[app.job.id!] = app.job.status;
      }
    }
    
    // Check for status changes
    for (var jobId in oldStatusMap.keys) {
      if (newStatusMap.containsKey(jobId)) {
        if (oldStatusMap[jobId] != newStatusMap[jobId]) {
          debugPrint('🔄 Job $jobId status changed: ${oldStatusMap[jobId]} -> ${newStatusMap[jobId]}');
        }
      }
    }
  }

  Future<void> fetchJobApplications(String userId) async {
    isLoading.value = true;
    try {
      var functionUrl = 'jobApplication/applications/$userId';
      final response = await http.get(
        Uri.parse(apiService.baseurl + functionUrl),
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
        lastAutoRefreshTime.value = DateTime.now();
      } else {
        allApplications.clear();
      }
    } catch (e) {
      allApplications.clear();
    } finally {
      isLoading.value = false;
      update(); // Force UI update
    }
  }

  Future<void> refreshJobs() async {
    isLoading.value = true;
    try {
      await fetchJobApplications(userController.userData.value!.id!);
      Get.snackbar(
        "Success",
        "Jobs refreshed",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to refresh jobs",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Map filter label to API status value
  final Map<String, String> statusMap = {
    'Active': 'active',
    'In Progress': 'in_progress',
    'Pending': 'pending',
    'Completed': 'completed',
    'Cancelled': 'cancelled',
  };

  // Add this method to get status counts for UI
  Map<String, int> get statusCounts {
    Map<String, int> counts = {};
    for (var filter in statusMap.keys) {
      counts[filter] = allApplications
          .where((j) => j.job.status.toLowerCase() == statusMap[filter]!.toLowerCase())
          .length;
    }
    return counts;
  }

  Future<Map<String, dynamic>> submitReview({
    required String guardId,
    required String jobId,
    required String contractorId,
    required int rating,
    required String review,
  }) async {
    final url = Uri.parse('http://148.66.158.113:3006/api/v1/guardFeedback');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "guardId": guardId,
          "jobId": jobId,
          "contractorId": contractorId,
          "rating": rating,
          "review": review,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh jobs after submitting review
        _autoRefreshJobs();
        return {
          "status": true,
          "message": "Review submitted successfully!",
        };
      } else {
        final res = jsonDecode(response.body);
        return {
          "status": false,
          "message": res["message"] ?? "Failed to submit review",
        };
      }
    } catch (e) {
      return {
        "status": false,
        "message": "An error occurred while submitting review",
      };
    }
  }

  List<JobApplication> get filteredJobs {
    final status = statusMap[selectedFilter.value] ?? '';
    return allApplications
        .where((j) => j.job.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    update(); // Force UI update when filter changes
  }
}