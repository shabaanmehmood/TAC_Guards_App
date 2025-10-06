import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:tac/dataproviders/api_service.dart';
import 'package:tac/models/nearbyjob.dart';

class MapController extends GetxController {
  var markers = <Marker>{}.obs;
  var mapController = Rxn<GoogleMapController>();
  var userPath = <LatLng>[].obs;
  var jobPath = <LatLng>[].obs;
  String? darkMapStyle;
  var isLoading = true.obs;
  final myApiService = MyApIService();
  Timer? _periodicUpdateTimer;
  LatLng? _currentUserLocation;
  final Rx<JobNearby?> selectedJob = Rx<JobNearby?>(null);
  CameraPosition? _lastCameraPosition;

  @override
  void onInit() {
    super.onInit();
    // Load map style immediately when controller starts
    loadMapStyle();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await loadMapStyle();
    await requestAndSaveLocation();
  }

  @override
  void onClose() {
    _periodicUpdateTimer?.cancel();
    mapController.value?.dispose();
    super.onClose();
  }

  void onMarkerTapped(JobNearby job) {
    selectedJob.value = job;
  }

  void updateCameraPosition(CameraPosition position) {
    _lastCameraPosition = position;
  }

  Future<void> loadMapStyle() async {
    try {
      darkMapStyle =
          await rootBundle.loadString('assets/dark_map/dark_map.json');
      print("✅ Map style loaded successfully");

      // Apply style immediately if controller is available
      _applyMapStyle();
    } catch (e) {
      print("❌ Failed to load map style: $e");
      // Try alternative path
      try {
        darkMapStyle = await rootBundle.loadString('assets/dark_map.json');
        print("✅ Map style loaded from alternative path");
        _applyMapStyle();
      } catch (e2) {
        print("❌ Also failed with alternative path: $e2");
      }
    }
  }

  void _applyMapStyle() {
    if (darkMapStyle != null && mapController.value != null) {
      try {
        mapController.value!.setMapStyle(darkMapStyle);
        print("🎨 Map style applied successfully");
      } catch (e) {
        print("❌ Error applying map style: $e");
      }
    }
  }

  Future<double> getJobLocation(String latitude, String longitude) async {
    Location location = Location();

    // Check permissions
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == PermissionStatus.deniedForever) {
      // Never ask again: show info or handle gracefully
      throw Exception('Location permissions permanently denied.');
    }
    if (permissionGranted != PermissionStatus.granted) {
      throw Exception('Location permission denied.');
    }

