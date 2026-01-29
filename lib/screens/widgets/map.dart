import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTestScreen extends StatelessWidget {
  const MapTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Map Test")),
      body: GoogleMap(
        initialCameraPosition:
        const CameraPosition(target: LatLng(28.6139, 77.2090), zoom: 14),
        onMapCreated: (controller) {
          print("Map created successfully!");
        },
      ),
    );
  }
}
