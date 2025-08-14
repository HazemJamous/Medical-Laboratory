
import 'dart:convert';

RequestBookingAppointmentModel requestBookingAppointmentModelFromMap(String str) => RequestBookingAppointmentModel.fromMap(json.decode(str));

String requestBookingAppointmentModelToMap(RequestBookingAppointmentModel data) => json.encode(data.toMap());

class RequestBookingAppointmentModel {
    final String type;
    final String patientName;
    final String patientPhone;
    final String patientIdNumber;
    final int patientId;
    final int labId;
    final DateTime dateTime;

    RequestBookingAppointmentModel({
        required this.type,
        required this.patientName,
        required this.patientPhone,
        required this.patientIdNumber,
        required this.patientId,
        required this.labId,
        required this.dateTime,
    });

    RequestBookingAppointmentModel copyWith({
        String? type,
        String? patientName,
        String? patientPhone,
        String? patientIdNumber,
        int? patientId,
        int? labId,
        DateTime? dateTime,
    }) => 
        RequestBookingAppointmentModel(
            type: type ?? this.type,
            patientName: patientName ?? this.patientName,
            patientPhone: patientPhone ?? this.patientPhone,
            patientIdNumber: patientIdNumber ?? this.patientIdNumber,
            patientId: patientId ?? this.patientId,
            labId: labId ?? this.labId,
            dateTime: dateTime ?? this.dateTime,
        );

    factory RequestBookingAppointmentModel.fromMap(Map<String, dynamic> json) => RequestBookingAppointmentModel(
        type: json["type"],
        patientName: json["patient_name"],
        patientPhone: json["patient_phone"],
        patientIdNumber: json["patient_id_number"],
        patientId: json["patient_id"],
        labId: json["lab_id"],
        dateTime: DateTime.parse(json["date_time"]),
    );

    Map<String, dynamic> toMap() => {
        "type": type,
        "patient_name": patientName,
        "patient_phone": patientPhone,
        "patient_id_number": patientIdNumber,
        "patient_id": patientId,
        "lab_id": labId,
        "date_time": dateTime.toIso8601String(),
    };
}
