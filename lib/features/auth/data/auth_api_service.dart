import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;
  AuthApiService([Dio? dio]) : _dio = dio ?? Dio();

  Future<ApiResponse> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String gender,
    required String birthDate,
  }) async {
    try {
      final resp = await _dio.post(
        'https://yourdomain.com/api/register',
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "phone": phone,
          "email": email,
          "password": password,
          "gender": gender,
          "birth_date": birthDate,
        },
      );

      return ApiResponse(
        success: resp.statusCode == 200,
        message: resp.data['message'] ?? 'تم التسجيل بنجاح',
      );
    } on DioError catch (e) {
      // اسمح بإيصال رسالة الخطأ الفعلية
      final msg = e.response?.data['error'] ?? 'فشل الاتصال بالسيرفر';
      return ApiResponse(success: false, message: msg);
    } catch (_) {
      return ApiResponse(success: false, message: 'خطأ غير متوقع');
    }
  }

  // إرسال رمز التحقق إلى الإيميل
  Future<ApiResponse> sendOtp({required String email}) async {
    return ApiResponse(success: false, message: 'خطأ غير متوقع');
  }

  // تحقق من الرمز
  Future<ApiResponse> verifyOtp({
    required String email,
    required String code,
  }) async {
    return ApiResponse(success: false, message: 'خطأ غير متوقع');
  }
}

class ApiResponse {
  final bool success;
  final String message;
  ApiResponse({required this.success, required this.message});
}
