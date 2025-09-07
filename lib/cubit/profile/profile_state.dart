import 'package:midical_laboratory/models/booking_appointments/get_balance_model.dart';
import 'package:midical_laboratory/models/home_and_drawer/profile_model.dart';

abstract class ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfileModel profileModel;
  final GetBalanceModel balance;

  ProfileSuccessState({required this.profileModel, required this.balance});
}

class ProfileFailureState extends ProfileState {
  final String errorMessege;

  ProfileFailureState({required this.errorMessege});
}
