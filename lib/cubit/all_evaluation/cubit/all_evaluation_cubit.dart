import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/models/all_evaluation/all_evaluations_model.dart';
import 'package:midical_laboratory/services/all_evaluations/all_evaluations_service.dart';

part 'all_evaluation_state.dart';

class AllEvaluationCubit extends Cubit<AllEvaluationState> {
  AllEvaluationCubit(this.lab_id) : super(AllEvaluationLoading());
  int lab_id;

  List<AllEvaluationsModel> allEvaluationService = [];
  Future getAllEvaluationsById() async {
    print("before loading");
    emit(AllEvaluationLoading());
    allEvaluationService =
        await AllEvaluationsService.getAllEvaluations(lab_id) ?? [];
    emit(AllEvaluationLoaded());
  }
}
