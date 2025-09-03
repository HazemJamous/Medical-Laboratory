part of 'otp_cubit_cubit.dart';

@immutable
sealed class OtpCubitState {}

final class OtpInitial extends OtpCubitState {}

final class OtpLoading extends OtpCubitState {}

/// بولياني: true = نجاح تحقق، false = تم الإرسال فقط
final class OtpSuccess extends OtpCubitState {
  final bool isVerified;
  OtpSuccess(this.isVerified);
}

final class OtpFailure extends OtpCubitState {
  final String message;
  OtpFailure(this.message);
}
