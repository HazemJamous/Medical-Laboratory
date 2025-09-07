// lib/models/home_and_drawer/update_email_model.dart
import 'dart:convert';

UpdateEmailModel updateEmailModelFromMap(String str) => UpdateEmailModel.fromMap(json.decode(str));

String updateEmailModelToMap(UpdateEmailModel data) => json.encode(data.toMap());

class UpdateEmailModel {
  String email;

  UpdateEmailModel({
    required this.email,
  });

  UpdateEmailModel copyWith({
    String? email,
  }) =>
      UpdateEmailModel(
        email: email ?? this.email,
      );

  factory UpdateEmailModel.fromMap(Map<String, dynamic> json) => UpdateEmailModel(
        email: json["email"],
      );

  Map<String, dynamic> toMap() => {
        "email": email,
      };
}
