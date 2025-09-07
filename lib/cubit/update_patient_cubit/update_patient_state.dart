abstract class UpdatePatientState {}

class InitialState extends UpdatePatientState {}

class UpdatePatientLoadingState extends UpdatePatientState {}

class UpdatePatientSuccessState extends UpdatePatientState {
  final String message;
  UpdatePatientSuccessState({this.message = 'تم تعديل البيانات بنجاح'});
}

class UpdatePatientFailureState extends UpdatePatientState {
  final String errorMessege;
  UpdatePatientFailureState({required this.errorMessege});
}
