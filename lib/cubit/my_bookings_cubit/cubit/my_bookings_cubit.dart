// lib/cubit/my_bookings_cubit/cubit/my_bookings_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';
import 'package:midical_laboratory/services/book_appointment/delete_appointment_service.dart';
import 'package:midical_laboratory/services/my_bookings/my_bookings_service.dart';


part 'my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit() : super(MyBookingsLoading());

  Future<void> getMyBookingsNavBar() async {
    try {
      emit(MyBookingsLoading());
      final bookings = await MyBookingsService.getMyBookings();
      if (bookings != null && bookings.isNotEmpty) {
        emit(MyBookingsLoaded(bookings));
      } else {
        emit(MyBookingsFailure("لا يوجد مواعيد حالياً"));
      }
    } catch (e) {
      emit(MyBookingsFailure("فشل في تحميل المواعيد"));
    }
  }

  Future<void> deleteBooking(int appointmentId) async {
    try {
      emit(MyBookingsLoading());
      bool success = await DeleteAppointmentService.deleteAppointment(appointmentId);
      if (success) {
        await getMyBookingsNavBar(); // إعادة تحميل المواعيد بعد الحذف
      } else {
        emit(MyBookingsFailure("فشل في حذف الموعد"));
      }
    } catch (e) {
      emit(MyBookingsFailure("حدث خطأ أثناء حذف الموعد"));
    }
  }
}
