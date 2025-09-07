import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/home_and_drawer/update_email_model.dart';
import 'package:midical_laboratory/models/home_and_drawer/update_password_model.dart';
import 'package:midical_laboratory/models/home_and_drawer/update_patient_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateServices {
  static Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
  static Future<Map<String, dynamic>> updatePatient(
    UpdatePatientModel request,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";
      final data = request.toMap();
      Response response = await dio.put(
        ApiLink.updatePatient,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message']
            : "تم تعديل البيانات بنجاح";
        return {'success': true, 'message': msg};
      } else {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message']
            : "حدث خطأ أثناء تعديل البيانات";
        return {'success': false, 'message': msg};
      }
    } catch (e) {
      print("UpdateServices.updatePatient error: $e");
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<String> UpdatePassword(UpdatePasswordModel request) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";
      final data = request.toMap();
      Response response = await dio.put(
        ApiLink.updatePatientPassword,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return "تم تعديل كلمة السر بنجاح";
      } else {
        return response.data["message"];
      }
    } catch (e) {
      print("$e");
      return e.toString();
    }
  }

  static Future<String> UpdateEmail(UpdateEmailModel request) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";
      final data = request.toMap();
      Response response = await dio.put(
        ApiLink.updatePatientEmail,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return "تم تعديل حسابك الايميل بنجاح";
      } else {
        if (response.data != null && response.data is Map && response.data['message'] != null) {
          return response.data['message'];
        }
        return "حدث خطأ أثناء تعديل الإيميل";
      }
    } catch (e) {
      print("UpdateServices.UpdateEmail error: $e");
      return e.toString();
    }
  }
}
