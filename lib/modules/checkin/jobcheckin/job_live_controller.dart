import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tac/dataproviders/api_service.dart';
import 'package:tac/modules/checkin/jobcheckin/job_status_error.dart';
import 'package:tac/modules/checkin/jobcheckin/job_status_screen.dart';
import 'package:tac/modules/checkin/jobcheckin/shift_close.dart';
import 'dart:async';
import 'dart:convert';

class JobLiveController extends GetxController {
  var isApproved = false.obs;
  var seconds = 0.obs;
  var checkboxValue = false.obs;
  var timerText = "00:00:00".obs;
  var shiftStatus = "WAITING FOR SHIFT TIME".obs;
  var isCheckedIn = true.obs;
  var isNavigating = false.obs;
  var errorMessage = ''.obs;

  Timer? _timer;
  Timer? _scheduledStartTimer;
  DateTime? _shiftStartTime;
  DateTime? _shiftEndTime;
  DateTime? _actualShiftStartTime;

  // Store the complete data from the screen
  Map<String, dynamic> completeApiData = {};

  @override
  void onInit() {
    super.onInit();
    // Reset all values to initial state
    isApproved.value = false;
    seconds.value = 0;
    checkboxValue.value = false;
    timerText.value = "00:00:00";
    shiftStatus.value = "WAITING FOR SHIFT TIME";
    isCheckedIn.value = true;
    isNavigating.value = false;
    errorMessage.value = '';
    completeApiData = {};
    _timer?.cancel();
    _scheduledStartTimer?.cancel();
    _timer = null;
    _scheduledStartTimer = null;
    _shiftStartTime = null;
    _shiftEndTime = null;
    _actualShiftStartTime = null;
    initializeTimer();
  }

  void initializeTimer() {
    // Get data from the screen's Data property
    final shiftData = completeApiData['responseBody']?['data']?['shift'] ?? {};
    final startTime = shiftData['startTime']?.toString();

    if (startTime != null && startTime != 'N/A') {
      _setupTimerFromStartTime(startTime);
    } else {
      shiftStatus.value = "WAITING FOR SHIFT TIME";
      timerText.value = "00:00:00";
    }
  }

  // Add this helper method to parse time with separate period field
  DateTime _parseTimeWithSeparatePeriod(String timeStr, String period) {
    try {
      print("🕒 PARSING TIME: $timeStr with period: $period");

      // Clean the inputs
      timeStr = timeStr.trim();
      period = period.trim().toUpperCase();

      // Split the time string (format: "HH:mm:ss")
      final timeParts = timeStr.split(':');
      if (timeParts.length < 2) {
        throw FormatException('Invalid time format: $timeStr');
      }

      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      // Ignore seconds if present

      // Convert based on AM/PM period
      if (period == 'PM') {
        if (hour != 12) {
          hour += 12;
        }
        // If hour is 12 PM, it remains 12 (noon)
      } else if (period == 'AM') {
        if (hour == 12) {
          hour = 0; // 12 AM becomes 00:00 (midnight)
        }
        // If hour is 1-11 AM, it remains the same
      } else {
        throw FormatException('Invalid time period: $period');
      }

      // Ensure hour is in valid range (0-23)
      hour = hour % 24;

      final now = DateTime.now();
      final parsedTime = DateTime(now.year, now.month, now.day, hour, minute);

      print(
          "🕒 PARSED: $timeStr $period → ${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}");

      return parsedTime;
    } catch (e) {
      print("❌ ERROR PARSING TIME: $timeStr $period - $e");
      rethrow;
    }
  }

