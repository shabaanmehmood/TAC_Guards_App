import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../dataproviders/api_service.dart';

class CheckInController extends GetxController {
  var isChecked = false.obs;
  var isLoading = false.obs;
  final apiService = MyApIService();

  var selfieBase64 = RxnString();

  // Add these variables for location monitoring
  String? _currentShiftId;
  String? _currentGuardId;
  String? _currentJobId;
  StreamSubscription<Position>? _locationStreamSubscription;
  Timer? _locationTimer;
  // helper
  Uint8List convertBase64ToImage(String base64) =>
      base64Decode(base64.split(',').last);
  void toggleCheck(bool? value) {
    isChecked.value = value ?? false;
  }

  Future<Map<String, dynamic>> checkIn(String shiftId, String guardId,
      double latitude, double longitude, String selfieBase64) async {
    isLoading.value = true;
    try {
      final response = await apiService.checkinGuard(shiftId, guardId,
          latitude.toString(), longitude.toString(), selfieBase64);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse response body
        dynamic responseData = response.body;
        if (response.body is String) {
          responseData = json.decode(response.body);
        }

        // Safe extraction of job ID
        if (responseData['data'] != null &&
            responseData['data']['shiftAssignment'] != null &&
            responseData['data']['shiftAssignment']['application'] != null &&
            responseData['data']['shiftAssignment']['application']['job'] !=
                null) {
          // Extract Job ID
          _currentJobId = responseData['data']['shiftAssignment']['application']
                  ['job']['id']
              .toString();
          print('Job ID extracted: $_currentJobId');
          _currentShiftId = shiftId;
          _currentGuardId = guardId;
          print('shift id is: $_currentShiftId');
          print('Guard id is: $_currentGuardId');
        } else {
          print('Required data not found in response structure');
        }

        await _sendLocationToApi(
            shiftId, guardId, latitude, longitude, _currentJobId!);
        // Start background location monitoring
        await startLocationMonitoring(shiftId, guardId, _currentJobId!);

        Get.back();
        Get.snackbar(
          "Check-in Success",
          "You have successfully checked in.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Return response body along with shiftId
        return {
          'success': true,
          'shiftId': shiftId,
          'responseBody': responseData,
          'jobId': _currentJobId,
          'guardId': guardId
        };
      } else {
        Get.snackbar(
          "Check-in Failed",
          "Could not check in. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        // Return failure response
        return {
          'success': false,
          'shiftId': shiftId,
          'error': 'HTTP ${response.statusCode}',
          'responseBody': response.body?.toString()
        };
      }
    } catch (e) {
      Get.snackbar(
        "Check-in Error",
        "An error occurred. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Return error response
      return {
        'success': false,
        'shiftId': shiftId,
        'error': e.toString(),
        'responseBody': null
      };
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkOut(String shiftId, String guardId, String latitude,
      String longitude, String selfieBase64) async {
    isLoading.value = true;
    try {
      final response = await apiService.checkOutGuard(
          shiftId, guardId, latitude, longitude, selfieBase64);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Stop monitoring after checkout
        await stopLocationMonitoring();

        // Clear stored shift and guard info
        _currentShiftId = null;
        _currentGuardId = null;
        _currentJobId = null;
        stopLocationMonitoring();
        Get.back();
        Get.snackbar(
          "Check-out Success",
          "You have successfully checked out.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Check-out Failed",
          "Could not check out. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Check-out Error",
        "An error occurred. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// -------------------------------
  /// 🔹 Location Monitoring Functions
  /// -------------------------------

  Future<void> startLocationMonitoring(
      String shiftId, String guardId, String jobId) async {
    try {
      // Store the current monitoring info
      _currentShiftId = shiftId;
      _currentGuardId = guardId;
      _currentJobId = jobId;

      // Check and request location permissions
      await _checkLocationPermissions();

      // Start continuous location tracking
      await _startLocationTracking();

      print("✅ Location monitoring started for shift: $shiftId");
    } catch (e) {
      print("❌ Error starting location monitoring: $e");
    }
  }

  Future<void> stopLocationMonitoring() async {
    try {
      // Stop location tracking
      await _stopLocationTracking();

      print("🛑 Location monitoring stopped");
    } catch (e) {
      print("❌ Error stopping location monitoring: $e");
    }
  }

  // Check and request location permissions
  Future<void> _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

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
  }

  // Start continuous location tracking
  Future<void> _startLocationTracking() async {
    // Get initial location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    // Send initial location
    _sendLocationToApi(
      _currentShiftId!,
      _currentGuardId!,
      position.latitude,
      position.longitude,
      _currentJobId!,
    );

    // Method 1: Use timer for periodic updates (every 30 seconds)
    _locationTimer = Timer.periodic(Duration(minutes: 5), (timer) async {
      try {
        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        _sendLocationToApi(
          _currentShiftId!,
          _currentGuardId!,
          currentPosition.latitude,
          currentPosition.longitude,
          _currentJobId!,
        );
      } catch (e) {
        print("❌ Timer location error: $e");
      }
    });

    // Method 2: Use location stream for continuous updates
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10, // Update every 10 meters
    );

    _locationStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      // This will update when significant movement occurs
      _sendLocationToApi(
        _currentShiftId!,
        _currentGuardId!,
        position.latitude,
        position.longitude,
        _currentJobId!,
      );
    });
  }

  // Stop location tracking
  Future<void> _stopLocationTracking() async {
    _locationTimer?.cancel();
    _locationTimer = null;

    await _locationStreamSubscription?.cancel();
    _locationStreamSubscription = null;
  }

  Future<void> _sendLocationToApi(String shiftId, String guardId,
      double latitude, double longitude, String jobId) async {
    try {
      await apiService.sendLocationToApi(
        shiftId,
        guardId,
        jobId,
        latitude,
        longitude,
      );
      print("📍 Location sent to API - Lat: ${latitude}, Lng: ${longitude}");
    } catch (e) {
      print("❌ Failed to send location to API: $e");
    }
  }

  // Add method to check if monitoring is active
  bool isMonitoringActive() {
    return _currentShiftId != null && _currentGuardId != null;
  }

  // Add method to get current monitoring info (for debugging)
  Map<String, String?> getMonitoringInfo() {
    return {
      'shiftId': _currentShiftId,
      'guardId': _currentGuardId,
      'jobId': _currentJobId,
    };
  }
}
