// To parse this JSON data, do
//
//     final registerRequestModel = registerRequestModelFromMap(jsonString);



// RegisterRequestModel registerRequestModelFromMap(String str) =>
//     RegisterRequestModel.fromMap(json.decode(str));

// String registerRequestModelToMap(RegisterRequestModel data) =>
//     json.encode(data.toMap());

class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String gender;
  final String dob;
  final String healthProblems;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.healthProblems,
  });

  RegisterRequestModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? passwordConfirmation,
    String? phone,
    String? gender,
    String? dob,
    String? healthProblems,
  }) => RegisterRequestModel(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    password: password ?? this.password,
    passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    phone: phone ?? this.phone,
    gender: gender ?? this.gender,
    dob: dob ?? this.dob,
    healthProblems: healthProblems ?? this.healthProblems,
  );

  // factory RegisterRequestModel.fromMap(Map<String, dynamic> json) =>
  //     RegisterRequestModel(
  //       firstName: json["first_name"],
  //       lastName: json["last_name"],
  //       email: json["email"],
  //       password: json["password"],
  //       passwordConfirmation: json["password_confirmation"],
  //       phone: json["phone"],
  //       gender: json["gender"],
  //       dob: DateTime.parse(json["dob"]),
  //       healthProblems: json["Health_Problems"],
  //     );

  // Map<String, dynamic> toMap() => {
  //   "first_name": firstName,
  //   "last_name": lastName,
  //   "email": email,
  //   "password": password,
  //   "password_confirmation": passwordConfirmation,
  //   "phone": phone,
  //   "gender": gender,
  //   "dob":
  //       "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
  //   "Health_Problems": healthProblems,
  // };
}
