import 'dart:convert';

AvailableAppointmentsModel availableAppointmentsModeelFromMap(String str) =>
    AvailableAppointmentsModel.fromMap(json.decode(str));

String availableAppointmentsModeelToMap(AvailableAppointmentsModel data) =>
    json.encode(data.toMap());

class AvailableAppointmentsModel {
  final DateTime dateTime;
  final List<String> typeOptions;

  AvailableAppointmentsModel({
    required this.dateTime,
    required this.typeOptions,
  });

  AvailableAppointmentsModel copyWith({
    DateTime? dateTime,
    List<String>? typeOptions,
  }) => AvailableAppointmentsModel(
    dateTime: dateTime ?? this.dateTime,
    typeOptions: typeOptions ?? this.typeOptions,
  );

  factory AvailableAppointmentsModel.fromMap(Map<String, dynamic> json) =>
      AvailableAppointmentsModel(
        dateTime: DateTime.parse(json["date_time"]),
        typeOptions: List<String>.from(json["type_options"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
    "date_time": dateTime.toIso8601String(),
    "type_options": List<dynamic>.from(typeOptions.map((x) => x)),
  };
}
