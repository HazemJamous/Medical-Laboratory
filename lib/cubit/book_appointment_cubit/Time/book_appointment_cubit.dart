// lib/cubit/book_appointment_cubit/Time/book_appointment_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:midical_laboratory/models/booking_appointments/request_booking_model.dart';
import 'package:midical_laboratory/services/book_appointment/book_appointment_service.dart';
import 'package:midical_laboratory/services/book_appointment/update_appointment_service.dart'; // تأكد المسار
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

  Future<void> updateAppointment(BookingAppointmentRequestModel request, int appointmentId) async {
    emit(BookAppointmentUpdateLoading());
    try {
      final success = await UpdateAppointmentService.UpdateAppointment(request, appointmentId);
      if (success) {
        emit(BookAppointmentUpdateSuccess());
      } else {
        emit(BookAppointmentUpdateFailure("فشل تعديل الموعد، حاول مرة أخرى"));
      }
    } catch (e) {
      emit(BookAppointmentUpdateFailure("حدث خطأ أثناء تعديل الموعد"));
    }
  }
}
