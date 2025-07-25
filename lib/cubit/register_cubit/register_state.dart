abstract class RegisterState {}

class InitialState extends RegisterState {}

class LoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final String token;

  RegisterSuccessState({required this.token});
}

class RegisterFailureState extends RegisterState {
  final String errorMessege;

  RegisterFailureState({required this.errorMessege});
}
