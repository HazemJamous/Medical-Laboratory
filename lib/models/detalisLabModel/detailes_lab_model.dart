// To parse this JSON data, do
//
//     final detalisLabModel = detalisLabModelFromMap(jsonString);

import 'dart:convert';

DetalisLabModel detalisLabModelFromMap(String str) =>
    DetalisLabModel.fromMap(json.decode(str));

String detalisLabModelToMap(DetalisLabModel data) => json.encode(data.toMap());

class DetalisLabModel {
  final int id;
  final String labName;
  final String imagePath;
  final String contactInfo;
  final int subscriptionsStatus;
  final bool isfavorite;
  final double rate;
  final Location location;

  DetalisLabModel({
    required this.id,
    required this.labName,
    required this.imagePath,
    required this.contactInfo,
    required this.subscriptionsStatus,
    required this.isfavorite,
    required this.rate,
    required this.location,
  });

  DetalisLabModel copyWith({
    int? id,
    String? labName,
    String? imagePath,
    String? contactInfo,
    int? subscriptionsStatus,
    bool? isfavorite,
    double? rate,
    Location? location,
  }) => DetalisLabModel(
    id: id ?? this.id,
    labName: labName ?? this.labName,
    imagePath: imagePath ?? this.imagePath,
    contactInfo: contactInfo ?? this.contactInfo,
    subscriptionsStatus: subscriptionsStatus ?? this.subscriptionsStatus,
    isfavorite: isfavorite ?? this.isfavorite,
    rate: rate ?? this.rate,
    location: location ?? this.location,
  );

  factory DetalisLabModel.fromMap(Map<String, dynamic> json) => DetalisLabModel(
    id: json["id"],
    labName: json["lab_name"],
    imagePath: json["image_path"],
    contactInfo: json["contact_info"],
    subscriptionsStatus: json["subscriptions_status"],
    isfavorite: json["isfavorite"],
    rate: json["rate"]?.toDouble(),
    location: Location.fromMap(json["location"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "lab_name": labName,
    "image_path": imagePath,
    "contact_info": contactInfo,
    "subscriptions_status": subscriptionsStatus,
    "isfavorite": isfavorite,
    "rate": rate,
    "location": location.toMap(),
  };
}

class Location {
  final int id;
  final String address;
  final City city;

  Location({required this.id, required this.address, required this.city});

  Location copyWith({int? id, String? address, City? city}) => Location(
    id: id ?? this.id,
    address: address ?? this.address,
    city: city ?? this.city,
  );

  factory Location.fromMap(Map<String, dynamic> json) => Location(
    id: json["id"],
    address: json["address"],
    city: City.fromMap(json["city"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "address": address,
    "city": city.toMap(),
  };
}

class City {
  final int id;
  final String cityName;

  City({required this.id, required this.cityName});

  City copyWith({int? id, String? cityName}) =>
      City(id: id ?? this.id, cityName: cityName ?? this.cityName);

  factory City.fromMap(Map<String, dynamic> json) =>
      City(id: json["id"], cityName: json["city_name"]);

  Map<String, dynamic> toMap() => {"id": id, "city_name": cityName};
}
