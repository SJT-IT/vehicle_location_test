import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vehicle_tracker/vehicle_info_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  // Firebase reference
  final DatabaseReference _locationRef = FirebaseDatabase.instance.ref().child(
    "vehicle_state",
  );

  BitmapDescriptor? vehicleIcon;

  @override
  void initState() {
    super.initState();
    _loadVehicleIcon();
    _listenForLocationUpdates();
  }

  /// Load custom vehicle icon
  Future<void> _loadVehicleIcon() async {
    vehicleIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(96, 54)),
      'assets/images/blue.png',
    );
  }

  /// Listen to Firebase location updates
  void _listenForLocationUpdates() {
    _locationRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return;

      setState(() {
        _markers.clear();
      });

      data.forEach((vehicleId, vehicleData) {
        final double latitude = vehicleData['lat'];
        final double longitude = vehicleData['lng'];

        _addVehicleMarker(vehicleId, latitude, longitude);
      });
    });
  }

  /// Add vehicle marker
  void _addVehicleMarker(String vehicleId, double latitude, double longitude) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(vehicleId),
          position: LatLng(latitude, longitude),
          icon: vehicleIcon ?? BitmapDescriptor.defaultMarker,
          onTap: () {
            VehicleInfoBottomSheet.show(
              context: context,
              vehicleId: vehicleId,
              latitude: latitude,
              longitude: longitude,
              otherInfo: "Status: Active", // optional, can be null
            );
          },
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps - Vehicle Locations")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(28.61385687403875, 77.20879029615766),
          zoom: 14,
        ),
        markers: _markers,
      ),
    );
  }
}
