import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/home_and_drawer/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
  static Future<List<ProfileModel>?> getMyprofile() async {
    // لسا ما عملتله كيوبيت عمله انت
    // انا باااااااااااسلللللللللل
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;
      Response response = await dio.get(
        ApiLink.myBookings,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<ProfileModel> list = [];

        for (var i = 0; i < (response.data['data'] as List).length; i++) {
          ProfileModel card = ProfileModel.fromMap(response.data['data'][i]);
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
