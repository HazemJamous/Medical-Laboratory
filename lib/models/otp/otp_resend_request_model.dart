
import 'dart:convert';

OtpResendRequestModel resendOtpModelFromMap(String str) => OtpResendRequestModel.fromMap(json.decode(str));

String resendOtpModelToMap(OtpResendRequestModel data) => json.encode(data.toMap());

class OtpResendRequestModel {
    final String email;

    OtpResendRequestModel({
        required this.email,
    });

    OtpResendRequestModel copyWith({
        String? email,
    }) => 
        OtpResendRequestModel(
            email: email ?? this.email,
        );

    factory OtpResendRequestModel.fromMap(Map<String, dynamic> json) => OtpResendRequestModel(
        email: json["email"],
    );

    Map<String, dynamic> toMap() => {
        "email": email,
    };
}

