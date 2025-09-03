import 'package:dio/dio.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/log_print_interceptor.dart';
import 'package:midical_laboratory/models/otp/otp_request_model.dart';
import 'package:midical_laboratory/models/otp/otp_resend_request_model.dart';

class OtpService {
  /// Returns `true` if OTP is valid, otherwise `false`
  static Future<bool> otp(OtpRequestModel user) async {
    Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
    try {
      Response response = await dio.post(
        ApiLink.verifyEmail,
        data: {"email": user.email.trim(), "code": user.code.trim()},
      );

      if (response.statusCode == 200) {
        print("OTP Verified Successfully");
        return true;
      } else {
        print("OTP Verification Failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error in OTP Verification: $e");
      return false;
    }
  }

  ////////////////////
  static Future<bool> otpResend(OtpResendRequestModel user) async {
    Dio dio = Dio()..interceptors.addAll([LogPrintInterceptor()]);
    try {
      Response response = await dio.post(
        ApiLink.resendVerification,
        data: {"email": user.email.trim()},
      );

      if (response.statusCode == 200) {
        print("OTP resend Successfully");
        return true;
      } else {
        print("OTP resend Failed: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error in OTP resend Verification: $e");
      return false;
    }
  }
}
