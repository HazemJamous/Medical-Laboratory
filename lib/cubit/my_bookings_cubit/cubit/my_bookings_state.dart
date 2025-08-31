part of 'my_bookings_cubit.dart';

@immutable
sealed class MyBookingsState {}

final class MyBookingsLoading extends MyBookingsState {}

final class MyBookingsLoaded extends MyBookingsState {
  final List<MyBokingsModel> bookings;
  MyBookingsLoaded(this.bookings);
}

final class MyBookingsFailure extends MyBookingsState {
  final String message;
  MyBookingsFailure(this.message);
}
