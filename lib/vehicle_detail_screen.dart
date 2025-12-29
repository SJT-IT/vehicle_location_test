// import 'package:flutter/material.dart';

// class VehicleDetailScreen extends StatelessWidget {
//   final String vehicleId;

//   const VehicleDetailScreen({super.key, required this.vehicleId});

//   @override
//   Widget build(BuildContext context) {
//     // Placeholder data
//     final placeholderData = {
//       "model": "--",
//       "color": "--",
//       "odometer": "--",
//       "mileage": "--",
//       "fuelType": "--",
//       "registration": "--",
//       "lastService": "--",
//       "insuranceExpiry": "--",
//       "status": "Loading...",
//     };

//     return Scaffold(
//       appBar: AppBar(title: Text("Vehicle Details")),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
//         children: [
//           // Header
//           ListTile(
//             leading: Icon(
//               Icons.directions_car,
//               size: 60,
//               color: Colors.blueAccent,
//             ),
//             title: Text(
//               placeholderData["model"]!,
//               style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 8),
//                 Text(
//                   "Vehicle ID: $vehicleId",
//                   style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   "Status: ${placeholderData["status"]}",
//                   style: TextStyle(fontSize: 18, color: Colors.grey[800]),
//                 ),
//               ],
//             ),
//           ),
//           Divider(height: 40, thickness: 2),

//           // Vehicle Details
//           _buildListTile(Icons.color_lens, "Color", placeholderData["color"]!),
//           _buildListTile(Icons.speed, "Odometer", placeholderData["odometer"]!),
//           _buildListTile(
//             Icons.local_gas_station,
//             "Mileage",
//             placeholderData["mileage"]!,
//           ),
//           _buildListTile(
//             Icons.ev_station,
//             "Fuel Type",
//             placeholderData["fuelType"]!,
//           ),
//           _buildListTile(
//             Icons.confirmation_number,
//             "Registration",
//             placeholderData["registration"]!,
//           ),
//           _buildListTile(
//             Icons.build_circle,
//             "Last Service",
//             placeholderData["lastService"]!,
//           ),
//           _buildListTile(
//             Icons.assignment_turned_in,
//             "Insurance Expiry",
//             placeholderData["insuranceExpiry"]!,
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper to build a ListTile for each detail
//   Widget _buildListTile(IconData icon, String label, String value) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blueAccent, size: 28),
//       title: Text(
//         label,
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//       trailing: Text(
//         value,
//         style: TextStyle(fontSize: 20, color: Colors.grey[800]),
//       ),
//       contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
//     );
//   }
// }

import 'package:flutter/material.dart';

// Mock model class for Vehicle
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
    required this.status,
  });
}

class VehicleDetailScreen extends StatelessWidget {
  final String vehicleId;

  const VehicleDetailScreen({super.key, required this.vehicleId});

  // Simulate fetching vehicle data from DB
  Future<Vehicle> fetchVehicleFromDB(String id) async {
    // Simulate network/database delay
    await Future.delayed(Duration(seconds: 2));

    // Here you would normally query your DB
    // For now we return fake data
    return Vehicle(
      id: id,
      model: "E-Verito",
      color: "White",
      odometer: 30000,
      mileage: 200,
      fuelType: "Electric",
      registration: "AB12 XYZ",
      lastService: "2025-11-15",
      insuranceExpiry: "2026-04-30",
      status: "Active",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vehicle Details")),
      body: FutureBuilder<Vehicle>(
        future: fetchVehicleFromDB(vehicleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error state
            return Center(child: Text("Error fetching vehicle data"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No data found"));
          }

          // Data loaded
          final vehicle = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            children: [
              // Header
              ListTile(
                leading: Icon(
                  Icons.directions_car,
                  size: 60,
                  color: Colors.blueAccent,
                ),
                title: Text(
                  vehicle.model,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      "Vehicle ID: ${vehicle.id}",
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Status: ${vehicle.status}",
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
              Divider(height: 40, thickness: 2),

              // Vehicle details
              _buildListTile(Icons.color_lens, "Color", vehicle.color),
              _buildListTile(Icons.speed, "Odometer", "${vehicle.odometer} km"),
              _buildListTile(
                Icons.local_gas_station,
                "Mileage",
                "${vehicle.mileage} km/Full Charge",
              ),
              _buildListTile(Icons.ev_station, "Fuel Type", vehicle.fuelType),
              _buildListTile(
                Icons.confirmation_number,
                "Registration",
                vehicle.registration,
              ),
              _buildListTile(
                Icons.build_circle,
                "Last Service",
                vehicle.lastService,
              ),
              _buildListTile(
                Icons.assignment_turned_in,
                "Insurance Expiry",
                vehicle.insuranceExpiry,
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper to build a ListTile for each detail
  Widget _buildListTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent, size: 28),
      title: Text(
        label,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Text(
        value,
        style: TextStyle(fontSize: 20, color: Colors.grey[800]),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
    );
  }
}
