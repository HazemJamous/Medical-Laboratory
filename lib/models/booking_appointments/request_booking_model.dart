import 'dart:convert';
import 'package:intl/intl.dart';

BookingAppointmentRequestModel bookingAppointmentRequestModelFromMap(
  String str,
) => BookingAppointmentRequestModel.fromMap(json.decode(str));

String bookingAppointmentRequestModelToMap(
  BookingAppointmentRequestModel data,
) => json.encode(data.toMap());

class BookingAppointmentRequestModel {
  final String type; // IN_LAB / IN_HOME
  final String patientName;
  final String patientPhone;
  final String patientIdNumber;
  final int labId;
  final DateTime dateTime;
  final List<int> analyses;
  double? latitude;
  double? longitude;

  BookingAppointmentRequestModel({
    required this.type,
    required this.patientName,
    required this.patientPhone,
    required this.patientIdNumber,
    required this.labId,
    required this.dateTime,
    required this.analyses,
    this.latitude,
    this.longitude,
  });

  BookingAppointmentRequestModel copyWith({
    String? type,
    String? patientName,
    String? patientPhone,
    String? patientIdNumber,
    int? labId,
    DateTime? dateTime,
    List<int>? analyses,
  }) => BookingAppointmentRequestModel(
    type: type ?? this.type,
    patientName: patientName ?? this.patientName,
    patientPhone: patientPhone ?? this.patientPhone,
    patientIdNumber: patientIdNumber ?? this.patientIdNumber,
    labId: labId ?? this.labId,
    dateTime: dateTime ?? this.dateTime,
    analyses: analyses ?? this.analyses,
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
      );

  Map<String, dynamic> toMap() {
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss'); // ✅ صيغة الباك
    return {
      "type": type,
      "patient_name": patientName,
      "patient_phone": patientPhone,
      "patient_id_number": patientIdNumber,
      "lab_id": labId,
      "date_time": fmt.format(dateTime),
      "analyses": List<dynamic>.from(analyses.map((x) => x)),
    };
  }
}
