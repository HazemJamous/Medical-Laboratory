import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapPickerWidget extends StatefulWidget {
  final Function(LatLng) onLocationSelected; // يرجع الموقع للمستدعي

  const MapPickerWidget({super.key, required this.onLocationSelected});

  @override
  State<MapPickerWidget> createState() => _MapPickerWidgetState();
}

class _MapPickerWidgetState extends State<MapPickerWidget> {
  MapboxMapController? _controller;
  LatLng? selectedPoint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // ارتفاع الخريطة
      child: MapboxMap(
        accessToken:
            "PUT_YOUR_ACCESS_TOKEN_HERE", // ⚠️ ضع الـ Access Token الخاص بك من Mapbox
        initialCameraPosition: const CameraPosition(
          target: LatLng(33.5104, 36.2783), // ✅ دمشق كمثال
          zoom: 13,
        ),
        onMapCreated: (controller) {
          _controller = controller;
        },
        onMapClick: (point, coordinates) async {
          setState(() {
            selectedPoint = LatLng(coordinates.latitude, coordinates.longitude);
          });

          // إزالة الرموز القديمة قبل إضافة رمز جديد
          await _controller?.clearSymbols();

          await _controller?.addSymbol(
            SymbolOptions(
              geometry: coordinates,
              iconImage: "marker-15", // أيقونة افتراضية من Mapbox
              iconSize: 2.0,
            ),
          );

          widget.onLocationSelected(
            LatLng(coordinates.latitude, coordinates.longitude),
          );
        },
      ),
    );
  }
}
