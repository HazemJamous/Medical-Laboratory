part of 'otp_bloc.dart';

abstract class OtpState {}
class OtpInitial   extends OtpState {}
class OtpLoading   extends OtpState {}
class OtpSent      extends OtpState {}
class OtpVerified  extends OtpState {}
class OtpFailure   extends OtpState {
  final String message;
  OtpFailure(this.message);
}