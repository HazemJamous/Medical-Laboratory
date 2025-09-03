import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:midical_laboratory/models/otp/otp_request_model.dart';
import 'package:midical_laboratory/models/otp/otp_resend_request_model.dart';
import 'package:midical_laboratory/services/auth/otp_service.dart';

part 'otp_cubit_state.dart';

class OtpCubit extends Cubit<OtpCubitState> {
  OtpCubit() : super(OtpInitial());

  /// Verify OTP
  Future<void> verifyOtp(OtpRequestModel otpRequest) async {
    emit(OtpLoading());
    try {
      final isVerified = await OtpService.otp(otpRequest);
      if (isVerified) {
        emit(OtpSuccess(true));
      } else {
        emit(OtpFailure("Invalid OTP or server error"));
      }
    } catch (e) {
      emit(OtpFailure("Something went wrong: ${e.toString()}"));
    }
  }

  /// Resend OTP
  Future<void> resendOtp(String email) async {
    emit(OtpLoading());
    try {
      final isResent = await OtpService.otpResend(
        OtpResendRequestModel(email: email),
      );
      if (isResent) {
        emit(OtpSuccess(false)); // false = just resent, not verified
      } else {
        emit(OtpFailure("Failed to resend OTP. Try again."));
      }
    } catch (e) {
      emit(OtpFailure("Something went wrong: ${e.toString()}"));
    }
  }
}
