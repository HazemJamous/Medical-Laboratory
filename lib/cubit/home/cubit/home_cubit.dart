import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:midical_laboratory/models/advertisment_model/advertisment_modle.dart';
import 'package:midical_laboratory/models/lap_information_model.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';
import 'package:midical_laboratory/services/advertisment/advertisment_service.dart';
import 'package:midical_laboratory/services/lab_search/lab_search_service.dart';
import 'package:midical_laboratory/services/my_bookings/my_bookings_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  List<LabInformationModel> labDataService = [];
  List<AdvertismentModel> advertDataService = [];
  MyBokingsModel? nearestAppointment;
  Future getDataOfHomePage() async {
    print("before loading");
    emit(HomeLoading());
    print("before get");
    labDataService = await LabSearchService.getAllLab() ?? [];
    advertDataService = await AdvertismentService.getAdvertisment() ?? [];
    nearestAppointment = await MyBookingsService.getNearestBookings();
    print("after get");
    emit(HomeLoaded());
    print("after loaded");
  }
}
