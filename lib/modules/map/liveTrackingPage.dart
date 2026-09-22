import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tac/controllers/mapController.dart';
//
// class Livetrackingpage extends StatefulWidget {
//   const Livetrackingpage({super.key});
//
//   @override
//   State<Livetrackingpage> createState() => _LivetrackingpageState();
// }
//
// class _LivetrackingpageState extends State<Livetrackingpage> {
//
//   LatLng sourceLocation = const LatLng(37.7749, -122.4194); // Example coordinates
//   LatLng destinationLocation = const LatLng(34.0522, -118.2437); // Example coordinates
//
//   final Completer<GoogleMapController> _controller = Completer();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: sourceLocation,
//         zoom: 13,
//       ),
//       markers: {
//         Marker(
//           markerId: const MarkerId('source'),
//           position: sourceLocation,
//           infoWindow: const InfoWindow(title: 'Source Location'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//         Marker(
//           markerId: const MarkerId('destination'),
//           position: destinationLocation,
//           infoWindow: const InfoWindow(title: 'Destination Location'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         ),
//       },
//       onMapCreated: (controller) {
//         _controller.complete(controller);
//       },
//       myLocationButtonEnabled: true,
//       myLocationEnabled: true,
//
//     );
//   }
// }

// // Dark map style JSON
const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
''';


class JobsMapView extends StatelessWidget {
  final MapController controller = Get.put(MapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              // Show loading indicator while fetching location or data
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.lightBlue,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Fetching nearby jobs...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Show map when data is loaded
              return Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: controller.userPath.isNotEmpty
                        ? controller.userPath.first
                        : MapController.australiaMapCenter,
                    zoom: controller.userPath.isNotEmpty
                        ? 15
                        : MapController.australiaMapZoom,
                  ),
                  markers: controller.markers.value,
                  onMapCreated: controller.setMapController,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              );
            }
          }),
          // Optional: Add a refresh button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              onPressed: () => controller.requestAndSaveLocation(),
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}
