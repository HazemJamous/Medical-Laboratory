import 'dart:convert';
import 'package:intl/intl.dart';

BookingAppointmentRequestModel bookingAppointmentRequestModelFromMap(
  String str,
) => BookingAppointmentRequestModel.fromMap(json.decode(str));

String bookingAppointmentRequestModelToMap(
  BookingAppointmentRequestModel data,
) => json.encode(data.toMap());

class BookingAppointmentRequestModel {
  final String type;
  final String patientName;
  final String patientPhone;
  final String patientIdNumber;
  final int labId;
  final DateTime dateTime;
  final List<int> analyses;
  final double longitude;
  final double latitude;

  BookingAppointmentRequestModel({
    required this.type,
    required this.patientName,
    required this.patientPhone,
    required this.patientIdNumber,
    required this.labId,
    required this.dateTime,
    required this.analyses,
    required this.longitude,
    required this.latitude,
  });

  BookingAppointmentRequestModel copyWith({
    String? type,
    String? patientName,
    String? patientPhone,
    String? patientIdNumber,
    int? labId,
    DateTime? dateTime,
    List<int>? analyses,
    double? longitude,
    double? latitude,
  }) => BookingAppointmentRequestModel(
    type: type ?? this.type,
    patientName: patientName ?? this.patientName,
    patientPhone: patientPhone ?? this.patientPhone,
    patientIdNumber: patientIdNumber ?? this.patientIdNumber,
    labId: labId ?? this.labId,
    dateTime: dateTime ?? this.dateTime,
    analyses: analyses ?? this.analyses,
    longitude: longitude ?? this.longitude,
    latitude: latitude ?? this.latitude,
  );

  factory BookingAppointmentRequestModel.fromMap(Map<String, dynamic> json) =>
      BookingAppointmentRequestModel(
        type: json["type"],
        patientName: json["patient_name"],
        patientPhone: json["patient_phone"],
        patientIdNumber: json["patient_id_number"],
        labId: json["lab_id"],
        dateTime: DateTime.parse(json["date_time"]),
        analyses: List<int>.from(json["analyses"].map((x) => x)),
        longitude: json["longitude"]?.toDouble() ?? 0.0,
        latitude: json["latitude"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toMap() => {
    "type": type,
    "patient_name": patientName,
    "patient_phone": patientPhone,
    "patient_id_number": patientIdNumber,
    "lab_id": labId,
    // إرسال التاريخ بالشكل الصحيح لتجنب خطأ 422
    "date_time": DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
    "analyses": List<dynamic>.from(analyses.map((x) => x)),
    "longitude": longitude,
    "latitude": latitude,
  };
}
