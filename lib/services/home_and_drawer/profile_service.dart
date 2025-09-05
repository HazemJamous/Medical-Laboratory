import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/home_and_drawer/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
  static Future<ProfileModel?> getMyprofile() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;
      Response response = await dio.get(
        ApiLink.myProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        ProfileModel profileModel = ProfileModel.fromMap(
          response.data['data']['patient'],
        );
        return profileModel;
      } else {
        print("in else statement");
        return null;
      }
    } catch (e) {
      print("in catch: $e");
      return null;
    }
  }
}
