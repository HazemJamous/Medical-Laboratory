import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/core/constant/app_const.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/filter_options.dart';
import 'package:midical_laboratory/models/lap_information_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LabSearchService {
  static Future<List<LabInformationModel>> getAllLab() async {
    Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
    print("object");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token")!;
    print("object");
    try {
      Response response = await dio.get(
        ApiLink.labSearchPatient,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<LabInformationModel> labInfo = [];
        for (var i = 0; i < response.data["data"]["labs"].length; i++) {
          LabInformationModel newLab = LabInformationModel.fromMap(
            response.data["data"]["labs"][i],
          );
          labInfo.add(newLab);
        }
        // lapID: response.data["data"]["labs"][i]["id"],
        // lapName: response.data["data"]["labs"][i]["lab_name"],
        // image: response.data["data"]["labs"][i]["image_path"],
        // isSubscrip:
        //     response.data["data"]["labs"][i]["subscriptions_status"],
        // isFavorite: response.data["data"]["labs"][i]["isfavorite"],
        // address: response.data["data"]["labs"][i]["location"]["address"],
        // cityName: response
        //     .data["data"]["labs"][i]["subscriptions_status"]["city"]["city_name"],
        print(" lab info : ${labInfo}");
        print("Success get all labs");
        return labInfo;
      } else {
        print("${response.statusCode} falier get all labs");
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<LabInformationModel>> getLabWithFilter(
    String query,
    FilterOptions filterOptions,
  ) async {
    Dio dio = Dio();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token")!;

    try {
      Response response = await dio.get(
        "${ApiLink.baseUrl}/labSearchPatientt?isfavorite=${filterOptions.isFavorite}&subscriptions_status=${filterOptions.isSubscrip}&lab_name=${query}",
        // queryParameters: {
        //   "isfavorite":,
        // },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<LabInformationModel> labInfo = [];
        for (var i = 0; i < response.data["data"]["labs"].length; i++) {
          LabInformationModel newLab = LabInformationModel.fromMap(
            response.data["data"]["labs"][i],
          );
          labInfo.add(newLab);
        }

        // lapID: response.data["data"]["labs"][i]["id"],
        // lapName: response.data["data"]["labs"][i]["lab_name"],
        // image: response.data["data"]["labs"][i]["image_path"],
        // isSubscrip:
        //     response.data["data"]["labs"][i]["subscriptions_status"],
        // isFavorite: response.data["data"]["labs"][i]["isfavorite"],
        // address: response.data["data"]["labs"][i]["location"]["address"],
        // cityName: response
        //     .data["data"]["labs"][i]["subscriptions_status"]["city"]["city_name"],
        print("Success get all labs");
        return labInfo;
      } else {
        print("${response.statusCode} falier get all labs");
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<bool> putDeleteFavoriteLab(int id) async {
    Dio dio = Dio();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token")!;
    try {
      Response response = await dio.post(
        "patientPutDeleteFavoriteLab/$id",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        print("Put And Delete Favorite success");
        return true;
      } else {
        print("Put And Delete Favorite failed in else");
        return false;
      }
    } catch (e) {
      print("Put And Delete Favorite failed in catch");
      print(e.toString());
      return false;
    }
  }
}
