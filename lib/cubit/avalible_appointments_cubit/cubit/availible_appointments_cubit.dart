
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/models/booking_appointments/get_available_appointments_model.dart';
import 'package:midical_laboratory/services/book_appointment/get_available_appointments_service.dart';
part 'availible_appointments_state.dart';

class AvailibleAppointmentsCubit extends Cubit<AvailibleAppointmentsState> {
  AvailibleAppointmentsCubit(this.labId)
    : super(AvailibleAppointmentsLoading());

  int labId;
  List<AvailableAppointmentsModel> appointmentService = [];
  Future getAvallibleAppointments() async {
    appointmentService =
        await GetAvailableAppointmentsService.getAllAvailableAppointments(
          labId,
        ) ??
        [];
  }
}
