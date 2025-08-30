part of 'book_appointment_cubit.dart';

sealed class BookAppointmentState {}

final class BookAppointmentInitial extends BookAppointmentState {}

final class BookAppointmentLoading extends BookAppointmentState {}

final class BookAppointmentSuccess extends BookAppointmentState {}

final class BookAppointmentFailure extends BookAppointmentState {
  final String message;
  BookAppointmentFailure(this.message);
}
