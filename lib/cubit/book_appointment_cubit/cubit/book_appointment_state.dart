part of 'book_appointment_cubit.dart';

@immutable
sealed class BookAppointmentState {}

final class BookAppointmentInitial extends BookAppointmentState {}

final class BookAppointmentLoading extends BookAppointmentState {}

final class BookAppointmentLoaded extends BookAppointmentState {}

final class BookAppointmentFailure extends BookAppointmentState {}
