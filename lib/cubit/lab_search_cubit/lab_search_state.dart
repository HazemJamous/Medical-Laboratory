import 'package:midical_laboratory/models/lap_information_model.dart';

abstract class LabSearchState {}

class LoadingState extends LabSearchState {}

class SuccessState extends LabSearchState {
  List<LabInformationModel> labInfo;
    SuccessState({required this.labInfo});
}

class FailureState extends LabSearchState {
  final String errorMessege;
  FailureState({required this.errorMessege});
}
