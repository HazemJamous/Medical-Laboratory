import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:midical_laboratory/models/lap_information_model.dart';
import 'package:midical_laboratory/services/lab_search/lab_search_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  List<LabInformationModel>   labDataService = [];

  Future getDataOfHomePage() async {
    print("before loading");
    emit(HomeLoading());
    print("before get");
    labDataService = await LabSearchService.getAllLab() ?? [];
    print("after get");
    emit(HomeLoaded());
    print("after loaded");
  }
}
