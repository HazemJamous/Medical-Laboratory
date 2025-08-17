import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/models/analayses_model/analayses_model.dart';
import 'package:midical_laboratory/services/analayse/analyses_service.dart';

part 'analyses_state.dart';

class AnalysesCubit extends Cubit<AnalysesState> {
  AnalysesCubit(this.lab_id) : super(AnalysesLoading());
  int lab_id;
  List<AnalayseModel> allAnalysesById = [];
  Future getAllAnalysesById() async {
    print("before loading");
    emit(AnalysesLoading());
    allAnalysesById =
        await AnalysesService.getAllAnalyses(lab_id) ?? [];
    emit(AnalysesLoaded());
  }
}
