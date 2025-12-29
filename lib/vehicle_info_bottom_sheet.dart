import 'package:flutter/material.dart';
import 'vehicle_detail_screen.dart'; // replace with your detail screen

class VehicleInfoBottomSheet {
  static void show({
    required BuildContext context,
    required String vehicleId,
    required double latitude,
    required double longitude,
    String? otherInfo,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Vehicle: $vehicleId",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Latitude: $latitude\nLongitude: $longitude",
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                ),
              ),
              if (otherInfo != null) ...[
                const SizedBox(height: 8),
                Text(
                  otherInfo,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(180),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close the bottom sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VehicleDetailScreen(vehicleId: vehicleId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("More Details"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
