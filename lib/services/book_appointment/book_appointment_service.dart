import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/models/booking_appointments/get_available_appointments_model.dart';

class BookAppointmentService {
  static Future<List<AvailableAppointmentsModel>> getAvailableAppointments(
    int labId,
  ) async {
    Dio dio = Dio();
    try {
      Response response = await dio.get(
        ApiLink.fileUrlForAvailableAppointments(labId),
      );
      if (response.statusCode == 200) {
        List<AvailableAppointmentsModel> labAvailableTime = [];
        for (var i = 0; i < response.data["data"].length; i++) {
          AvailableAppointmentsModel newAvailableTime =
              AvailableAppointmentsModel.fromMap(response.data["data"][i]);
          labAvailableTime.add(newAvailableTime);
        }
        return labAvailableTime;
      } else {
        print("in Else = Error");
        return [];
      }
    } catch (e) {
      print("in Catch = Error");
      return [];
    }
  }
}
