import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';

import 'package:midical_laboratory/models/login_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInService {
  static Future<String> login(LogInRequestModel user) async {
    Dio dio = Dio()..interceptors.add(LogPrintInterceptor());
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var data = {
        "email": user.email,
        "password": user.password,
        "fcm_token": sharedPreferences.getString("fcmToken"),
      };
      print(data);
      Response response = await dio.post(ApiLink.login, data: data);
      if (response.statusCode == 200) {
        print(response.data["message"]);

        sharedPreferences.setString("token", response.data["data"]["token"]);

        return response.data["data"]["token"];
      } else {
        print(response.statusCode);
        print("in register function");
        return "no token";
      }
    } catch (e) {
      print(e.toString());
      return "no token";
    }
  }
}