  void _setupTimerFromStartTime(String startTime) {
    final now = DateTime.now();
    print("🕒 CURRENT TIME: $now");
    print("🕒 SHIFT START TIME FROM API: $startTime");

    try {
      // Extract time period from API data
      final shiftData =
          completeApiData['responseBody']?['data']?['shift'] ?? {};
      final timePeriod = shiftData['timePeriod']?.toString() ??
          'AM'; // Default to AM if missing

      print("🕒 TIME PERIOD FROM API: $timePeriod");

      // Parse start time with period
      _shiftStartTime = _parseTimeWithSeparatePeriod(startTime, timePeriod);
      print("🕒 PARSED SHIFT START TIME: $_shiftStartTime");

      // Parse end time
      final endTime = shiftData['endTime']?.toString();

      if (endTime != null && endTime != 'N/A') {
        print("🕒 SHIFT END TIME FROM API: $endTime");

        // Use same time period for end time (assuming same AM/PM period for entire shift)
        _shiftEndTime = _parseTimeWithSeparatePeriod(endTime, timePeriod);
        print("🕒 PARSED SHIFT END TIME: $_shiftEndTime");

        if (_shiftEndTime != null) {
          print("🕒 TIME UNTIL END: ${_shiftEndTime!.difference(now)}");

          // Check if end time is before start time (crosses midnight)
          if (_shiftEndTime!.isBefore(_shiftStartTime!)) {
            print("⚠️ End time is before start time - shift crosses midnight");
            print("🕒 Adding 1 day to end time");
            _shiftEndTime = _shiftEndTime!.add(const Duration(days: 1));
            print("🕒 ADJUSTED END TIME: $_shiftEndTime");
          }

          // Validate the times make sense
          if (_shiftStartTime!.isAfter(_shiftEndTime!)) {
            print(
                "❌ ERROR: Start time is after end time even after adjustment");
          }
        }
      }

      final timeUntilStart = _shiftStartTime!.difference(now);
      print("🕒 TIME UNTIL START: $timeUntilStart");

      if (timeUntilStart.isNegative) {
        print("🔴 SHIFT SHOULD START - Time until start is negative");
        print("🕒 Starting shift timer immediately");
        _startShiftTimer();
      } else {
        print("🟢 WAITING FOR SHIFT - Time until start: $timeUntilStart");
        shiftStatus.value = "WAITING FOR SHIFT TIME";
        timerText.value = "00:00:00";
        _scheduleAutomaticStart(timeUntilStart);
      }
    } catch (e) {
      print("❌ Error parsing shift times: $e");
      shiftStatus.value = "WAITING FOR SHIFT TIME";
      timerText.value = "00:00:00";

      // Show error to user but don't crash
      Get.snackbar(
        "Time Error",
        "Could not parse shift times. Please contact support.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void _scheduleAutomaticStart(Duration timeUntilStart) {
    _scheduledStartTimer?.cancel();

    _scheduledStartTimer = Timer(timeUntilStart, () {
      print("🚀 Scheduled timer triggered - shift starting now!");
      _startShiftTimer();
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final remaining = _shiftStartTime!.difference(now);

      if (remaining.isNegative || remaining.inSeconds == 0) {
        print("⏰ Time's up! Starting shift timer");
        _startShiftTimer();
        timer.cancel();
      }
    });
  }

  void _startShiftTimer() {
    _timer?.cancel();
    _scheduledStartTimer?.cancel();

    _actualShiftStartTime = DateTime.now();
    shiftStatus.value = "IN PROGRESS";
    seconds.value = 0;
    timerText.value = "00:00:00";

    print("✅ Shift timer started at: $_actualShiftStartTime");

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds.value++;

      final hrs = (seconds.value ~/ 3600).toString().padLeft(2, '0');
      final mins = ((seconds.value % 3600) ~/ 60).toString().padLeft(2, '0');
      final secs = (seconds.value % 60).toString().padLeft(2, '0');
      timerText.value = "$hrs:$mins:$secs";

      _checkForShiftCompletion();
    });
  }

