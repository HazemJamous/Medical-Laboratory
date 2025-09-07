import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/models/home_and_drawer/update_patient_model.dart';
import 'package:midical_laboratory/services/update_services/update_services.dart';
import 'update_patient_state.dart';
class UpdatePatientCubit extends Cubit<UpdatePatientState> {
  UpdatePatientCubit() : super(InitialState());

  Future<void> updatePatient(UpdatePatientModel patientModel) async {
    emit(UpdatePatientLoadingState());
    final result = await UpdateServices.updatePatient(patientModel);
    if (result['success'] == true) {
      emit(UpdatePatientSuccessState(message: result['message'] ?? 'تم تعديل البيانات بنجاح'));
    } else {
      emit(UpdatePatientFailureState(errorMessege: result['message'] ?? 'حدث خطأ'));
    }
  }
}
