// To parse this JSON data, do
//
//     final updatePasswordModel = updatePasswordModelFromMap(jsonString);

import 'dart:convert';

UpdatePasswordModel updatePasswordModelFromMap(String str) =>
    UpdatePasswordModel.fromMap(json.decode(str));

String updatePasswordModelToMap(UpdatePasswordModel data) =>
    json.encode(data.toMap());

class UpdatePasswordModel {
  String oldPassword;
  String newPassword;
  String newPasswordConfirmation;

  UpdatePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  UpdatePasswordModel copyWith({
    String? oldPassword,
    String? newPassword,
    String? newPasswordConfirmation,
  }) => UpdatePasswordModel(
    oldPassword: oldPassword ?? this.oldPassword,
    newPassword: newPassword ?? this.newPassword,
    newPasswordConfirmation:
        newPasswordConfirmation ?? this.newPasswordConfirmation,
  );

  factory UpdatePasswordModel.fromMap(Map<String, dynamic> json) =>
      UpdatePasswordModel(
        oldPassword: json["old_password"],
        newPassword: json["new_password"],
        newPasswordConfirmation: json["new_password_confirmation"],
      );

  Map<String, dynamic> toMap() => {
    "old_password": oldPassword,
    "new_password": newPassword,
    "new_password_confirmation": newPasswordConfirmation,
  };
}
