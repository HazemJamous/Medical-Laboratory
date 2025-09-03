
import 'dart:convert';

OtpRequestModel otpRequestModelFromMap(String str) => OtpRequestModel.fromMap(json.decode(str));

String otpRequestModelToMap(OtpRequestModel data) => json.encode(data.toMap());

class OtpRequestModel {
    final String email;
    final String code;

    OtpRequestModel({
        required this.email,
        required this.code,
    });

    OtpRequestModel copyWith({
        String? email,
        String? code,
    }) => 
        OtpRequestModel(
            email: email ?? this.email,
            code: code ?? this.code,
        );

    factory OtpRequestModel.fromMap(Map<String, dynamic> json) => OtpRequestModel(
        email: json["email"],
        code: json["code"],
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "code": code,
    };
}
