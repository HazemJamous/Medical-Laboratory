// lib/cubit/update_email_cubit/update_email_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/home_and_drawer/update_email_model.dart';
import '../../services/update_services/update_services.dart';
import 'update_email_state.dart';

class UpdateEmailCubit extends Cubit<UpdateEmailState> {
  UpdateEmailCubit() : super(UpdateEmailInitial());

  Future<void> updateEmail(UpdateEmailModel emailModel) async {
    emit(UpdateEmailLoadingState());

    // استدعاء الـ service الموجود عندك
    final message = await UpdateServices.UpdateEmail(emailModel);

    const successMsg = "تم تعديل حسابك الايميل بنجاح";

    if (message == successMsg) {
      // ضع علامة pending في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('email_pending_verification', true);
      await prefs.setString('pending_email', emailModel.email.trim());

      emit(UpdateEmailSuccessState(emailModel: emailModel));
    } else {
      emit(UpdateEmailFailureState(errorMessege: message));
    }
  }
}
