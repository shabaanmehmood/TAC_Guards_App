import 'dart:convert';

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
    'Active': 'active',
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
        .where((j) => j.job.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<JobModel> get filteredJobModels {
    final status = statusMap[selectedFilter.value] ?? '';
    return allApplications
        .where((j) => j.job.status.toLowerCase() == status.toLowerCase())
        .map((jobApp) {
      final job = jobApp.job;
      final shift = jobApp.assignedShift;
      String cardStatus;
      String statusLabel;
      String? buttonText;
      bool showButton = false;

      // ---- CARD/BUTTON/BACKGROUND STATUS LOGIC ----

      if (job.status.toLowerCase() == 'active') {
        // Check-in required only
        if ((shift.checkInRequired ?? false) && !(shift.checkOutRequired ?? false)) {
          cardStatus = 'In Progress';
          statusLabel = 'In Progress';
          buttonText = 'Check In';
          showButton = true;
        }
        // Check-out required only
        else if (!(shift.checkInRequired ?? false) && (shift.checkOutRequired ?? false)) {
          cardStatus = 'Awaiting';
          statusLabel = 'Awaiting';
          buttonText = 'Check Out';
          showButton = true;
        } else {
          // Just active, no checkin/checkout required right now
          cardStatus = 'Active';
          statusLabel = 'Active';
          buttonText = null;
          showButton = false;
        }
      }
      else if (job.status.toLowerCase() == 'completed') {
        cardStatus = 'Completed';
        statusLabel = 'Completed';
        buttonText = 'Share your review';
        showButton = true;
      }
      else if (job.status.toLowerCase() == 'pending') {
        cardStatus = 'Pending';
        statusLabel = 'Pending';
        buttonText = null;
        showButton = false;
      }
      else if (job.status.toLowerCase() == 'cancelled') {
        cardStatus = 'Cancelled';
        statusLabel = 'Cancelled';
        buttonText = null;
        showButton = false;
      }
      else {
        cardStatus = job.status.capitalizeFirst ?? '';
        statusLabel = cardStatus;
        buttonText = null;
        showButton = false;
      }

      return JobModel(
        title: job.title,
        guardName: jobApp.job.contractor.name ?? '--',
        rating: '',
        location: job.location,
        distance: job.latitude,
        time: job.shifts.isNotEmpty
            ? '${job.shifts[0].startTime} - ${job.shifts[0].endTime}'
            : '',
        status: cardStatus, // Controls background and status
        statusLabel: statusLabel,
        price: job.payPerHour.isNotEmpty && job.status.toLowerCase() == 'completed'
            ? '\$${job.payPerHour}'
            : '',
        remainingTime: null,
        nestedCards: null,
        showButton: showButton,
        buttonText: buttonText,
      );
    }).toList();
  }


// Helper (add to your controller - or pass in as a function)
  String _mapStatus(String apiStatus) {
    switch (apiStatus.toLowerCase()) {
      case 'active':
        return 'In Progress';
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return apiStatus.capitalizeFirst ?? '';
    }
  }


}
