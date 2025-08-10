// To parse this JSON data, do
//
//     final labInformationModel = labInformationModelFromMap(jsonString);

import 'dart:convert';

LabInformationModel labInformationModelFromMap(String str) => LabInformationModel.fromMap(json.decode(str));

String labInformationModelToMap(LabInformationModel data) => json.encode(data.toMap());

class LabInformationModel {
    int id;
    String labName;
    String  imagePath;
    int subscriptionsStatus;
    bool isfavorite;
    Location location;

    LabInformationModel({
        required this.id,
        required this.labName,
        required this.imagePath,
        required this.subscriptionsStatus,
        required this.isfavorite,
        required this.location,
    });

    LabInformationModel copyWith({
        int? id,
        String? labName,
        String? imagePath,
        int? subscriptionsStatus,
        bool? isfavorite,
        Location? location,
    }) => 
        LabInformationModel(
            id: id ?? this.id,
            labName: labName ?? this.labName,
            imagePath: imagePath ?? this.imagePath,
            subscriptionsStatus: subscriptionsStatus ?? this.subscriptionsStatus,
            isfavorite: isfavorite ?? this.isfavorite,
            location: location ?? this.location,
        );

    factory LabInformationModel.fromMap(Map<String, dynamic> json) => LabInformationModel(
        id: json["id"],
        labName: json["lab_name"],
        imagePath: json["image_path"],
        subscriptionsStatus: json["subscriptions_status"],
        isfavorite: json["isfavorite"],
        location: Location.fromMap(json["location"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "lab_name": labName,
        "image_path": imagePath,
        "subscriptions_status": subscriptionsStatus,
        "isfavorite": isfavorite,
        "location": location.toMap(),
    };
}

class Location {
    int id;
    String address;
    City city;

    Location({
        required this.id,
        required this.address,
        required this.city,
    });

    Location copyWith({
        int? id,
        String? address,
        City? city,
    }) => 
        Location(
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
    int id;
    String cityName;

    City({
        required this.id,
        required this.cityName,
    });

    City copyWith({
        int? id,
        String? cityName,
    }) => 
        City(
            id: id ?? this.id,
            cityName: cityName ?? this.cityName,
        );

    factory City.fromMap(Map<String, dynamic> json) => City(
        id: json["id"],
        cityName: json["city_name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "city_name": cityName,
    };
}
