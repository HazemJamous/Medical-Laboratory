part of 'availible_appointments_cubit.dart';


sealed class AvailibleAppointmentsState {}

final class AvailibleAppointmentsLoading extends AvailibleAppointmentsState {}

final class AvailibleAppointmentsLoaded extends AvailibleAppointmentsState {}

final class AvailibleAppointmentsFailure extends AvailibleAppointmentsState {}
