import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';

class OrderMap extends StatefulWidget {
  final List<PickupDetail> pickupDetails;
  final List<DropDetails> dropDetails;

  const OrderMap({super.key, required this.pickupDetails, required this.dropDetails});

  @override
  State<OrderMap> createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  List<LatLng> _polylinePoints = [];

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    if (widget.pickupDetails.length < 2) {
      print("At least two locations are required to calculate a route.");
      return;
    }

    // Prepare waypoints for the API
    final start = widget.pickupDetails[0];
    final end = widget.pickupDetails[widget.pickupDetails.length - 1];

    final startCoords = "${start.longitude},${start.latitude}";
    final endCoords = "${end.longitude},${end.latitude}";

    final url = Uri.parse(
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf624839696b657c394fb88fee53a5a0e97c0d&start=$startCoords&end=$endCoords");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract coordinates from the response
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
    return SizedBox(
      height: 300, // Set map height
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            widget.pickupDetails[0].latitude,
            widget.pickupDetails[0].longitude,
          ),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          // Add a MarkerLayer for all pickup locations
          MarkerLayer(
            markers: widget.pickupDetails.map((pickup) {
              return Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(pickup.latitude, pickup.longitude),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              );
            }).toList(),
          ),
          // Add the PolylineLayer for the route
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
    );
  }
}
