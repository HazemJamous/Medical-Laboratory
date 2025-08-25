  

sealed class AllEvaluationState {}

final class AllEvaluationLoading extends AllEvaluationState {}

final class AllEvaluationLoaded extends AllEvaluationState {}

final class AllEvaluationFailure extends AllEvaluationState {
  final String message;
  AllEvaluationFailure(this.message);
}

final class AddReviewLoading extends AllEvaluationState {}

final class AddReviewSuccess extends AllEvaluationState {}

final class AddReviewFailure extends AllEvaluationState {
  final String message;
  AddReviewFailure(this.message);
}