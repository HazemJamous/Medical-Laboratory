import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/register_request_model.dart';

class RegisterService {
  static Future<String> register(RegisterRequestModel user) async {
    Dio dio = Dio()
      // ..options.connectTimeout = const Duration(seconds: 10)
      // ..options.receiveTimeout = const Duration(seconds: 10)
      ..interceptors.add(LogPrintInterceptor());

    try {
      Response response = await dio.post(
        ApiLink.registerPatient,
        data: {
          "first_name": user.firstName,
          "last_name": user.lastName,
          "email": user.email,
          "password": user.password,
          "password_confirmation": user.passwordConfirmation, // صححت
          "phone": user.phone,
          "gender": user.gender,
          "dob": user.dob,
          "Health_Problems": user.healthProblems,
        },
      );
      if (response.statusCode == 200) {
        return response.data["data"]["token"];
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print("RegisterService error: $e");
      throw e;
    }
  }
}
