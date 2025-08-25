import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/all_evaluation/rate_review_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateReviewService {
  static Future<bool> submitReview(RateReviewRequestModel request) async {
    Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      print("Submitting review: ${request.toMap()}");

      Response response = await dio.post(
        ApiLink.rateAndReview,
        data: request.toMap(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("RateReviewService Response: ${response.data}");

      if (response.statusCode == 200 && response.data["status"] == 1) {
        return true;
      } else {
        print("RateReviewService Failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("RateReviewService Error: $e");
      return false;
    }
  }
}
