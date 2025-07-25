abstract class LoginState {}

class InitialState extends LoginState {}

class LoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final String token;

  LoginSuccessState({required this.token});
}

class LoginFailureState extends LoginState {
  final String errorMessege;

  LoginFailureState({required this.errorMessege});
}
