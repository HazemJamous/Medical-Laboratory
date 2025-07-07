import 'package:midical_laboratory/features/auth/data/auth_api_service.dart';

abstract class AuthRepository {
  Future<ApiResponse> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String gender,
    required String birthDate,
  });
  Future<ApiResponse> sendOtp({required String email});
  Future<ApiResponse> verifyOtp({required String email, required String code});
}
