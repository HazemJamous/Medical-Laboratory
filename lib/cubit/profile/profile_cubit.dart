import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/profile/profile_state.dart';
import 'package:midical_laboratory/models/booking_appointments/get_balance_model.dart';
import 'package:midical_laboratory/models/home_and_drawer/profile_model.dart';
import 'package:midical_laboratory/services/analayse/analyses_service.dart';
import 'package:midical_laboratory/services/home_and_drawer/profile_service.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoadingState());

  late ProfileModel? profileModel;
  late GetBalanceModel balance;
  Future<void> profile() async {
    emit(ProfileLoadingState());
    profileModel = await ProfileService.getMyprofile();
    balance = await AnalysesService.getMyBalance();
    print("After git");
    if (profileModel != null) {
      emit(ProfileSuccessState(profileModel: profileModel!, balance: balance));
    } else {
      emit(ProfileFailureState(errorMessege: "errorMessege"));
    }
  }
}
