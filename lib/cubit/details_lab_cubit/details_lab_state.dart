  

sealed class DetailsLabState {}

final class DetailsLabLoading extends DetailsLabState {}

final class DetailsLabLoaded extends DetailsLabState {}

final class DetailsLabFailure extends DetailsLabState {
  final String message;
  DetailsLabFailure(this.message);
}
