import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tac/controllers/mapController.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/models/nearbyjob.dart';
import 'dummy_data.dart';
import 'job_live_controller.dart';

class JobLiveScreen extends StatelessWidget {
  final JobLiveController controller = Get.put(JobLiveController());
  final MapController mapController = Get.find<MapController>();
  final Map<String, dynamic> Data;

  JobLiveScreen({super.key, required this.Data}) {
    _initializeTimer();
    _setupJobMarker();
  }

  void _initializeTimer() {
    // Pass the complete API data to controller
    controller.completeApiData = Data;

    final shiftData = Data['responseBody']['data']['shift'];
    if (shiftData != null) {
      controller.setShiftStartTime(shiftData['startTime'] ?? 'N/A');
    }
  }

  void _setupJobMarker() {
    final jobData = Data['responseBody']['data']['job'];

    if (jobData != null) {
      final lat = double.tryParse(jobData['latitude']?.toString() ?? '0.0');
      final lng = double.tryParse(jobData['longitude']?.toString() ?? '0.0');

      if (lat != null && lng != null && lat != 0.0 && lng != 0.0) {
        final position = LatLng(lat, lng);
        mapController.jobPath.value = [position];
        print("✅ Job location set at: $position (No red marker)");
      } else {
        print("❌ Invalid job coordinates: lat=$lat, lng=$lng");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(AppAssets.kBack, width: 24, height: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Job Details',
          style: TextStyle(color: AppColors.kWhite, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text("Need Support?",
                  style: TextStyle(color: Colors.lightBlue)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildShiftCard(),
                  const SizedBox(height: 16),
                  _buildLocationCard(),
                  const SizedBox(height: 16),
                  _buildCheckInCard(),
                  const SizedBox(height: 8),
                  _buildManagerCard(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    String title = Data['responseBody']['data']['job']['title'] ?? 'N/A';
    String? rate =
        Data['responseBody']['data']['job']['payPerHour']?.toString();
    String? name = Data['responseBody']['data']['shift']['job']?['contractor']
            ['name'] ??
        '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF141927),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      name ?? dummyJob['name']!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 6),
                    const Text("Actor", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Job Details",
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      AppAssets.kShare,
                      width: 16,
                      height: 16,
                      color: Colors.lightBlue,
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: [
              Text(
                rate != null ? "\$$rate/hr" : "N/A",
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildShiftCard() {
    final shiftData = Data['responseBody']['data']['shift'];
    final startTime = shiftData['startTime'] ?? 'N/A';
    final endTime = shiftData['endTime'] ?? 'N/A';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Shift",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Obx(() => Text(
                    controller.shiftStatus.value,
                    style: TextStyle(
                      color: _getStatusColor(controller.shiftStatus.value),
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Shift Time $startTime - $endTime",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Center(
            child: Obx(() => Text(
                  controller.timerText.value,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _getTimerColor(controller.timerText.value),
                  ),
                )),
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.shiftStatus.value == "WAITING FOR SHIFT TIME") {
              return const Text(
                "Timer will start automatically when shift begins",
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              );
            } else if (controller.shiftStatus.value == "IN PROGRESS") {
              return const Text(
                "Shift in progress - timer will auto-complete at end time",
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              );
            } else if (controller.shiftStatus.value == "COMPLETED") {
              return const Text(
                "Shift completed! Navigating...",
                style: TextStyle(color: Colors.green, fontSize: 12),
                textAlign: TextAlign.center,
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "IN PROGRESS":
        return const Color(0xFF3677FF);
      case "COMPLETED":
        return Colors.green;
      case "WAITING FOR SHIFT TIME":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getTimerColor(String timerText) {
    return Colors.white;
  }

  Widget _buildLocationCard() {
    String location = Data['responseBody']['data']['job']['location'] ??
        dummyJob['location']!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Live Location Alerts",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Icon(Icons.info_outline, color: Colors.white30, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.circle, size: 12, color: Colors.green),
              SizedBox(width: 8),
              Text("You are on track.",
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildGoogleMap(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _openDirections(location);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text("Get Directions",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Obx(() {
        final hasMarkers = mapController.markers.isNotEmpty;
        final hasJobPath = mapController.jobPath.isNotEmpty;

        LatLng cameraTarget;

        if (hasJobPath) {
          cameraTarget = mapController.jobPath.first;
        } else if (hasMarkers) {
          cameraTarget = mapController.markers.value.first.position;
        } else {
          cameraTarget = const LatLng(33.6844, 73.0479);
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: cameraTarget,
            zoom: 15,
          ),
          markers: mapController.markers.value,
          onMapCreated: (GoogleMapController googleMapController) {
            mapController.setMapController(googleMapController);

            if (hasJobPath && mapController.mapController.value != null) {
              Future.delayed(const Duration(milliseconds: 500), () {
                mapController.mapController.value?.animateCamera(
                  CameraUpdate.newLatLngZoom(mapController.jobPath.first, 15),
                );
              });
            }
          },
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: false,
          onCameraMove: mapController.updateCameraPosition,
        );
      }),
    );
  }

  void _openDirections(String location) {
    final String url =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}';

    Get.snackbar(
      "Get Directions",
      "Would open: $url",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  Widget _buildCheckInCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.kCal,
              width: 24, height: 24, color: Colors.white60),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Check In Status", style: TextStyle(color: Colors.white)),
                SizedBox(height: 4),
                Text("Already Checked In - Waiting for shift start",
                    style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Checked In",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagerCard() {
    String managerName = Data['responseBody']['data']['job']
            ['reportingManagerName'] ??
        "Hitesh Sapara";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.kCal,
              width: 24, height: 24, color: Colors.white60),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(managerName, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                const Text("Reporting Manager",
                    style: TextStyle(color: Colors.white38)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.phone, color: Colors.white, size: 16),
          )
        ],
      ),
    );
  }

 // ... (all other methods remain exactly the same)

Widget _buildBottomSection() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Divider(color: AppColors.kinput),
      Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        decoration: const BoxDecoration(
          color: Color(0xFF0A0E21),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: controller.checkboxValue.value,
                      onChanged: (val) {
                        controller.checkboxValue.value = val ?? false;
                      },
                      activeColor: Colors.lightBlueAccent,
                    ),
                    const Expanded(
                      child: Text(
                        "I confirm that I am intentionally ending my shift before the scheduled time. I understand that this action cannot be undone and may require supervisor approval.",
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    )
                  ],
                )),
            const SizedBox(height: 12),
            Obx(() => ElevatedButton(
                  onPressed: controller.checkboxValue.value &&
                          !controller.isNavigating.value
                      ? () {
                          print("🔄 Close My Shift button pressed");
                          controller.handleManualShiftClosure();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    disabledBackgroundColor: AppColors.kSkyBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isNavigating.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text("Close My Shift",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                )),
          ],
        ),
      ),
    ],
  );
}
}
