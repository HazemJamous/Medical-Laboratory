

import 'dart:convert';

ProfileModel profileModelFromMap(String str) => ProfileModel.fromMap(json.decode(str));

String profileModelToMap(ProfileModel data) => json.encode(data.toMap());

class ProfileModel {
    final int userId;
    final String firstName;
    final String lastName;
    final String email;
    final dynamic fcmToken;
    final int patientId;
    final String phone;
    final String gender;
    final DateTime dob;
    final String healthProblems;

    ProfileModel({
        required this.userId,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.fcmToken,
        required this.patientId,
        required this.phone,
        required this.gender,
        required this.dob,
        required this.healthProblems,
    });

    ProfileModel copyWith({
        int? userId,
        String? firstName,
        String? lastName,
        String? email,
        dynamic fcmToken,
        int? patientId,
        String? phone,
        String? gender,
        DateTime? dob,
        String? healthProblems,
    }) => 
        ProfileModel(
            userId: userId ?? this.userId,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            email: email ?? this.email,
            fcmToken: fcmToken ?? this.fcmToken,
            patientId: patientId ?? this.patientId,
            phone: phone ?? this.phone,
            gender: gender ?? this.gender,
            dob: dob ?? this.dob,
            healthProblems: healthProblems ?? this.healthProblems,
        );

    factory ProfileModel.fromMap(Map<String, dynamic> json) => ProfileModel(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        fcmToken: json["fcm_token"],
        patientId: json["patient_id"],
        phone: json["phone"],
        gender: json["gender"],
        dob: DateTime.parse(json["dob"]),
        healthProblems: json["Health_Problems"],
    );

    Map<String, dynamic> toMap() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "fcm_token": fcmToken,
        "patient_id": patientId,
        "phone": phone,
        "gender": gender,
        "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "Health_Problems": healthProblems,
    };
}
