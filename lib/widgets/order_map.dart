import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart'; // For location tracking
import 'package:permission_handler/permission_handler.dart'; // For permission handling
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

class OrderMap extends StatefulWidget {
  final List<PickupDetail> pickupDetails;
  final List<DropDetails> dropDetails;

  const OrderMap({
    super.key,
    required this.pickupDetails,
    required this.dropDetails,
  });

  @override
  State<OrderMap> createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  late final MapController _mapController;
  LatLng? _currentLocation;
  List<LatLng> _polylinePoints = [];
  final double _radius = 200; // Geofence radius in meters
  final Color _geofenceColor = Colors.blue.withOpacity(0.2);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
    _fetchRoute();
  }

  Future<void> _getCurrentLocation() async {
    // Check if location permission is granted
    PermissionStatus permission = await Permission.location.status;

    if (permission == PermissionStatus.denied) {
      // Request permission if denied
      permission = await Permission.location.request();
      if (permission != PermissionStatus.granted) {
        print("Location permission denied.");
        return;
      }
    }

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Move the map to the current location
    _mapController.move(_currentLocation!, 15); // Zoom level 15
  }

  Future<void> _fetchRoute() async {
    if (widget.pickupDetails.isEmpty || widget.dropDetails.isEmpty) {
      print("Pickup and drop locations are required to calculate a route.");
      return;
    }

    final start = widget.pickupDetails[0];
    final end = widget.dropDetails[widget.dropDetails.length - 1];

    final startCoords = "${start.longitude},${start.latitude}";
    final endCoords = "${end.longitude},${end.latitude}";

    final url = Uri.parse(
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf624839696b657c394fb88fee53a5a0e97c0d&start=$startCoords&end=$endCoords");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final coordinates =
            (data['features'][0]['geometry']['coordinates'] as List)
                .map((coord) => LatLng(coord[1], coord[0]))
                .toList();

        setState(() {
          _polylinePoints = coordinates;
        });
      } else {
        print("Failed to fetch route: ${response.body}");
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ??
                  const LatLng(0.0, 0.0), // Default to (0, 0) if unavailable
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (_currentLocation != null) ...[
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 60,
                      height: 60,
                      child: const Icon(
                        Icons.circle_sharp,
                        size: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _currentLocation!,
                      color: _geofenceColor,
                      borderStrokeWidth: 2,
                      borderColor: Colors.blue,
                      useRadiusInMeter: true,
                      radius: _radius,
                    ),
                  ],
                ),
              ],
              MarkerLayer(
                markers: [
                  ...widget.pickupDetails.map((pickup) => Marker(
                        point: LatLng(pickup.latitude, pickup.longitude),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      )),
                  ...widget.dropDetails.map((drop) => Marker(
                        point: LatLng(drop.latitude, drop.longitude),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 40.0,
                        ),
                      )),
                ],
              ),
              if (_polylinePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _polylinePoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 95,
            right: 16,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.my_location,
                color: Colors.redAccent,
              ),
            ),
          ),
          // Placeholder for draggable widget
        ],
      ),
    );
  }
}
