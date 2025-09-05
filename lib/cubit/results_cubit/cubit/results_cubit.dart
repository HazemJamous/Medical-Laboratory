// lib/cubit/results/results_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:midical_laboratory/models/my_bookings_model/results_bookings_appointment_model.dart';
import 'package:midical_laboratory/services/my_bookings/my_bookings_service.dart';

part 'results_state.dart';

class ResultsCubit extends Cubit<ResultsState> {
  ResultsCubit() : super(ResultsInitial());

  Future<void> getResults(int appointmentId) async {
    try {
      emit(ResultsLoading());
      final results = await MyBookingsService.getResultsOfMyBookings(
        appointmentId,
      );
      if (results != null && results.isNotEmpty) {
        emit(ResultsLoaded(results));
      } else {
        emit(ResultsEmpty());
      }
    } catch (e) {
      emit(ResultsFailure("فشل في جلب النتائج. حاول لاحقاً"));
    }
  }
}
