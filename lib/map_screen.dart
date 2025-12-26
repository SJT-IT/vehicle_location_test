import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key}); // Constructor with key parameter

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {}; // Marked as final

  // Database reference to Firebase
  final DatabaseReference _locationRef = FirebaseDatabase.instance.ref().child(
    "vehicle_state",
  );

  @override
  void initState() {
    super.initState();
    _listenForLocationUpdates();
  }

  // Function to listen to Firebase updates
  void _listenForLocationUpdates() {
    _locationRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      // Clear previous markers before adding new ones
      setState(() {
        _markers.clear();
      });

      // Iterate through the vehicles and update their markers
      data.forEach((vehicleId, vehicleData) {
        double latitude = vehicleData['lat'];
        double longitude = vehicleData['lng'];

        // Add a marker for each vehicle
        _addVehicleMarker(vehicleId, latitude, longitude);
      });
    });
  }

  // Function to add a vehicle marker to the map
  void _addVehicleMarker(String vehicleId, double latitude, double longitude) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(vehicleId), // Unique marker ID
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: vehicleId,
            snippet: "Speed: ${_getSpeed(vehicleId)} km/h", // Display speed
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ), // Custom marker color
        ),
      );
    });
  }

  // Function to get the speed of the vehicle
  String _getSpeed(String vehicleId) {
    final vehicleData = _markers.firstWhere(
      (marker) => marker.markerId.value == vehicleId,
      orElse: () => Marker(markerId: MarkerId(vehicleId)),
    );

    // Directly return the speed since vehicleData is not null
    return vehicleData.infoWindow.snippet ?? "N/A";
  }

  // Map creation function
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps - Vehicle Locations")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            28.61385687403875,
            77.20879029615766,
          ), // Default to first vehicle position
          zoom: 14.0,
        ),
        markers: _markers, // Set of markers to be shown on the map
      ),
    );
  }
}
