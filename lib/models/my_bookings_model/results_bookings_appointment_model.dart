
import 'dart:convert';

ResultsBookingsAppointmentModel resultsBookingsAppointmentModelFromMap(String str) => ResultsBookingsAppointmentModel.fromMap(json.decode(str));

String resultsBookingsAppointmentModelToMap(ResultsBookingsAppointmentModel data) => json.encode(data.toMap());

class ResultsBookingsAppointmentModel {
    final int analysisId;
    final String analysisName;
    final String result;

    ResultsBookingsAppointmentModel({
        required this.analysisId,
        required this.analysisName,
        required this.result,
    });

    ResultsBookingsAppointmentModel copyWith({
        int? analysisId,
        String? analysisName,
        String? result,
    }) => 
        ResultsBookingsAppointmentModel(
            analysisId: analysisId ?? this.analysisId,
            analysisName: analysisName ?? this.analysisName,
            result: result ?? this.result,
        );

    factory ResultsBookingsAppointmentModel.fromMap(Map<String, dynamic> json) => ResultsBookingsAppointmentModel(
        analysisId: json["analysis_id"],
        analysisName: json["analysis_name"],
        result: json["result"],
    );

    Map<String, dynamic> toMap() => {
        "analysis_id": analysisId,
        "analysis_name": analysisName,
        "result": result,
    };
}
