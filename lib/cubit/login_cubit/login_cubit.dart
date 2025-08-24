import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/login_cubit/login_state.dart';
import 'package:midical_laboratory/models/login_request_model.dart';
import 'package:midical_laboratory/services/auth/log_in_service.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(InitialState());

  late String token;

  Future<void> login(LogInRequestModel logInRequestModel) async {
    emit(LoadingState());
    token = await LogInService.login(logInRequestModel);
    if (token != "no token") {
      emit(LoginSuccessState(token: token));
    } else {
      emit(LoginFailureState(errorMessege: "errorMessege"));
    }
  }
}
