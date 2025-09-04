import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapShowWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const MapShowWidget({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  // مفتاح MapTiler
  final String mapTilerApiKey = "DkCr2lkmHILNyMYo7yMN";

  @override
  Widget build(BuildContext context) {
    // تحقق من الإحداثيات
    final hasValidCoordinates =
        latitude != null &&
        longitude != null &&
        latitude != 0.0 &&
        longitude != 0.0;

    if (!hasValidCoordinates) {
      return Center(
        child: Text(
          "لا توجد إحداثيات متاحة",
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    final point = LatLng(latitude!, longitude!);

    return SizedBox(
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            center: point,
            zoom: 14,
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$mapTilerApiKey",
              userAgentPackageName: 'com.yourapp.package',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
