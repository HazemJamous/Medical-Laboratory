import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/all_evaluation/cubit/all_evaluation_state.dart';
import 'package:midical_laboratory/models/all_evaluation/all_evaluations_model.dart';
import 'package:midical_laboratory/models/all_evaluation/rate_review_request_model.dart';
import 'package:midical_laboratory/services/all_evaluations/all_evaluations_service.dart';
import 'package:midical_laboratory/services/all_evaluations/rate_review_service.dart';

class AllEvaluationCubit extends Cubit<AllEvaluationState> {
  AllEvaluationCubit(this.labId) : super(AllEvaluationLoading());

  final int labId;
  List<AllEvaluationsModel> allEvaluationService = [];


  Future<void> getAllEvaluationsById() async {
    try {
      emit(AllEvaluationLoading());
      allEvaluationService =
          await AllEvaluationsService.getAllEvaluations(labId) ?? [];
      emit(AllEvaluationLoaded());
    } catch (e) {
      emit(AllEvaluationFailure(e.toString()));
    }
  }


  Future<void> submitReview(num rate, String review) async {
    emit(AddReviewLoading());

    final request = RateReviewRequestModel(
      labId: labId,
      rate: rate,
      review: review,
    );
    
    final success = await RateReviewService.submitReview(request);

    if (success) {
      await getAllEvaluationsById();
      emit(AddReviewSuccess());
    } else {
      emit(AddReviewFailure("❌ تعذر إرسال التقييم، حاول لاحقاً"));
    }
  }
}