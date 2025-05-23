import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ar_screen.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _sourceLocation;
  LatLng? _destinationLocation;
  Set<Polyline> _polylines = {};


  TextEditingController _sourceController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    await Permission.location.request();
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _sourceLocation = LatLng(position.latitude, position.longitude);
      _sourceController.text =
      "${position.latitude}, ${position.longitude}"; // default fill
    });
  }

  void _onMapTapped(LatLng position) async{
    setState(() {
      _destinationLocation = position;
      _destinationController.text =
      "${position.latitude}, ${position.longitude}";
    });
    await _getRoutePolyline();
  }

  Future<LatLng?> _getLatLngFromText(String input) async {
    try {
      if (input.contains(',')) {
        final parts = input.split(',');
        return LatLng(double.parse(parts[0]), double.parse(parts[1]));
      } else {
        List<Location> locations = await locationFromAddress(input);
        if (locations.isNotEmpty) {
          return LatLng(locations[0].latitude, locations[0].longitude);
        }
      }
    } catch (e) {
      print("Failed to convert to LatLng: $e");
    }
    return null;
  }

  Future<void> _updateLocationsFromText() async {
    final source = await _getLatLngFromText(_sourceController.text);
    final destination = await _getLatLngFromText(_destinationController.text);
    if (source != null && destination != null) {
      setState(() {
        _sourceLocation = source;
        _destinationLocation = destination;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(source));
      await _getRoutePolyline();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid coordinates or location")),
      );
    }
  }

  Future<void> _getRoutePolyline() async {
    if (_sourceLocation == null || _destinationLocation == null) return;

    final url =
        "https://router.project-osrm.org/route/v1/driving/${_sourceLocation!.longitude},${_sourceLocation!.latitude};${_destinationLocation!.longitude},${_destinationLocation!.latitude}?overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final geometry = data['routes'][0]['geometry'];
      final coordinates = geometry['coordinates'] as List;

      final List<LatLng> polylinePoints = coordinates
          .map((point) => LatLng(point[1], point[0]))
          .toList();

      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: polylinePoints,
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    } else {
      print("Failed to load route");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Route')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _sourceController,
                  decoration: InputDecoration(
                    labelText: "Source (lat,lng or address)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: "Destination (lat,lng or address)",
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: _updateLocationsFromText,
                  child: Text("Set Locations"),
                )
              ],
            ),
          ),
          Expanded(
            child: _sourceLocation == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
              polylines: _polylines,
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _sourceLocation!,
                zoom: 14,
              ),
              markers: {
                if (_sourceLocation != null)
                  Marker(
                    markerId: MarkerId("source"),
                    position: _sourceLocation!,
                    infoWindow: InfoWindow(title: "Source"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen),
                  ),
                if (_destinationLocation != null)
                  Marker(
                    markerId: MarkerId("destination"),
                    position: _destinationLocation!,
                    infoWindow: InfoWindow(title: "Destination"),
                  ),
              },
              onTap: _onMapTapped,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_polylines.isNotEmpty) {
                final polyline = _polylines.first;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ARNavigationScreen(route: polyline.points),
                  ),
                );
              }
            },
            child: Text("Start AR Navigation"),
          ),

        ],
      ),
    );
  }
}
