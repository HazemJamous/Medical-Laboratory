
import 'dart:convert';

MyBokingsModel myBokingsModelFromMap(String str) => MyBokingsModel.fromMap(json.decode(str));

String myBokingsModelToMap(MyBokingsModel data) => json.encode(data.toMap());

class MyBokingsModel {
    final int appointmentId;
    final String labName;
    final DateTime dateTime;

    MyBokingsModel({
        required this.appointmentId,
        required this.labName,
        required this.dateTime,
    });

    MyBokingsModel copyWith({
        int? appointmentId,
        String? labName,
        DateTime? dateTime,
    }) => 
        MyBokingsModel(
            appointmentId: appointmentId ?? this.appointmentId,
            labName: labName ?? this.labName,
            dateTime: dateTime ?? this.dateTime,
        );

    factory MyBokingsModel.fromMap(Map<String, dynamic> json) => MyBokingsModel(
        appointmentId: json["appointment_id"],
        labName: json["lab_name"],
        dateTime: DateTime.parse(json["date_time"]),
    );

    Map<String, dynamic> toMap() => {
        "appointment_id": appointmentId,
        "lab_name": labName,
        "date_time": dateTime.toIso8601String(),
    };
}
