// import 'dart:convert';

// LogInRequestModel logInRequestModelFromMap(String str) =>
//     LogInRequestModel.fromMap(json.decode(str));

// String logInRequestModelToMap(LogInRequestModel data) =>
//     json.encode(data.toMap());

class LogInRequestModel {
  final String email;
  final String password;

  LogInRequestModel({required this.email, required this.password});

  LogInRequestModel copyWith({String? email, String? password}) =>
      LogInRequestModel(
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory LogInRequestModel.fromMap(Map<String, dynamic> json) =>
      LogInRequestModel(email: json["email"], password: json["password"]);

  Map<String, dynamic> toMap() => {"email": email, "password": password};
}
