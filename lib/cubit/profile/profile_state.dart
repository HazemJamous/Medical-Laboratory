import 'package:midical_laboratory/models/home_and_drawer/profile_model.dart';

abstract class ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfileModel profileModel;
  ProfileSuccessState({required this.profileModel});
}

class ProfileFailureState extends ProfileState {
  final String errorMessege;

  ProfileFailureState({required this.errorMessege});
}
