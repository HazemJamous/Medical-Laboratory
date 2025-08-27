import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/booking_appointments/request_booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookAppointmentService {
  static Future<bool> bookAppointment(BookingAppointmentRequestModel request) async {
    Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";
      if (token.isEmpty) throw Exception("Token not found");

      print("Booking Appointment: ${request.toMap()}");

      final response = await dio.post(
        ApiLink.bookAppointment,
        data: request.toMap(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print("BookAppointment Response: ${response.statusCode} | ${response.data}");

      if (response.statusCode == 200 && response.data["status"] == 1) {
        return true;
      } else if (response.statusCode == 302) {
        print("Redirect detected, possibly invalid token.");
        return false;
      } else {
        print("Booking Failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Booking Error: $e");
      return false;
    }
  }
}
