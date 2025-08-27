import 'dart:convert';
import 'package:intl/intl.dart';

BookingAppointmentRequestModel bookingAppointmentRequestModelFromMap(String str) =>
    BookingAppointmentRequestModel.fromMap(json.decode(str));

String bookingAppointmentRequestModelToMap(BookingAppointmentRequestModel data) =>
    json.encode(data.toMap());

class BookingAppointmentRequestModel {
  final String type;
  final String patientName;
  final String patientPhone;
  final String patientIdNumber;
  final int labId;
  final DateTime dateTime;
  final List<int> analyses;

  BookingAppointmentRequestModel({
    required this.type,
    required this.patientName,
    required this.patientPhone,
    required this.patientIdNumber,
    required this.labId,
    required this.dateTime,
    required this.analyses,
  });

  Map<String, dynamic> toMap() => {
        "type": type,
        "patient_name": patientName,
        "patient_phone": patientPhone,
        "patient_id_number": patientIdNumber,
        "lab_id": labId,
        "date_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime),
        "analyses": List<dynamic>.from(analyses.map((x) => x)),
      };

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
}
