import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/models/analayses_model/analayses_model.dart';
import 'package:midical_laboratory/services/analayse/analyses_service.dart';
import 'package:midical_laboratory/models/booking_appointments/get_balance_model.dart';

part 'analyses_state.dart';

class AnalysesCubit extends Cubit<AnalysesState> {
  AnalysesCubit() : super(AnalysesInitial());

  List<AnalayseModel> allAnalysesById = [];

  bool isSelectionMode = false;
  List<int> selectedIds = []; // ✅ خليها int

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

  Future<void> getAllAnalysesById(int labId) async {
    emit(AnalysesLoading());
    allAnalysesById = await AnalysesService.getAllAnalyses(labId) ?? [];
      emit(AnalysesLoaded());
  }

  /// استدعاء خدمة جلب رصيد المستخدم.
  /// يعيد GetBalanceModel? أو null عند الفشل.
  Future<GetBalanceModel?> getBalance() async {
    try {
      final res = await AnalysesService.getMyBalance();
      return res;
    } catch (e) {
      // يمكنك طباعة الخطأ أثناء التطوير لو أحببت:
      // print('getBalance error: $e');
      return null;
    }
  }
}
