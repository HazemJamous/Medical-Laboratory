// To parse this JSON data, do

import 'dart:convert';

GetBalanceModel getBalanceModelFromMap(String str) => GetBalanceModel.fromMap(json.decode(str));

String getBalanceModelToMap(GetBalanceModel data) => json.encode(data.toMap());

class GetBalanceModel {
    final String currency;
    final int total;

    GetBalanceModel({
        required this.currency,
        required this.total,
    });

    GetBalanceModel copyWith({
        String? currency,
        int? total,
    }) => 
        GetBalanceModel(
            currency: currency ?? this.currency,
            total: total ?? this.total,
        );

    factory GetBalanceModel.fromMap(Map<String, dynamic> json) => GetBalanceModel(
        currency: json["currency"],
        total: json["total"],
    );

    Map<String, dynamic> toMap() => {
        "currency": currency,
        "total": total,
    };
}
