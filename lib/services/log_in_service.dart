import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/core/constant/app_const.dart';
import 'package:midical_laboratory/models/login_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInService {
  static Future<String> login(LogInRequestModel user) async {
    Dio dio = Dio();
    try {
      Response response = await dio.post(
        ApiLink.login,
        data: {"email": user.email, "password": user.password},
      );
      if (response.statusCode == 200) {
        print(response.data["message"]);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
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
