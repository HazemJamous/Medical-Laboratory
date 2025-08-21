import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/models/advertisment_model/advertisment_modle.dart';
import 'package:midical_laboratory/services/advertisment/advertisment_service.dart';

part 'advertisment_state.dart';

class AdvertismentCubit extends Cubit<AdvertismentState> {
  AdvertismentCubit(this._advertismentService)
    : super(AdvertismentLoadingState());  

  AdvertismentService _advertismentService;

  List<AdvertismentModel> advertService = [];

  Future getAdvertismentCubit() async { 
    print("before loading");
    emit(AdvertismentLoadingState());
    print("before get");
    advertService = await _advertismentService.getAdvertisment() ?? [];
    print("after get");
    emit(AdvertismentLoadedState(advertService));
    print("after loaded");
  }
}