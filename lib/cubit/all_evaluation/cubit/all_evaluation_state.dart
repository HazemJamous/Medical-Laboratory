part of 'all_evaluation_cubit.dart';


sealed class AllEvaluationState {}

final class AllEvaluationLoading extends AllEvaluationState {}

final class AllEvaluationLoaded extends AllEvaluationState {}


final class AllEvaluationFailure extends AllEvaluationState {
  var message ="Failure";
}

