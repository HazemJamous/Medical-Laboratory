import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerWidget extends StatefulWidget {
  final Function(LatLng) onLocationSelected; // ترجع الموقع للمستدعي

  const MapPickerWidget({super.key, required this.onLocationSelected});

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  LatLng? selectedPoint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // ارتفاع الخريطة
      child: FlutterMap(
        options: MapOptions(
          
          initialCenter: LatLng(33.5104, 36.2783), // ✅ دمشق كمثال
          initialZoom: 13,
          onTap: (tapPos, point) {
            setState(() => selectedPoint = point);
            widget.onLocationSelected(point); // نرسل الإحداثيات
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          if (selectedPoint != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: selectedPoint!,
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
