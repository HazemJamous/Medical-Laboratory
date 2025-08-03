import 'package:meta/meta.dart';
import 'dart:convert';

AdvertismentModel advertismentModelFromMap(String str) =>
    AdvertismentModel.fromMap(json.decode(str));

String advertismentModelToMap(AdvertismentModel data) =>
    json.encode(data.toMap());

class AdvertismentModel {
  final int id;
  final String title;
  final String descriptions;
  final Lab lab;

  AdvertismentModel({
    required this.id,
    required this.title,
    required this.descriptions,
    required this.lab,
  });

  AdvertismentModel copyWith({
    int? id,
    String? title,
    String? descriptions,
    Lab? lab,
  }) => AdvertismentModel(
    id: id ?? this.id,
    title: title ?? this.title,
    descriptions: descriptions ?? this.descriptions,
    lab: lab ?? this.lab,
  );

  factory AdvertismentModel.fromMap(Map<String, dynamic> json) =>
      AdvertismentModel(
        id: json["id"],
        title: json["title"],
        descriptions: json["descriptions"],
        lab: Lab.fromMap(json["lab"]),
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "descriptions": descriptions,
    "lab": lab.toMap(),
  };
}

class Lab {
  final int id;
  final String labName;

  Lab({required this.id, required this.labName});

  Lab copyWith({int? id, String? labName}) =>
      Lab(id: id ?? this.id, labName: labName ?? this.labName);

  factory Lab.fromMap(Map<String, dynamic> json) =>
      Lab(id: json["id"], labName: json["lab_name"]);

  Map<String, dynamic> toMap() => {"id": id, "lab_name": labName};
}