    try {
      final userLocation = await location.getLocation();
      final LatLng userLatLng = LatLng(
        userLocation.latitude ?? 0.0,
        userLocation.longitude ?? 0.0,
      );

      final LatLng jobLocation = LatLng(
        double.parse(latitude),
        double.parse(longitude),
      );

      jobPath.value = [jobLocation];

      final double jobDistance = _calculateDistance(
        userLatLng.latitude,
        userLatLng.longitude,
        jobLocation.latitude,
        jobLocation.longitude,
      );

      // Use safe camera animation
      if (mapController.value != null) {
        await _safeAnimateCamera(CameraUpdate.newLatLng(jobLocation));
      }

      return jobDistance;
    } catch (e) {
      print('Error fetching location: $e');
      return -1;
    }
  }

  Future<void> _safeAnimateCamera(CameraUpdate update) async {
    try {
      if (mapController.value != null) {
        await mapController.value!.animateCamera(update);
      }
    } catch (e) {
      print('Camera animation failed: $e');
      // Fallback to moveCamera
      try {
        if (mapController.value != null) {
          await mapController.value!.moveCamera(update);
        }
      } catch (e2) {
        print('Move camera also failed: $e2');
      }
    }
  }

  Future<void> requestAndSaveLocation() async {
    isLoading.value = true;
    Location location = Location();

    try {
      // Check location service
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      // Check permissions
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission denied.');
        }
      }
      if (permissionGranted == PermissionStatus.deniedForever) {
        throw Exception('Location permissions permanently denied.');
      }

      // Get location
      final userLocation = await location.getLocation();
      _currentUserLocation =
          LatLng(userLocation.latitude ?? 0.0, userLocation.longitude ?? 0.0);

      userPath.value = [_currentUserLocation!];

      // Move camera to user location
      if (mapController.value != null) {
        final double zoom = _lastCameraPosition?.zoom ?? 15.0;
        await _safeAnimateCamera(
          CameraUpdate.newLatLngZoom(_currentUserLocation!, zoom),
        );
      }

      // Fetch nearby jobs
      await fetchUserLocations(
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
    try {
      final NearbyJobsResponses? jobsResponse =
          await myApiService.JobsLocations(latitude, longitude);

      if (jobsResponse == null) {
        print('No jobs response received');
        return;
      }

      print('API response: ${jobsResponse.data.length} jobs found');

      final newMarkers = <Marker>{};

      // ✅ User marker
      if (_currentUserLocation != null) {
        final userIcon = await _createUserMarker("assets/a.jpg");
        newMarkers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: _currentUserLocation!,
            icon: userIcon,
            infoWindow: const InfoWindow(title: 'You'),
          ),
        );
      }

      // ✅ Jobs markers
      for (final JobNearby job in jobsResponse.data) {
        final double lat = double.tryParse(job.jobLatitude) ?? 0.0;
        final double lng = double.tryParse(job.jobLongitude) ?? 0.0;
        if (lat == 0.0 && lng == 0.0) continue;

        final LatLng position = LatLng(lat, lng);

        // ✅ Use API image if available, otherwise fallback to asset
        String contractorImageUrl =
            "assets/userpicture.jpg"; // Default fallback

        // Uncomment and use this section when you have API images
        /*
      if (job.contractorProfileImages.isNotEmpty) {
        final mainImage = job.contractorProfileImages.firstWhere(
          (image) => image.isMain == 1,
          orElse: () => job.contractorProfileImages.first,
        );
        if (mainImage.url.isNotEmpty) {
          contractorImageUrl = "$baseurl${mainImage.url}";
        }
      }
      */

        final customMarkerIcon =
            await _createCustomMarker(contractorImageUrl, job.payPerHour);

        newMarkers.add(
          Marker(
            markerId: MarkerId('job_${job.jobId}'),
            position: position,
            icon: customMarkerIcon ??
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
            onTap: () => onMarkerTapped(job),
          ),
        );
      }

      // ✅ Replace markers safely
      markers.value = newMarkers;
    } catch (e) {
      print("❌ Error fetching jobs: $e");
    }
  }

  void clearSelectedJob() {
    selectedJob.value = null;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // --- ✅ Marker Drawing with Badge ---
// --- ✅ Marker Drawing with Badge ---
  Future<BitmapDescriptor> _createImageMarker(
    String imageUrl, {
    double size = 150,
    String? overlayText,
  }) async {
    ui.Image? finalImage;
    ui.Image? frameImage;

    try {
      Uint8List imageBytes;

      // Try to load the image from API URL first
      if (imageUrl.startsWith('http')) {
        try {
          imageBytes =
              (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
                  .buffer
                  .asUint8List();
        } catch (e) {
          print("❌ Failed to load network image: $e, falling back to asset");
          // Fallback to asset image if network image fails
          imageBytes = (await rootBundle.load("assets/userpicture.jpg"))
              .buffer
              .asUint8List();
        }
      } else {
        // It's already an asset path, try to load it
        try {
          imageBytes = (await rootBundle.load(imageUrl)).buffer.asUint8List();
        } catch (e) {
          print(
              "❌ Failed to load asset image: $e, falling back to default asset");
          // Fallback to default asset image
          imageBytes = (await rootBundle.load("assets/userpicture.jpg"))
              .buffer
              .asUint8List();
        }
      }

      final ui.Codec codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: size.toInt(),
        targetHeight: size.toInt(),
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      frameImage = frameInfo.image;

      // Calculate dimensions - place badge BELOW the image
      final bool hasBadge = overlayText != null && overlayText.isNotEmpty;
      final double badgeHeight = 35.0;
      final double badgeWidth = size * 0.9;
      final double totalHeight = size + (hasBadge ? badgeHeight + 8 : 0);
      final double totalWidth = size;

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      final double centerX = size / 2;
      final double imageCenterY = size / 2;

      // Draw circular background for image
      final Paint circlePaint = Paint()..color = const Color(0xFF00D3FF);
      canvas.drawCircle(Offset(centerX, imageCenterY), size / 2, circlePaint);

      // Draw the image clipped to a circle
      final Rect imageRect = Rect.fromCircle(
        center: Offset(centerX, imageCenterY),
        radius: (size / 2) - 4,
      );

      canvas.save();
      canvas.clipPath(Path()..addOval(imageRect));
      paintImage(
        canvas: canvas,
        rect: imageRect,
        image: frameImage,
        fit: BoxFit.cover,
      );
      canvas.restore();

      // Draw price badge at the BOTTOM
      if (hasBadge) {
        final double badgeLeft = (size - badgeWidth) / 2;
        final double badgeTop = size + 4; // Position below the circle

        // Draw blue rounded rectangle for price badge
        final Paint badgePaint = Paint()..color = const Color(0xFF00D3FF);
        final Rect badgeRect =
            Rect.fromLTWH(badgeLeft, badgeTop, badgeWidth, badgeHeight);
        canvas.drawRRect(
          RRect.fromRectAndRadius(badgeRect, const Radius.circular(8)),
          badgePaint,
        );

        // Create text paragraph
        final textStyle = ui.TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        );

        final paragraphBuilder = ui.ParagraphBuilder(
          ui.ParagraphStyle(
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        )
          ..pushStyle(textStyle)
          ..addText(overlayText!);

        final paragraph = paragraphBuilder.build();
        paragraph.layout(ui.ParagraphConstraints(width: badgeWidth - 8));

        // Draw text centered in badge
        canvas.drawParagraph(
          paragraph,
          Offset(
            badgeLeft + (badgeWidth - paragraph.width) / 2,
            badgeTop + (badgeHeight - paragraph.height) / 2,
          ),
        );
      }

      finalImage = await recorder
          .endRecording()
          .toImage(totalWidth.toInt(), totalHeight.toInt());
      final ByteData? pngBytes =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);

      if (pngBytes == null) {
        throw Exception('Failed to convert image to bytes');
      }

      print("✅ Marker created with badge: $overlayText");
      return BitmapDescriptor.fromBytes(pngBytes.buffer.asUint8List());
    } catch (e) {
      print("❌ Error creating marker: $e");
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    } finally {
      // Clean up images to prevent memory leaks
      finalImage?.dispose();
      frameImage?.dispose();
    }
  }

  Future<BitmapDescriptor> _createUserMarker(String imageUrl) async {
    return await _createImageMarker(imageUrl, size: 160);
  }

  Future<BitmapDescriptor?> _createCustomMarker(
      String imageUrl, String payPerHour) async {
    return await _createImageMarker(
      imageUrl,
      size: 160,
      overlayText: "£$payPerHour/hr",
    );
  }

  void setMapController(GoogleMapController controller) {
    mapController.value = controller;
    _applyMapStyle(); // Apply style when controller is set

    // Add retry mechanism to ensure style is applied
    Future.delayed(Duration(milliseconds: 100), _applyMapStyle);
    Future.delayed(Duration(milliseconds: 500), _applyMapStyle);
  }
}
