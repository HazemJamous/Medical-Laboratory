import 'dart:convert';

AnalayseModel analayseModelFromMap(String str) =>
    AnalayseModel.fromMap(json.decode(str));

String analayseModelToMap(AnalayseModel data) => json.encode(data.toMap());

class AnalayseModel {
  final int id;
  final String labAnalysesName;
  final String preconditions;
  final num price;

  AnalayseModel({
    required this.id,
    required this.labAnalysesName,
    required this.preconditions,
    required this.price,
  });

  AnalayseModel copyWith({
    int? id,
    String? labAnalysesName,
    String? preconditions,
    num? price,
  }) => AnalayseModel(
    id: id ?? this.id,
    labAnalysesName: labAnalysesName ?? this.labAnalysesName,
    preconditions: preconditions ?? this.preconditions,
    price: price ?? this.price,
  );

  factory AnalayseModel.fromMap(Map<String, dynamic> json) => AnalayseModel(
    id: json["id"],
    labAnalysesName: json["lab_analyses_name"],
    preconditions: json["preconditions"],
    price: json["price"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "lab_analyses_name": labAnalysesName,
    "preconditions": preconditions,
    "price": price,
  };
}
