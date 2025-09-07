import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/all_evaluation/cubit/all_evaluation_state.dart';
import 'package:midical_laboratory/cubit/details_lab_cubit/details_lab_state.dart';
import 'package:midical_laboratory/models/all_evaluation/all_evaluations_model.dart';
import 'package:midical_laboratory/models/all_evaluation/rate_review_request_model.dart';
import 'package:midical_laboratory/models/detalisLabModel/detailes_lab_model.dart';
import 'package:midical_laboratory/services/all_evaluations/all_evaluations_service.dart';
import 'package:midical_laboratory/services/analayse/analyses_service.dart';

class DetailsLabCubit extends Cubit<DetailsLabState> {
  DetailsLabCubit(this.labId) : super(DetailsLabLoading());

  final int labId;
  late DetalisLabModel? labModel;

  Future<void> getAllEvaluationsById() async {
    try {
      emit(DetailsLabLoading());
      labModel = await AnalysesService.getDetails(labId);
      emit(DetailsLabLoaded());
    } catch (e) {
      emit(DetailsLabFailure(e.toString()));
    }
  }
}
