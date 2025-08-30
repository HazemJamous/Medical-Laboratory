import 'package:bloc/bloc.dart';
part 'appointment_place_state.dart';

class AppointmentPlaceCubit extends Cubit<AppointmentPlaceState> {
  AppointmentPlaceCubit() : super(InLaboratory());

  // Future<void> submit(BookingAppointmentRequestModel request) async {
  //   emit(BookAppointmentLoading());
  //   try {
  //     final success = await BookAppointmentService.bookAppointment(request);
  //     if (success) {
  //       emit(BookAppointmentSuccess());
  //     } else {
  //       emit(BookAppointmentFailure("فشل الحجز، حاول مرة أخرى"));
  //     }
  //   } catch (e) {
  //     emit(BookAppointmentFailure("حدث خطأ أثناء الحجز"));
  //   }
  // }
}
