// update_password_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/models/home_and_drawer/update_password_model.dart';
import 'package:midical_laboratory/services/update_services/update_services.dart';
import 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit() : super(UpdatePasswordInitial());

  Future<void> updatePassword(UpdatePasswordModel passwordModel) async {
    emit(UpdatePasswordLoadingState());
    final message = await UpdateServices.UpdatePassword(passwordModel);
    // تصحيح: إذا كانت الرسالة تساوي نص النجاح -> Success، وإلا Failure
    if (message == "تم تعديل كلمة السر بنجاح") {
      emit(UpdatePasswordSuccessState(message: message));
    } else {
      emit(UpdatePasswordFailureState(errorMessege: message));
    }
  }
}
