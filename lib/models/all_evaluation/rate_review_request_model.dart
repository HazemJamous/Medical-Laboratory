import 'dart:convert';

RateReviewRequestModel rateReviewRequestModelFromMap(String str) =>
    RateReviewRequestModel.fromMap(json.decode(str));

String rateReviewRequestModelToMap(RateReviewRequestModel data) =>
    json.encode(data.toMap());

class RateReviewRequestModel {
  final int labId;
  final num rate;
  final String review;

  RateReviewRequestModel({
    required this.labId,
    required this.rate,
    required this.review,
  });

  RateReviewRequestModel copyWith({int? labId, num? rate, String? review}) =>
      RateReviewRequestModel(
        labId: labId ?? this.labId,
        rate: rate ?? this.rate,
        review: review ?? this.review,
      );

  factory RateReviewRequestModel.fromMap(Map<String, dynamic> json) =>
      RateReviewRequestModel(
        labId: json["lab_id"],
        rate: json["rate"],
        review: json["review"],
      );

  Map<String, dynamic> toMap() => {
    "lab_id": labId,
    "rate": rate,
    "review": review,
  };
}
