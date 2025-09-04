import 'dart:convert';

MyBokingsModel myBokingsModelFromMap(String str) =>
    MyBokingsModel.fromMap(json.decode(str));

String myBokingsModelToMap(MyBokingsModel data) => json.encode(data.toMap());

class MyBokingsModel {
  final int appointmentId;
  final String labName;
  final DateTime dateTime;
  final String patientName;
  final String patientIdNumber;
  final double? longitude;
  final double? latitude;
  final List<Test> tests;
  final String bookingType;

  MyBokingsModel({
    required this.appointmentId,
    required this.labName,
    required this.dateTime,
    required this.patientName,
    required this.patientIdNumber,
    required this.longitude,
    required this.latitude,
    required this.tests,
    required this.bookingType,
  });

  MyBokingsModel copyWith({
    int? appointmentId,
    String? labName,
    DateTime? dateTime,
    String? patientName,
    String? patientIdNumber,
    double? longitude,
    double? latitude,
    List<Test>? tests,
    String? bookingType,
  }) => MyBokingsModel(
    appointmentId: appointmentId ?? this.appointmentId,
    labName: labName ?? this.labName,
    dateTime: dateTime ?? this.dateTime,
    patientName: patientName ?? this.patientName,
    patientIdNumber: patientIdNumber ?? this.patientIdNumber,
    longitude: longitude ?? this.longitude,
    latitude: latitude ?? this.latitude,
    tests: tests ?? this.tests,
    bookingType: bookingType ?? this.bookingType,
  );

  factory MyBokingsModel.fromMap(Map<String, dynamic> json) => MyBokingsModel(
    appointmentId: json["appointment_id"],
    labName: json["lab_name"],
    dateTime: DateTime.parse(json["date_time"]),
    patientName: json["patient_name"],
    patientIdNumber: json["patient_id_number"],
    longitude: json["longitude"]?.toDouble(),
    latitude: json["latitude"]?.toDouble(),
    tests: List<Test>.from(json["tests"].map((x) => Test.fromMap(x))),
    bookingType: json["booking_type"],
  );

  Map<String, dynamic> toMap() => {
    "appointment_id": appointmentId,
    "lab_name": labName,
    "date_time": dateTime.toIso8601String(),
    "patient_name": patientName,
    "patient_id_number": patientIdNumber,
    "longitude": longitude,
    "latitude": latitude,
    "tests": List<dynamic>.from(tests.map((x) => x.toMap())),
    "booking_type": bookingType,
  };
}

class Test {
  final int id;
  final String name;

  Test({required this.id, required this.name});

  Test copyWith({int? id, String? name}) =>
      Test(id: id ?? this.id, name: name ?? this.name);

  factory Test.fromMap(Map<String, dynamic> json) =>
      Test(id: json["id"], name: json["name"]);

  Map<String, dynamic> toMap() => {"id": id, "name": name};
}
