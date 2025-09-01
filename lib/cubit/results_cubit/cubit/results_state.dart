// lib/cubit/results/results_state.dart
part of 'results_cubit.dart';

@immutable
sealed class ResultsState {}

final class ResultsInitial extends ResultsState {}

final class ResultsLoading extends ResultsState {}

final class ResultsLoaded extends ResultsState {
  final List<ResultsBookingsAppointmentModel> results;
  ResultsLoaded(this.results);
}

final class ResultsEmpty extends ResultsState {}

final class ResultsFailure extends ResultsState {
  final String message;
  ResultsFailure(this.message);
}
