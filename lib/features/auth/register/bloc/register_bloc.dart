import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/features/auth/domain/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _repo;
  RegisterBloc(this._repo) : super(RegisterInitial()) {
    on<SubmitRegistration>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitRegistration event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    final result = await _repo.register(
      firstName: event.firstName,
      lastName: event.lastName,
      phone: event.phone,
      email: event.email,
      password: event.password,
      gender: event.gender,
      birthDate: event.birthDate,
    );

    if (result.success) {
      emit(RegisterSuccess());
    } else {
      emit(RegisterFailure(result.message));
    }
  }
}