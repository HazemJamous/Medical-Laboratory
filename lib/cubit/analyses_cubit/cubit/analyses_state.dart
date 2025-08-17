part of 'analyses_cubit.dart';


sealed class AnalysesState {}

final class AnalysesLoading extends AnalysesState {}

final class AnalysesLoaded extends AnalysesState {}

final class AnalysesFailure extends AnalysesState {}


