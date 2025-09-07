// update_password_state.dart
abstract class UpdatePasswordState {}

class UpdatePasswordInitial extends UpdatePasswordState {}

class UpdatePasswordLoadingState extends UpdatePasswordState {}

class UpdatePasswordSuccessState extends UpdatePasswordState {
  final String message;
  UpdatePasswordSuccessState({this.message = 'تم تعديل كلمة السر بنجاح'});
}

class UpdatePasswordFailureState extends UpdatePasswordState {
  final String errorMessege;
  UpdatePasswordFailureState({required this.errorMessege});
}
