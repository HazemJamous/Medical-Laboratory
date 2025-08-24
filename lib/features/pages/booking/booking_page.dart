// booking_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/avalible_appointments_cubit/cubit/availible_appointments_cubit.dart';
import 'package:midical_laboratory/models/analayses_model/analayses_model.dart';
import 'package:midical_laboratory/models/booking_appointments/get_available_appointments_model.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';

class BookingBottomSheetWrapper {
  static void show(BuildContext context, int labId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider(
          create: (_) =>
              AvailibleAppointmentsCubit(labId)..getAvallibleAppointments(),
          child: BookingBottomSheet(labId: labId),
        );
      },
    );
  }
}

class BookingBottomSheet extends StatefulWidget {
  final AnalayseModel? analysis;
  final int labId;

  const BookingBottomSheet({super.key, this.analysis, required this.labId});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _patientName = TextEditingController();
  final _patientPhone = TextEditingController();
  final _patientIdNumber = TextEditingController();

  AvailableAppointmentsModel? selectedDateTime;
  String? selectedType;

  late final AnimationController _controller;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void submitBooking() {
    if (_formKey.currentState!.validate() &&
        selectedDateTime != null &&
        selectedType != null) {
      final bookingRequest = {
        "type": selectedType,
        "patient_name": _patientName.text.trim(),
        "patient_phone": _patientPhone.text.trim(),
        "patient_id_number": _patientIdNumber.text.trim(),
        "lab_id": widget.labId,
        "date_time": selectedDateTime!.dateTime.toIso8601String(),
      };
      print("Booking Request: $bookingRequest");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال طلب الحجز بنجاح')));
      Navigator.of(context).pop();
    }
  }

  String formatDateTime(DateTime dt) =>
      DateFormat('yyyy-MM-dd – HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailibleAppointmentsCubit, AvailibleAppointmentsState>(
      builder: (context, state) {
        final cubit = context.read<AvailibleAppointmentsCubit>();
        final availableDateTimes = cubit.appointmentService;

        if (selectedDateTime == null && availableDateTimes.isNotEmpty) {
          selectedDateTime = availableDateTimes.first;
          selectedType = selectedDateTime!.typeOptions.first;
        }

        return SlideTransition(
          position: _slideIn,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: RTLWrapper(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: ListView(
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.analysis?.labAnalysesName ?? "اختر تحليل",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'اختر الموعد:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (availableDateTimes.isEmpty) ...[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("جاري تحميل المواعيد..."),
                        ),
                      ),
                    ] else ...[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child:
                            DropdownButtonFormField<AvailableAppointmentsModel>(
                              value: selectedDateTime,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                              items: availableDateTimes.map((dt) {
                                return DropdownMenuItem(
                                  value: dt,
                                  child: Text(formatDateTime(dt.dateTime)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedDateTime = val;
                                  selectedType = val?.typeOptions.first;
                                });
                              },
                            ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (selectedDateTime != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نوع الحجز:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: (selectedDateTime?.typeOptions ?? []).map(
                              (t) {
                                return ChoiceChip(
                                  label: Text(
                                    t == "IN_LAB" ? "في المختبر" : "في المنزل",
                                  ),
                                  selected: selectedType == t,
                                  onSelected: (_) {
                                    setState(() => selectedType = t);
                                  },
                                  selectedColor: AppColors.accent.withOpacity(
                                    0.18,
                                  ),
                                  labelStyle: TextStyle(
                                    color: selectedType == t
                                        ? AppColors.primary
                                        : AppColors.textColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: selectedType == t
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اسم المريض:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          NameFormField(
                            label: 'ادخل اسم المريض',
                            controller: _patientName,
                            type: TextInputType.name,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'رقم الهاتف:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          NameFormField(
                            label: 'ادخل رقم الهاتف',
                            controller: _patientPhone,
                            type: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'رقم الهوية:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          NameFormField(
                            label: 'ادخل رقم الهوية',
                            controller: _patientIdNumber,
                            type: TextInputType.number,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: CustomButton(
                              function: submitBooking,
                              text: "حجز موعد",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
