import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/booking_appointments/get_available_appointments_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetAvailableAppointmentsService {
  static Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
  static Future<List<AvailableAppointmentsModel>?> getAllAvailableAppointments(
    int labId,
  ) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;
      Response response = await dio.get(
        ApiLink.fileUrlForAvailableAppointments(labId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<AvailableAppointmentsModel> list = [];

        for (
          var i = 0;
          i < (response.data['data']['evaluations'] as List).length;
          i++
        ) {
          AvailableAppointmentsModel card = AvailableAppointmentsModel.fromMap(
            response.data['data']['evaluations'][i],
          );
          list.add(card);
        }

        return list;
      } else {
        return null;
      }
    } catch (e) {
      print("$e");
      return null;
    }
  }
}
