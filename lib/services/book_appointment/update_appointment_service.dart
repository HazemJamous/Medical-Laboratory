import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/booking_appointments/request_booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateAppointmentService {

  static Future<bool> UpdateAppointment(
    BookingAppointmentRequestModel request,
    int appointmentId
  ) async {
    final dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final data = request.toMap();
      

      final response = await dio.put(
        ApiLink.fileUrlForUpdateAppointment(appointmentId),
        data: data,
        options: Options(
          headers: headers,
          followRedirects: false,
          validateStatus: (_) => true,
        ),
      );

      final sc = response.statusCode ?? 0;

      if (sc == 200) {
        final respData = response.data;
        if (respData is Map && respData["status"] == 1) {
          return true;
        } else {
          
          return false;
        }
      } else if (sc == 302) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}