import 'package:flutter/material.dart';

/// Mock Vehicle model
class Vehicle {
  final String id;
  final String model;
  final String color;
  final int odometer;
  final double mileage;
  final String fuelType;
  final String registration;
  final String lastService;
  final String insuranceExpiry;
  final String pucExpiry;
  final String status;

  Vehicle({
    required this.id,
    required this.model,
    required this.color,
    required this.odometer,
    required this.mileage,
    required this.fuelType,
    required this.registration,
    required this.lastService,
    required this.insuranceExpiry,
    required this.pucExpiry,
    required this.status,
  });
}

class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;

  const VehicleDetailScreen({super.key, required this.vehicleId});

  /// Simulated DB call
  Future<Vehicle> fetchVehicleFromDB(String id) async {
    await Future.delayed(const Duration(seconds: 2));

    return Vehicle(
      id: id,
      model: "E-Verito",
      color: "White",
      odometer: 30000,
      mileage: 200,
      fuelType: "Electric",
      registration: "AB12 XYZ",
      lastService: "15 Nov 2025",
      insuranceExpiry: "30 Apr 2026",
      pucExpiry: "30 Apr 2026",
      status: "Active",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Vehicle Details"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<Vehicle>(
        future: fetchVehicleFromDB(vehicleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Failed to load vehicle data"));
          }

          final vehicle = snapshot.data!;

          return ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.black, Colors.transparent],
                stops: [0.0, 0.93, 1.0], // 👈 reduced bottom fade
              ).createShader(rect);
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(vehicle),

                _infoTile(Icons.color_lens_outlined, "Color", vehicle.color),
                _infoTile(
                  Icons.speed_outlined,
                  "Odometer",
                  "${vehicle.odometer} km",
                ),
                _infoTile(
                  Icons.ev_station_outlined,
                  "Mileage",
                  "${vehicle.mileage} km / Full Charge",
                ),
                _infoTile(Icons.bolt_outlined, "Fuel Type", vehicle.fuelType),
                _infoTile(
                  Icons.confirmation_number_outlined,
                  "Registration",
                  vehicle.registration,
                ),
                _infoTile(
                  Icons.build_outlined,
                  "Last Service",
                  vehicle.lastService,
                ),
                _infoTile(
                  Icons.verified_outlined,
                  "Insurance Expiry",
                  vehicle.insuranceExpiry,
                ),
                _infoTile(Icons.eco_outlined, "PUC", vehicle.pucExpiry),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Header card (avatar style like image)
  Widget _buildHeader(Vehicle vehicle) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.directions_car, size: 30, color: Colors.blue),
        ),
        title: Text(
          vehicle.model,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "Vehicle ID: ${vehicle.id}\nStatus: ${vehicle.status}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  /// Info rows with subtle icons
  Widget _infoTile(IconData icon, String label, String value) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, size: 20, color: Colors.blue.shade600),
        ),
        title: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
