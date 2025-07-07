import 'package:midical_laboratory/features/auth/domain/auth_repository.dart';
import 'package:midical_laboratory/features/auth/data/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  AuthRepositoryImpl(this._apiService);

  @override
  Future<ApiResponse> register({ 
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String gender,
    required String birthDate,
  }) {
    return _apiService.register(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      password: password,
      gender: gender,
      birthDate: birthDate,
    );
  }

  @override
  Future<ApiResponse> sendOtp({required String email}) =>
    _apiService.sendOtp(email: email);

  @override
  Future<ApiResponse> verifyOtp({required String email, required String code}) =>
    _apiService.verifyOtp(email: email, code: code);


}