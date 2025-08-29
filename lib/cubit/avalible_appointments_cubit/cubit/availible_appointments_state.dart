

import 'package:midical_laboratory/models/booking_appointments/get_available_appointments_model.dart';

sealed class AvailibleAppointmentsState {}

final class AvailibleAppointmentsLoading extends AvailibleAppointmentsState {}

final class AvailibleAppointmentsSuccess extends AvailibleAppointmentsState {
  final List<AvailableAppointmentsModel> appointments;
  AvailibleAppointmentsSuccess(this.appointments);
}

final class AvailibleAppointmentsFailure extends AvailibleAppointmentsState {
  final String message;
  AvailibleAppointmentsFailure([this.message = "حدث خطأ"]);
}
