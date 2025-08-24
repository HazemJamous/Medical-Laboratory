import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/core/constant/app_const.dart';
import 'package:midical_laboratory/models/register_request_model.dart';

class RegisterService {
  static Future<String> register(RegisterRequestModel user) async {
    Dio dio = Dio();
    try {
      Response response = await dio.post(
        ApiLink.registerPatient,
        data: {
          "first_name": user.firstName,
          "last_name": user.lastName,
          "email": user.email,
          "password": user.password,
          "password_confirmation": user.password,
          "phone": user.phone,
          "gender": user.gender,

          "dob": "2002-03-03",
          //  user.dob,
          "Health_Problems": "smoking",
        },
      );
      if (response.statusCode == 200) {
        print(response.data["message"]);
        return response.data["data"]["token"];
      } else {
        print(response.statusCode);
        print("in register function");
        return "no token";
      }
    } catch (e) {
      print(e.toString());
      print("in catch");
      return "no token";
    }
  }

  // Future<bool> register({required RegisterModel registerModel}) async {
  //   Dio dio = Dio();
  //   try {
  //     Response response = await dio.post(
  //       'https://dummyjson.com/auth/login',
  //       data: registerModel.toMap(),
  //     );
  //     if (response.statusCode == 200) {
  //       print(response.data['accessToken']);
  //       // token = response.data['accessToken'];
  //       // getIt.get<SharedPreferences>().setString('token', response.data['accessToken']);
  //       setString('token', response.data['accessToken']);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
}
