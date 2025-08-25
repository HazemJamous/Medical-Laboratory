import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/all_evaluation/all_evaluations_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllEvaluationsService {
  static Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
  static Future<List<AllEvaluationsModel>?> getAllEvaluations(int labId) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString("token")!;
      Response response = await dio.get(      
        ApiLink.fileUrlForEvaluation(labId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        List<AllEvaluationsModel> list = [];

        for (
          var i = 0;
          i < (response.data['data']['evaluations'] as List).length;
          i++
        ) {
          AllEvaluationsModel card = AllEvaluationsModel.fromMap(
            response.data['data']['evaluations'][i],
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
