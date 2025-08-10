part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {}

final class HomeFailure extends HomeState {}
