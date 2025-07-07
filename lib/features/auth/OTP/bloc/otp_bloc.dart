import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/features/auth/domain/auth_repository.dart';


part 'otp_event.dart';
part 'otp_state.dart';


class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthRepository _repo;
  OtpBloc(this._repo) : super(OtpInitial()) {
    on<RequestOtp>(_onRequest);
    on<VerifyOtp>(_onVerify);
  }

  Future<void> _onRequest(RequestOtp e, Emitter<OtpState> emit) async {
    emit(OtpLoading());
    final res = await _repo.sendOtp(email: e.email);
    res.success ? emit(OtpSent()) : emit(OtpFailure(res.message));
  }

  Future<void> _onVerify(VerifyOtp e, Emitter<OtpState> emit) async {
    emit(OtpLoading());
    final res = await _repo.verifyOtp(email: e.email, code: e.code);
    res.success ? emit(OtpVerified()) : emit(OtpFailure(res.message));
  }
}