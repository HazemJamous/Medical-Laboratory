part of 'advertisment_cubit.dart';

@immutable
sealed class AdvertismentState {}

class AdvertismentLoadingState extends AdvertismentState {}

class AdvertismentLoadedState extends AdvertismentState {
  AdvertismentLoadedState(List<AdvertismentModel> advertService);
}

class AdvertismentFailureState extends AdvertismentState {
  var message ="Failure";
}