  void _checkForShiftCompletion() {
    if (_shiftEndTime == null || isNavigating.value) return;

    final now = DateTime.now();
    print("🕒 CHECKING COMPLETION - Now: $now, End: $_shiftEndTime");

    if (now.isAfter(_shiftEndTime!) || now.isAtSameMomentAs(_shiftEndTime!)) {
      print("🎯 Shift end time reached! Auto-completing shift...");
      _handleAutomaticCompletion();
    } else {
      print(
          "⏳ Shift still in progress - Time remaining: ${_shiftEndTime!.difference(now)}");
    }
  }

// Alternative using geolocator package (make sure to add it to pubspec.yaml)
  Future<Map<String, double>> _getCurrentLocation() async {
    try {
      print("📍 Getting current location...");

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      print("📍 Current location obtained:");
      print("   Latitude: ${position.latitude}");
      print("   Longitude: ${position.longitude}");

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      print("❌ Error getting current location: $e");

      // Fallback to default location
      Get.snackbar(
        "Location Error",
        "Could not get current location. Using default coordinates.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

      return {
        'latitude': 37.7749,
        'longitude': -122.4194,
      };
    }
  }

  // Add checkout API integration methods
  Future<void> _callCheckoutApi(
      {required bool isEarlyClosure, String? earlyClosureReason}) async {
    try {
      print("🔄 Calling checkout API...");

      // Get current location using your existing location service
      final currentLocation = await _getCurrentLocation();

      // Prepare notes based on closure type
      String notes = "Shift completed normally";
      if (isEarlyClosure) {
        notes = "Early closure: ${earlyClosureReason ?? 'No reason provided'}";
      }

      // Get shift and guard IDs from your API data
      final shiftData =
          completeApiData['responseBody']?['data']?['shift'] ?? {};
      final shiftId = completeApiData['shiftId']?.toString() ?? '';
      final guardData =
          completeApiData['responseBody']?['data']?['guard'] ?? {};
      final guardId = completeApiData['guardId']?.toString() ?? '';

      if (shiftId.isEmpty || guardId.isEmpty) {
        throw Exception(
            "Missing shiftId or guardId. Shift: $shiftId, Guard: $guardId");
      }

      print("📤 Checkout API Parameters:");
      print("   Shift ID: $shiftId");
      print("   Guard ID: $guardId");
      print("   Latitude: ${currentLocation['latitude']}");
      print("   Longitude: ${currentLocation['longitude']}");
      print("   Notes: $notes");
      print("   Early Closure: $isEarlyClosure");

      // Call the checkout API
      final response = await MyApIService().checkOutGuard(
        shiftId,
        guardId,
        currentLocation['latitude'].toString(),
        currentLocation['longitude'].toString(),
        notes,
      );

      if (response.statusCode == 200) {
        print("✅ Checkout API call successful");
        final jsonResponse = jsonDecode(response.body);

        print("📋 Checkout API Response: $jsonResponse");
      } else {
        throw Exception(
            "Checkout API failed with status: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Checkout API error: $e");
      throw Exception("Failed to process checkout: $e");
    }
  }

  // Update the _handleAutomaticCompletion method to include checkout API call
  void _handleAutomaticCompletion() {
    if (isNavigating.value) return;
    isNavigating.value = true;

    _timer?.cancel();
    _scheduledStartTimer?.cancel();

    shiftStatus.value = "COMPLETED";

    final completionData = _prepareCompletionData(isEarlyClosure: false);

    print("🚀 Auto-navigating to JobCompleteScreen with API checkout");

    // Call checkout API before navigation
    _callCheckoutApi(isEarlyClosure: false).then((_) {
      print("✅ Automatic checkout API completed successfully");

      // Use direct navigation instead of named routes for better reliability
      Future.delayed(Duration.zero, () {
        Get.off(() => JobStatusScreenSuccess(), arguments: completionData);
      });
    }).catchError((error) {
      print("❌ Automatic checkout API failed: $error");
      isNavigating.value = false; // Reset navigation state
      _handleError('Failed to complete shift checkout: $error');
    });
  }

  // Method to determine if closure is early
  bool _isEarlyClosure() {
    if (_shiftEndTime == null) {
      print("❌ No end time set - cannot determine if early closure");
      return false;
    }

    final now = DateTime.now();
    final isEarly = now.isBefore(_shiftEndTime!);

    print("🕒 EARLY CLOSURE CHECK:");
    print("🕒 Current time: $now");
    print("🕒 Shift end time: $_shiftEndTime");
    print("🕒 Is early closure: $isEarly");
    print("🕒 Time remaining: ${_shiftEndTime!.difference(now)}");

    return isEarly;
  }

  // Update the handleManualShiftClosure method to handle API calls for normal closure
  Future<void> handleManualShiftClosure() async {
    if (isNavigating.value) return;

    try {
      isNavigating.value = true;
      errorMessage.value = '';

      print("🔄 Close My Shift button pressed");

      // Check if it's early closure
      final isEarlyClosure = _isEarlyClosure();

      _timer?.cancel();
      _scheduledStartTimer?.cancel();

      final closureData =
          _prepareCompletionData(isEarlyClosure: isEarlyClosure);

      if (isEarlyClosure) {
        print("⚠️ Early closure detected! Showing bottom sheet");
        // Show early closure bottom sheet
        _showEarlyClosureBottomSheet(closureData);
      } else {
        print("✅ Normal closure detected! Calling checkout API");
        // For normal closure, call API directly
        _callCheckoutApi(isEarlyClosure: false).then((_) {
          print("✅ Normal closure checkout API completed successfully");
          _navigateToSuccessScreen(closureData);
        }).catchError((error) {
          print("❌ Normal closure checkout API failed: $error");
          _handleError('Failed to close shift: $error');
        });
      }
    } catch (e) {
      print("❌ Error during shift closure: $e");
      _handleError('Failed to close shift: ${e.toString()}');
    } finally {
      isNavigating.value = false;
    }
  }

  // Update the _showEarlyClosureBottomSheet method
  void _showEarlyClosureBottomSheet(Map<String, dynamic> closureData) {
    try {
      Get.bottomSheet(
        ShiftCloseBottomSheet(completionData: closureData),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isDismissible: true,
      ).then((value) {
        // Handle when bottom sheet is dismissed without taking action
        if (value == null) {
          isNavigating.value = false;
          print("📋 Bottom sheet dismissed without action");

          // Restart the timer if shift is still in progress
          if (shiftStatus.value == "IN PROGRESS" && _timer == null) {
            print("🔄 Restarting shift timer after bottom sheet dismissal");
            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              seconds.value++;

              final hrs = (seconds.value ~/ 3600).toString().padLeft(2, '0');
              final mins =
                  ((seconds.value % 3600) ~/ 60).toString().padLeft(2, '0');
              final secs = (seconds.value % 60).toString().padLeft(2, '0');
              timerText.value = "$hrs:$mins:$secs";

              _checkForShiftCompletion();
            });
          }
        } else if (value is Map<String, dynamic>) {
          // Handle early closure with reason from bottom sheet
          final reason = value['reason']?.toString() ?? '';
          final customReason = value['customReason']?.toString();

          print("📋 Bottom sheet completed with reason: $reason");
          handleEarlyClosureWithReason(closureData, reason, customReason);
        }
      });
    } catch (e) {
      print("❌ Error showing bottom sheet: $e");
      isNavigating.value = false; // Reset navigation state
      _handleError('Failed to show closure options: ${e.toString()}');
    }
  }

