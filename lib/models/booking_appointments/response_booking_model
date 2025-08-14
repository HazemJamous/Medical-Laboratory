
import 'package:meta/meta.dart';
import 'dart:convert';

ResponseBookingAppointmentModel responseBookingAppointmentModelFromMap(String str) => ResponseBookingAppointmentModel.fromMap(json.decode(str));

String responseBookingAppointmentModelToMap(ResponseBookingAppointmentModel data) => json.encode(data.toMap());

class ResponseBookingAppointmentModel {
    final int status;
    final Data data;
    final String message;

    ResponseBookingAppointmentModel({
        required this.status,
        required this.data,
        required this.message,
    });

    ResponseBookingAppointmentModel copyWith({
        int? status,
        Data? data,
        String? message,
    }) => 
        ResponseBookingAppointmentModel(
            status: status ?? this.status,
            data: data ?? this.data,
            message: message ?? this.message,
        );

    factory ResponseBookingAppointmentModel.fromMap(Map<String, dynamic> json) => ResponseBookingAppointmentModel(
        status: json["status"],
        data: Data.fromMap(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data.toMap(),
        "message": message,
    };
}

class Data {
    final String type;
    final String patientName;
    final String patientPhone;
    final String patientIdNumber;
    final int patientId;
    final int labId;
    final dynamic locationId;
    final String status;
    final DateTime dateTime;
    final DateTime updatedAt;
    final DateTime createdAt;
    final int id;

    Data({
        required this.type,
        required this.patientName,
        required this.patientPhone,
        required this.patientIdNumber,
        required this.patientId,
        required this.labId,
        required this.locationId,
        required this.status,
        required this.dateTime,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    Data copyWith({
        String? type,
        String? patientName,
        String? patientPhone,
        String? patientIdNumber,
        int? patientId,
        int? labId,
        dynamic locationId,
        String? status,
        DateTime? dateTime,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        Data(
            type: type ?? this.type,
            patientName: patientName ?? this.patientName,
            patientPhone: patientPhone ?? this.patientPhone,
            patientIdNumber: patientIdNumber ?? this.patientIdNumber,
            patientId: patientId ?? this.patientId,
            labId: labId ?? this.labId,
            locationId: locationId ?? this.locationId,
            status: status ?? this.status,
            dateTime: dateTime ?? this.dateTime,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        type: json["type"],
        patientName: json["patient_name"],
        patientPhone: json["patient_phone"],
        patientIdNumber: json["patient_id_number"],
        patientId: json["patient_id"],
        labId: json["lab_id"],
        locationId: json["location_id"],
        status: json["status"],
        dateTime: DateTime.parse(json["date_time"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "type": type,
        "patient_name": patientName,
        "patient_phone": patientPhone,
        "patient_id_number": patientIdNumber,
        "patient_id": patientId,
        "lab_id": labId,
        "location_id": locationId,
        "status": status,
        "date_time": dateTime.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
