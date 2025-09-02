// services/book_appointment/book_appointment_service.dart
import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/booking_appointments/request_booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookAppointmentService {
  static Future<bool> bookAppointment(
    BookingAppointmentRequestModel request,
  ) async {
    final dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json', // ✅ مهم للـ Laravel/Sanctum
        'Content-Type': 'application/json',
      };

      final data = request.toMap();

      Response response = await dio.post(
        ApiLink.bookAppointment,
        data: data,
        options: Options(
          headers: headers,
          followRedirects: false, // ✅ لا تتبع 302
          validateStatus: (_) => true, // نفحص يدوياً
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is Map && response.data["status"] == 1) {
          return true;
        } else {
          return false;
        }
      } else {
        // print("BookAppointment HTTP $sc | ${response.data}");
        return false;
      }
    } catch (e) {
      // print("Appointment Error: $e");
      return false;
    }
  }
}
