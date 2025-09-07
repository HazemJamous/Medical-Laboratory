// lib/cubit/update_email_cubit/update_email_state.dart
import 'package:midical_laboratory/models/home_and_drawer/update_email_model.dart';

abstract class UpdateEmailState {}

class UpdateEmailInitial extends UpdateEmailState {}

class UpdateEmailLoadingState extends UpdateEmailState {}

class UpdateEmailSuccessState extends UpdateEmailState {
  final UpdateEmailModel emailModel;
  UpdateEmailSuccessState({required this.emailModel});
}

class UpdateEmailFailureState extends UpdateEmailState {
  final String errorMessege;
  UpdateEmailFailureState({required this.errorMessege});
}
