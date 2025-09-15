import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tac/dataproviders/api_service.dart';

import '../models/job_model.dart';

class MapController extends GetxController {
  var markers = <Marker>{}.obs;
  var mapController = Rxn<GoogleMapController>();
  var userPath = <LatLng>[].obs;
  var jobPath = <LatLng>[].obs;
  var isLoading = true.obs;
  final myApiService = MyApIService();
  Timer? _periodicUpdateTimer;
  LatLng? _currentUserLocation;

  @override
  void onInit() {
    super.onInit();
    requestAndSaveLocation();
    // Set up periodic updates every 30 seconds
    _periodicUpdateTimer = Timer.periodic(Duration(seconds: 60), (timer) {
      requestAndSaveLocation();
    });
  }

  @override
  void onClose() {
    _periodicUpdateTimer?.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _periodicUpdateTimer?.cancel();
    mapController.value?.dispose();
    markers.clear();
    userPath.clear();
    jobPath.clear();
    _currentUserLocation = null;

  }

  Future<double> getJobLocation(String latitude, String longitude) async {
    Location location = Location();
    late LatLng jobLocation;
    double jobDistance;
    final userLocation = await location.getLocation();
    LatLng? _UserLocation;

    // Check for permission
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission denied.');
      }
    }

    try {
      _UserLocation = LatLng(
        userLocation.latitude ?? 0.0,
        userLocation.longitude ?? 0.0,
      );

      jobLocation = LatLng(
        double.parse(latitude),
        double.parse(longitude),
      );

      jobPath.value = [jobLocation!];

      // Make sure _calculateDistance is defined and returns double
      jobDistance = _calculateDistance(
        _UserLocation!.latitude,
        _UserLocation!.longitude,
        jobLocation.latitude,
        jobLocation.longitude,
      );

      // Animate camera if mapController is defined and initialized
      if (mapController.value != null) {
        Future.delayed(
          Duration(milliseconds: 250),
          () {
            mapController.value!.animateCamera(
              CameraUpdate.newLatLng(jobLocation),
            );
          },
        );
      }

      return jobDistance;
    } catch (e) {
      print('Error fetching location: $e');
      return -1;
    } finally {
      // isLoading.value = false; // Optionally reset loading state here
    }
  }

  Future<void> requestAndSaveLocation() async {
    isLoading.value = true;
    Location location = Location();

    // Check if service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        isLoading.value = false;
        throw Exception('Location services are disabled.');
      }
    }

    // Check for permission
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        isLoading.value = false;
        throw Exception('Location permission denied.');
      }
    }

    if (permissionGranted == PermissionStatus.deniedForever) {
      isLoading.value = false;
      throw Exception('Location permissions are permanently denied.');
    }

    try {
      // Get current location
      final userLocation = await location.getLocation();
      _currentUserLocation = LatLng(
          userLocation.latitude ?? 0.0,
          userLocation.longitude ?? 0.0
      );

      userPath.value = [_currentUserLocation!];

      // Move camera to user location if map controller exists
      if (mapController.value != null) {
        mapController.value!.animateCamera(
          CameraUpdate.newLatLng(_currentUserLocation!),
        );
      }

      // Fetch nearby jobs using current location
      await fetchUserLocations(
        // (42.1155000).toString(),
        // (-72.5395000).toString(),
        (userLocation.latitude ?? 0.0).toStringAsFixed(4),
        (userLocation.longitude ?? 0.0).toStringAsFixed(4),
      );

    } catch (e) {
      print('Error fetching location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserLocations(String latitude, String longitude) async {
    final jobsResponse = await myApiService.fetchJobsLocations(latitude, longitude);
    print('API response: ${jobsResponse?.data?.length} jobs found');


    if (jobsResponse != null && jobsResponse.status == 200) {
      markers.clear();

      // Create a marker for the user's current location
      if (_currentUserLocation != null) {
        markers.add(
          Marker(
            markerId: MarkerId('user_location'),
            position: _currentUserLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
        );
      }

      List<JobData> jobsList = jobsResponse.data;

      // Animate camera to the first job marker, if available
      if (jobsList.isNotEmpty && mapController.value != null) {
        final firstJob = jobsList[0];
        final double lat = double.tryParse(firstJob.latitude!) ?? 0.0;
        final double lng = double.tryParse(firstJob.longitude!) ?? 0.0;
        final LatLng position = LatLng(lat, lng);

        // Animate camera to the job location
        mapController.value!.animateCamera(
          CameraUpdate.newLatLngZoom(position, 0.5),
        );
      }

      // Create markers for each job
      for (var i = 0; i < jobsList.length; i++) {
        final job = jobsList[i];
        final double lat = double.tryParse(job.latitude!) ?? 0.0;
        final double lng = double.tryParse(job.longitude!) ?? 0.0;
        final LatLng position = LatLng(lat, lng);

        // Calculate distance from user's current location
        double distanceInKm = 0.0;
        if (_currentUserLocation != null) {
          distanceInKm = _calculateDistance(
              _currentUserLocation!.latitude,
              _currentUserLocation!.longitude,
              lat,
              lng
          );
        } else {
          distanceInKm = job.distance!;
        }

        // Create custom marker icon with sky blue color
        final customMarkerIcon = await _createCustomMarker(job.title, distanceInKm);

        markers.add(Marker(
          markerId: MarkerId('job_${job.id}'),
          position: position,
          icon: customMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          infoWindow: InfoWindow(
            title: job.title,
            snippet: '${distanceInKm.toStringAsFixed(1)} Km away • £${job.payPerHour}/hr',
          ),
          onTap: () {
            // Optionally, you can handle marker tap here
            print("Marker tapped: ${job.title}");
          },
        ));
      }
    } else {
      print("Failed to fetch job locations or empty response.");
    }
  }

  // Calculate distance between two coordinates using the Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of the earth in km
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Create a custom marker icon with BitmapDescriptor
  Future<BitmapDescriptor?> _createCustomMarker(String title, double distanceKm) async {
    // Using default marker with sky blue color (hueCyan)
    // For more customization, you would need to use BitmapDescriptor.fromAssetImage
    // or create a custom widget and use BitmapDescriptor.fromBytes with RepaintBoundary
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
  }


  void setMapController(GoogleMapController controller) {
    mapController.value = controller;
  }
}