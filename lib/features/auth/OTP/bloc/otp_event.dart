part of 'otp_bloc.dart';

abstract class OtpEvent {}
class RequestOtp   extends OtpEvent {
  final String email;
  RequestOtp({required this.email});
}
class VerifyOtp    extends OtpEvent {
  final String email, code;
  VerifyOtp({required this.email, required this.code});
}