part of 'appointment_place_cubit.dart';

sealed class AppointmentPlaceState {}

final class InLaboratory extends AppointmentPlaceState {}

final class InHome extends AppointmentPlaceState {}
