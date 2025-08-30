import 'package:bloc/bloc.dart';
import 'package:midical_laboratory/models/booking_appointments/request_booking_model.dart';
import 'package:midical_laboratory/services/book_appointment/book_appointment_service.dart';

part 'book_appointment_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  BookAppointmentCubit() : super(BookAppointmentInitial());

  Future<void> submit(BookingAppointmentRequestModel request) async {
    emit(BookAppointmentLoading());
    try {
      final success = await BookAppointmentService.bookAppointment(request);
      if (success) {
        emit(BookAppointmentSuccess());
      } else {
        emit(BookAppointmentFailure("فشل الحجز، حاول مرة أخرى"));
      }
    } catch (e) {
      emit(BookAppointmentFailure("حدث خطأ أثناء الحجز"));
    }
  }
}
