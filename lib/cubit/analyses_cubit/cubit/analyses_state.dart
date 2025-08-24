// analyses_cubit.dart

part of 'analyses_cubit.dart';

abstract class AnalysesState {}

class AnalysesInitial extends AnalysesState {}

class AnalysesLoading extends AnalysesState {}

class AnalysesLoaded extends AnalysesState {}

class AnalysesFailure extends AnalysesState {}

class SelectionModeChanged extends AnalysesState {
  final bool isSelectionMode;
  final List<num> selectedIds;
  SelectionModeChanged({required this.isSelectionMode, required this.selectedIds});
}
