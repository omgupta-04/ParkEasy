import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ARNavigationScreen extends StatefulWidget {
  final List<LatLng> route;

  ARNavigationScreen({required this.route});

  @override
  _ARNavigationScreenState createState() => _ARNavigationScreenState();
}

class _ARNavigationScreenState extends State<ARNavigationScreen> {
  CameraController? _cameraController;
  double _direction = 0;
  Position? _currentPosition;
  LatLng? _nextPoint;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _startCompass();
    _getCurrentLocation();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0], // back camera
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    setState(() {});
  }

  void _startCompass() {
    FlutterCompass.events!.listen((CompassEvent event) {
      setState(() {
        _direction = event.heading ?? 0;
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _nextPoint = widget.route[1]; // For demo: pick next point
    });
  }

  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = _degToRad(from.latitude);
    final lon1 = _degToRad(from.longitude);
    final lat2 = _degToRad(to.latitude);
    final lon2 = _degToRad(to.longitude);

    final dLon = lon2 - lon1;
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    final brng = atan2(y, x);
    return (_radToDeg(brng) + 360) % 360;
  }

  double _degToRad(double deg) => deg * pi / 180;
  double _radToDeg(double rad) => rad * 180 / pi;

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    double arrowAngle = 0;
    if (_currentPosition != null && _nextPoint != null) {
      final from = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      final bearing = _calculateBearing(from, _nextPoint!);
      arrowAngle = (bearing - _direction) * pi / 180;
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Center(
            child: Transform.rotate(
              angle: arrowAngle,
              child: Icon(Icons.navigation, size: 80, color: Colors.red),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              "Heading: ${_direction.toStringAsFixed(1)}°",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, backgroundColor: Colors.black54),
            ),
          )
        ],
      ),
    );
  }
}



