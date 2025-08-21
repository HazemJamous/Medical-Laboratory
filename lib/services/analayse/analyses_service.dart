import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/analayses_model/analayses_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class   AnalysesService {
   static Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
 static Future<List<AnalayseModel>?> getAllAnalyses(int labId) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;
      Response response = await dio.get(
        ApiLink.fileUrlForAllAnalyses(labId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<AnalayseModel> list = [];
        print(response.data['data']['analyses']);

        for (
          var i = 0;
          i < (response.data['data']['analyses'] as List).length;
          i++
        ) {
          AnalayseModel card = AnalayseModel.fromMap(
            response.data['data']['analyses'][i],
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