  // Update the _navigateToSuccessScreen method
  void _navigateToSuccessScreen(Map<String, dynamic> closureData) {
    try {
      Get.off(() => JobStatusScreenSuccess(), arguments: closureData);

      Get.snackbar(
        "Shift Completed",
        "Your shift has been successfully completed!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print("❌ Error navigating to success screen: $e");
      isNavigating.value = false; // Reset navigation state
      _handleError('Failed to navigate to completion screen: ${e.toString()}');
    }
  }

  // Update the handleEarlyClosureWithReason method to include checkout API call
  void handleEarlyClosureWithReason(
      Map<String, dynamic> closureData, String reason, String? customReason) {
    try {
      isNavigating.value = true;

      // Add reason to closure data
      final updatedClosureData = Map<String, dynamic>.from(closureData);
      updatedClosureData['earlyClosureReason'] = {
        'selectedReason': reason,
        'customReason': customReason,
        'submittedAt': DateTime.now().toIso8601String(),
      };

      print("✅ Early closure with reason: $reason");

      // Call checkout API before navigation
      _callCheckoutApi(
        isEarlyClosure: true,
        earlyClosureReason: customReason ?? reason,
      ).then((_) {
        print("✅ Early closure checkout API completed successfully");

        // Navigate to success screen
        _navigateToSuccessScreen(updatedClosureData);
      }).catchError((error) {
        print("❌ Early closure checkout API failed: $error");
        isNavigating.value = false; // Reset navigation state
        _handleError('Failed to process early closure checkout: $error');
      });
    } catch (e) {
      print("❌ Error in early closure with reason: $e");
      isNavigating.value = false; // Reset navigation state
      _handleError('Failed to process early closure: ${e.toString()}');
    }
  }

  // Handle errors
  void _handleError(String message) {
    try {
      errorMessage.value = message;

      // Prepare error data with available information
      final errorData = {
        'errorMessage': message,
        'originalApiData': completeApiData,
        'calculatedData': _prepareErrorData(),
      };

      // Navigate to error screen
      Get.off(() => JobStatusScreenError(), arguments: errorData);

      Get.snackbar(
        "Error",
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      print("❌ Critical error in error handling: $e");
      // Fallback: Show dialog if navigation fails
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                resetNavigationState();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // Prepare error data
  Map<String, dynamic> _prepareErrorData() {
    final now = DateTime.now();
    final jobData = completeApiData['responseBody']?['data']?['job'] ?? {};
    final hourlyRate =
        double.tryParse(jobData['payPerHour']?.toString() ?? '0') ?? 0.0;
    final hoursWorked = seconds.value / 3600;
    final totalEarnings = hoursWorked * hourlyRate;

    return {
      'workDuration': {
        'totalSeconds': seconds.value,
        'totalHours': hoursWorked,
        'formattedDuration': timerText.value,
        'humanReadableDuration': _getHumanReadableDuration(seconds.value),
        'actualStartTime': _actualShiftStartTime?.toIso8601String(),
        'actualEndTime': now.toIso8601String(),
      },
      'earnings': {
        'hourlyRate': hourlyRate,
        'hoursWorked': hoursWorked,
        'totalEarnings': totalEarnings,
        'formattedTotalEarnings': '\$${totalEarnings.toStringAsFixed(2)}',
      },
      'errorInfo': {
        'errorTime': now.toIso8601String(),
        'shiftStatus': shiftStatus.value,
      }
    };
  }

  // Simplified data preparation - only send additional calculated data
  Map<String, dynamic> _prepareCompletionData({required bool isEarlyClosure}) {
    final now = DateTime.now();

    // Calculate work duration and earnings
    final jobData = completeApiData['responseBody']?['data']?['job'] ?? {};
    final hourlyRate =
        double.tryParse(jobData['payPerHour']?.toString() ?? '0') ?? 0.0;
    final hoursWorked = seconds.value / 3600;
    final totalEarnings = hoursWorked * hourlyRate;

    // Calculate remaining time if early closure
    Duration? remainingTime;
    double? potentialEarningsLoss;
    if (isEarlyClosure && _shiftEndTime != null) {
      remainingTime = _shiftEndTime!.difference(now);
      potentialEarningsLoss = (remainingTime.inMinutes / 60) * hourlyRate;
    }

    return {
      // 1. Original complete API data (contains shift and job details)
      'originalApiData': completeApiData,

      // 2. Additional calculated data only
      'calculatedData': {
        'workDuration': {
          'totalSeconds': seconds.value,
          'totalHours': hoursWorked,
          'formattedDuration': timerText.value,
          'humanReadableDuration': _getHumanReadableDuration(seconds.value),
          'actualStartTime': _actualShiftStartTime?.toIso8601String(),
          'actualEndTime': now.toIso8601String(),
        },
        'closureInfo': {
          'closureType': isEarlyClosure ? 'early' : 'completed',
          'isEarlyClosure': isEarlyClosure,
          'completedAt': now.toIso8601String(),
        },
        'earnings': {
          'hourlyRate': hourlyRate,
          'hoursWorked': hoursWorked,
          'totalEarnings': totalEarnings,
          'formattedTotalEarnings': '\$${totalEarnings.toStringAsFixed(2)}',
        },
        'earlyClosureDetails': isEarlyClosure
            ? {
                'minutesEarly': remainingTime?.inMinutes ?? 0,
                'formattedRemainingTime':
                    _formatDuration(remainingTime ?? Duration.zero),
                'potentialEarningsLoss': potentialEarningsLoss ?? 0.0,
              }
            : null,
      }
    };
  }

  String _getHumanReadableDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final secs = totalSeconds % 60;

    if (hours > 0) {
      return '$hours hours, $minutes minutes, $secs seconds';
    } else if (minutes > 0) {
      return '$minutes minutes, $secs seconds';
    } else {
      return '$secs seconds';
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void toggleApproval() {
    isApproved.value = true;
  }

  void setShiftStartTime(String startTime) {
    _setupTimerFromStartTime(startTime);
  }

  // Reset navigation state (useful when user cancels from bottom sheet)
  void resetNavigationState() {
    isNavigating.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    _scheduledStartTimer?.cancel();
    print("🛑 All timers disposed");
    super.onClose();
  }
}
