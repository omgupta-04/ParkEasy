// import 'dart:async';
// import 'dart:math';
// import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
//
// class ARLiveNavigation extends StatefulWidget {
//   final List<LatLng> route;
//   const ARLiveNavigation({required this.route, super.key});
//
//   @override
//   State<ARLiveNavigation> createState() => _ARLiveNavigationState();
// }
//
// class _ARLiveNavigationState extends State<ARLiveNavigation> {
//   late ArCoreController arCoreController;
//   final List<ArCoreNode> activeNodes = [];
//   Position? currentPosition;
//   StreamSubscription<Position>? positionStream;
//   final int visibleCount = 5;
//
//   @override
//   void dispose() {
//     arCoreController.dispose();
//     positionStream?.cancel();
//     super.dispose();
//   }
//
//   void onArCoreViewCreated(ArCoreController controller) {
//     arCoreController = controller;
//     _startLiveLocationUpdates();
//   }
//
//   void _startLiveLocationUpdates() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
//         return;
//       }
//     }
//
//     positionStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 5),
//     ).listen((Position pos) {
//       currentPosition = pos;
//       _updateVisibleWaypoints();
//     });
//   }
//
//   double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const earthRadius = 6371000; // in meters
//     final dLat = _degreesToRadians(lat2 - lat1);
//     final dLon = _degreesToRadians(lon2 - lon1);
//
//     final a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_degreesToRadians(lat1)) *
//             cos(_degreesToRadians(lat2)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);
//
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return earthRadius * c;
//   }
//
//   double _degreesToRadians(double degrees) {
//     return degrees * pi / 180;
//   }
//
//   void _updateVisibleWaypoints() {
//     if (currentPosition == null) return;
//
//     final userLatLng = LatLng(currentPosition!.latitude, currentPosition!.longitude);
//
//     // Sort route points by distance to user
//     final sorted = widget.route
//         .asMap()
//         .entries
//         .map((e) => MapEntry(
//       e.key,
//       calculateDistance(
//         userLatLng.latitude,
//         userLatLng.longitude,
//         e.value.latitude,
//         e.value.longitude,
//       ),
//     ))
//         .where((entry) => entry.value < 200)
//         .toList()
//       ..sort((a, b) => a.value.compareTo(b.value));
//
//
//     // Take nearest N route points ahead of user
//     final visibleIndexes = sorted.map((e) => e.key).take(visibleCount).toList();
//
//     // Clear old spheres
//     for (final node in activeNodes) {
//       arCoreController.removeNode(nodeName: node.name);
//     }
//     activeNodes.clear();
//
//     for (final i in visibleIndexes) {
//       final zOffset = -1.5 * visibleIndexes.indexOf(i); // spaced in AR view
//       final sphere = ArCoreSphere(
//         materials: [ArCoreMaterial(color: Colors.blue)],
//         radius: 0.05,
//       );
//
//       final node = ArCoreNode(
//         name: 'sphere_$i',
//         shape: sphere,
//         position: vector.Vector3(0, 0, zOffset),
//       );
//
//       arCoreController.addArCoreNode(node);
//       activeNodes.add(node);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Live AR Navigation')),
//       body: ArCoreView(onArCoreViewCreated: onArCoreViewCreated),
//     );
//   }
// }

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ARNavigationScreen extends StatefulWidget {
  final List<LatLng> route;

  ARNavigationScreen({required this.route});

  @override
  _ARNavigationScreenState createState() => _ARNavigationScreenState();
}

class _ARNavigationScreenState extends State<ARNavigationScreen> {
  late ArCoreController arCoreController;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    // Place 3D spheres along the route points (simplified to fixed distance spacing)
    for (int i = 0; i < widget.route.length; i += 5) {
      _addSphere(vector.Vector3(0, 0, -1.5 - (i / 5))); // space 1.5m apart
    }
  }

  void _addSphere(vector.Vector3 position) {
    final material = ArCoreMaterial(color: Colors.blue);
    final sphere = ArCoreSphere(materials: [material], radius: 0.05);
    final node = ArCoreNode(
      shape: sphere,
      position: position,
    );
    arCoreController.addArCoreNode(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR Navigation")),
      body: ArCoreView(
        onArCoreViewCreated: onArCoreViewCreated,
        enableTapRecognizer: false,
      ),
    );
  }
}

