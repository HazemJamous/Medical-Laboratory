import 'dart:convert';

AllEvaluationsModel allEvaluationsModelFromMap(String str) =>
    AllEvaluationsModel.fromMap(json.decode(str));

String allEvaluationsModelToMap(AllEvaluationsModel data) =>
    json.encode(data.toMap());

class AllEvaluationsModel {
  final int id;
  final String review;
  final double rate;
  final String patientName;

  AllEvaluationsModel({
    required this.id,
    required this.review,
    required this.rate,
    required this.patientName,
  });

  AllEvaluationsModel copyWith({
    int? id,
    String? review,
    double? rate,
    String? patientName,
  }) => AllEvaluationsModel(
    id: id ?? this.id,
    review: review ?? this.review,
    rate: rate ?? this.rate,
    patientName: patientName ?? this.patientName,
  );

  factory AllEvaluationsModel.fromMap(Map<String, dynamic> json) =>
      AllEvaluationsModel(
        id: json["id"],
        review: json["review"],
        rate: json["rate"]?.toDouble(),
        patientName: json["patient_name"],
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "review": review,
    "rate": rate,
    "patient_name": patientName,
  };
}
