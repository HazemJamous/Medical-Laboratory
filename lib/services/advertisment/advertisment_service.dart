import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/constant/app_const.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/advertisment_model/advertisment_modle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvertismentService {
  Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
  Future<List<AdvertismentModel>?> getAdvertisment() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;
      Response response = await dio.get(
        "${url}advertisementSearch",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<AdvertismentModel> list = [];

        print(response.data['data']['Advertisements']);

        for (
          var i = 0;
          i < (response.data['data']['Advertisements'] as List).length;
          i++
        ) {
          AdvertismentModel card = AdvertismentModel.fromMap(
            response.data['data']['Advertisements'][i],
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
