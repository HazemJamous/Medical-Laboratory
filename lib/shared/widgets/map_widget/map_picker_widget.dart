// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class MapPickerWidget extends StatefulWidget {
//   final Function(LatLng) onLocationSelected; // ترجع الموقع للمستدعي

//   const MapPickerWidget({super.key, required this.onLocationSelected});

//   @override
//   State<MapPickerWidget> createState() => _MapPickerWidgetState();
// }

// class _MapPickerWidgetState extends State<MapPickerWidget> {
//   LatLng? selectedPoint;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300, // ارتفاع الخريطة
//       child: FlutterMap(
//         options: MapOptions(

//           initialCenter: LatLng(33.5104, 36.2783), // ✅ دمشق كمثال
//           initialZoom: 13,
//           onTap: (tapPos, point) {
//             setState(() => selectedPoint = point);
//             widget.onLocationSelected(point); // نرسل الإحداثيات
//           },
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: const ['a', 'b', 'c'],
//           ),
//           if (selectedPoint != null)
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   point: selectedPoint!,
//                   width: 50,
//                   height: 50,
//                   child: const Icon(
//                     Icons.location_on,
//                     color: Colors.red,
//                     size: 40,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }

//
//
// ظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظظ
// map_picker_widget.dart  (نسخة مُعدلة وجاهزة)
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerWidget extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const MapPickerWidget({super.key, required this.onLocationSelected});

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  LatLng? selectedPoint;

  // ضع هنا مفتاح MapTiler الخاص بك
  final String mapTilerApiKey = "DkCr2lkmHILNyMYo7yMN";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(33.5104, 36.2783), // دمشق كمثال
          zoom: 13,
          minZoom: 1,
          maxZoom: 22, // أقصى زوم متاح
          interactiveFlags: InteractiveFlag.all, // يسمح بكل التفاعلات
          onTap: (tapPos, point) {
            setState(() => selectedPoint = point);
            widget.onLocationSelected(point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$mapTilerApiKey",
            tileProvider: NetworkTileProvider(),
            userAgentPackageName: 'com.yourapp.package',
          ),
          if (selectedPoint != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: selectedPoint!,
                  width: 48,
                  height: 48,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 36,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
