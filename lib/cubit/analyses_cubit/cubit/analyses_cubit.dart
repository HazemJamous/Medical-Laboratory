import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/models/analayses_model/analayses_model.dart';
import 'package:midical_laboratory/services/analayse/analyses_service.dart';

part 'analyses_state.dart';

class AnalysesCubit extends Cubit<AnalysesState> {
  AnalysesCubit() : super(AnalysesInitial());
  // final int labId;

  List<AnalayseModel> allAnalysesById = [];

  bool isSelectionMode = false;
  List<num> selectedIds = [];

  void toggleSelectionMode(bool enable) {
    isSelectionMode = enable;
    if (!enable) selectedIds.clear();
    emit(
      SelectionModeChanged(
        isSelectionMode: isSelectionMode,
        selectedIds: selectedIds,
      ),
    );
  }

  void toggleSelect(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    emit(
      SelectionModeChanged(
        isSelectionMode: isSelectionMode,
        selectedIds: List.from(selectedIds),
      ),
    );
  }

  Future getAllAnalysesById(int labId) async {
    print("before loading");
    emit(AnalysesLoading());
    allAnalysesById = await AnalysesService.getAllAnalyses(labId) ?? [];
    emit(AnalysesLoaded());
    print(" ====== length ===== ${allAnalysesById.length}");
    print("--------after loaded------");
  }
}
