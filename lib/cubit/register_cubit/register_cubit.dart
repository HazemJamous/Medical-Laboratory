import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/register_cubit/register_state.dart';
import 'package:midical_laboratory/models/register_request_model.dart';
import 'package:midical_laboratory/services/register_service.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(InitialState());

  late String token;

  Future<void> register(RegisterRequestModel registerRequestModel) async {
    emit(LoadingState());
    token = await RegisterService.register(registerRequestModel);
    if (token != "no token") {
      emit(RegisterSuccessState(token: token));
    } else {
      emit(RegisterFailureState(errorMessege: "errorMessege"));
    }
  }
}
