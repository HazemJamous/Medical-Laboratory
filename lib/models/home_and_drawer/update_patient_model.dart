import 'dart:convert';

UpdatePatientModel updatePatientModelFromMap(String str) => UpdatePatientModel.fromMap(json.decode(str));

String updatePatientModelToMap(UpdatePatientModel data) => json.encode(data.toMap());

class UpdatePatientModel {
    String firstName;
    String lastName;
    String phone;
    String gender;
    DateTime dob;
    String healthProblems;

    UpdatePatientModel({
        required this.firstName,
        required this.lastName,
        required this.phone,
        required this.gender,
        required this.dob,
        required this.healthProblems,
    });

    UpdatePatientModel copyWith({
        String? firstName,
        String? lastName,
        String? phone,
        String? gender,
        DateTime? dob,
        String? healthProblems,
    }) => 
        UpdatePatientModel(
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            phone: phone ?? this.phone,
            gender: gender ?? this.gender,
            dob: dob ?? this.dob,
            healthProblems: healthProblems ?? this.healthProblems,
        );

    factory UpdatePatientModel.fromMap(Map<String, dynamic> json) => UpdatePatientModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        gender: json["gender"],
        dob: DateTime.parse(json["dob"]),
        healthProblems: json["Health_Problems"],
    );

    Map<String, dynamic> toMap() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "gender": gender,
        "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "Health_Problems": healthProblems,
    };
}
