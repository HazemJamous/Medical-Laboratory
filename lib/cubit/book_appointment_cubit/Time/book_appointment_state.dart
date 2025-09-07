// lib/cubit/book_appointment_cubit/Time/book_appointment_state.dart
part of 'book_appointment_cubit.dart';

sealed class BookAppointmentState {}

final class BookAppointmentInitial extends BookAppointmentState {}

final class BookAppointmentLoading extends BookAppointmentState {}

final class BookAppointmentSuccess extends BookAppointmentState {}

final class BookAppointmentFailure extends BookAppointmentState {
  final String message;
  BookAppointmentFailure(this.message);
}

// update states
final class BookAppointmentUpdateLoading extends BookAppointmentState {}

final class BookAppointmentUpdateSuccess extends BookAppointmentState {}

final class BookAppointmentUpdateFailure extends BookAppointmentState {
  final String message;
  BookAppointmentUpdateFailure(this.message);
}
