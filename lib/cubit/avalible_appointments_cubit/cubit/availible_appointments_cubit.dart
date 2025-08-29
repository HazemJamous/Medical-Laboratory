import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/avalible_appointments_cubit/cubit/availible_appointments_state.dart';
import 'package:midical_laboratory/models/booking_appointments/get_available_appointments_model.dart';
import 'package:midical_laboratory/services/book_appointment/get_available_appointments_service.dart';


class AvailibleAppointmentsCubit extends Cubit<AvailibleAppointmentsState> {
  AvailibleAppointmentsCubit(this.labId) : super(AvailibleAppointmentsLoading());

  final int labId;
  List<AvailableAppointmentsModel> appointmentService = [];

  Future<void> getAvallibleAppointments() async {
    try {
      emit(AvailibleAppointmentsLoading());
      final list = await GetAvailableAppointmentsService.getAllAvailableAppointments(labId);
      appointmentService = list ?? [];
      emit(AvailibleAppointmentsSuccess(appointmentService));
    } catch (e) {
      emit(AvailibleAppointmentsFailure(e.toString()));
    }
  }
}
