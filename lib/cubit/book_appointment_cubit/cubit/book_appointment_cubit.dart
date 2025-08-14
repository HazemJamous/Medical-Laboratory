import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'book_appointment_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  
  BookAppointmentCubit(int labId) : super(BookAppointmentInitial());

  
}
