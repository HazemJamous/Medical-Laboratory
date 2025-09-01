// lib/services/my_bookings/delete_appointment_service.dart
import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAppointmentService {
  static Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);

  static Future<bool> deleteAppointment(int appointmentId) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;

      Response response = await dio.delete(
        ApiLink.fileUrlForDeleteAppointment(appointmentId),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print("Failed to delete appointment: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error deleting appointment: $e");
      return false;
    }
  }
}
