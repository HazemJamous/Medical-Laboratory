import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';
import 'package:midical_laboratory/models/my_bookings_model/results_bookings_appointment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBookingsService {
  static Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
  static Future<List<MyBokingsModel>?> getMyBookings() async {

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;
      Response response = await dio.get(
        ApiLink.myBookings,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<MyBokingsModel> list = [];

        for (var i = 0; i < (response.data['data'] as List).length; i++) {
          MyBokingsModel card = MyBokingsModel.fromMap(
            response.data['data'][i],
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
  
  static Future<MyBokingsModel?> getNearestBookings() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;
      Response response = await dio.get(
        ApiLink.myBookings,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<MyBokingsModel> list = [];

        for (var i = 0; i < (response.data['data'] as List).length; i++) {
          MyBokingsModel appointments = MyBokingsModel.fromMap(
            response.data['data'][i],
          );
          list.add(appointments);
        }
        if (list.isEmpty)
          return MyBokingsModel(
            appointmentId: -1,
            labName: "NoLabName",
            dateTime: DateTime(2000),
            patientName: "NoPatientName",
            patientIdNumber: "NoPatientIdNumber",
            longitude: null,
            latitude: null,
            tests: [],
            bookingType: "IN_LAB",
          );
        final nowUtc = DateTime.now().toUtc();
        MyBokingsModel? best;

        for (final b in list) {
          final dtUtc = b.dateTime.toUtc();
          if (dtUtc.isAfter(nowUtc)) {
            if (best == null || dtUtc.isBefore(best.dateTime.toUtc())) {
              best = b;
            }
          }
        }
        return best;
      } else {
        return MyBokingsModel(
          appointmentId: -2,
          labName: "NoLabName",
          dateTime: DateTime(2000),
          patientName: "NoPatientName",
          patientIdNumber: "NoPatientIdNumber",
          longitude: null,
          latitude: null,
          tests: [],
          bookingType: "IN_LAB",
        );
        ;
      }
    } catch (e) {
      print("$e");
      return MyBokingsModel(
        appointmentId: -2,
        labName: "NoLabName",
        dateTime: DateTime(2000),
        patientName: "NoPatientName",
        patientIdNumber: "NoPatientIdNumber",
        longitude: null,
        latitude: null,
        tests: [],
        bookingType: "IN_LAB",
      );
      ;
    }
  }

  /////////////////////////////////
  static Future<List<ResultsBookingsAppointmentModel>?> getResultsOfMyBookings(int id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;
      Response response = await dio.get(
        ApiLink.fileUrlForResultsOfBookingsAppointment(id),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<ResultsBookingsAppointmentModel> list = [];

        for (var i = 0; i < (response.data['data'] as List).length; i++) {
          ResultsBookingsAppointmentModel card = ResultsBookingsAppointmentModel.fromMap(
            response.data['data'][i],
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
