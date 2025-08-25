import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/avalible_appointments_cubit/cubit/availible_appointments_cubit.dart';
import 'package:midical_laboratory/cubit/book_appointment_cubit/cubit/book_appointment_cubit.dart';
import 'package:midical_laboratory/models/analayses_model/analayses_model.dart';
import 'package:midical_laboratory/models/booking_appointments/get_available_appointments_model.dart';
import 'package:midical_laboratory/models/booking_appointments/request_booking_model.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';

class BookingBottomSheetWrapper {
  static Future<bool?> show(BuildContext context, int labId, {AnalayseModel? analysis}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AvailibleAppointmentsCubit(labId)..getAvallibleAppointments(),
            ),
            BlocProvider(
              create: (_) => BookAppointmentCubit(),
            ),
          ],
          child: BookingBottomSheet(labId: labId, analysis: analysis),
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
  final _patientIdNumber = TextEditingController(); // الرقم الوطني

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
    _patientName.dispose();
    _patientPhone.dispose();
    _patientIdNumber.dispose();
    super.dispose();
  }

  void _submitBooking() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      _showSnack('يرجى إكمال الحقول المطلوبة بشكل صحيح.');
      return;
    }
    if (selectedDateTime == null) {
      _showSnack('يرجى اختيار موعد.');
      return;
    }
    if (selectedType == null) {
      _showSnack('يرجى اختيار نوع الحجز.');
      return;
    }

    /// تجهيز قائمة التحاليل المختارة
    final List<int> selectedAnalysesIds = [];
    if (widget.analysis != null) {
      selectedAnalysesIds.add(widget.analysis!.id);
    }

    final req = BookingAppointmentRequestModel(
      type: selectedType!,
      patientName: _patientName.text.trim(),
      patientPhone: _patientPhone.text.trim(),
      patientIdNumber: _patientIdNumber.text.trim(), // الرقم الوطني
      labId: widget.labId,
      dateTime: selectedDateTime!.dateTime,
      analyses: selectedAnalysesIds,
    );

    context.read<BookAppointmentCubit>().submit(req);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _formatDateTime(DateTime dt) => DateFormat('yyyy-MM-dd – HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
      listener: (context, state) {
        if (state is BookAppointmentSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is BookAppointmentFailure) {
          _showSnack(state.message);
        }
      },
      builder: (context, bookingState) {
        final isSubmitting = bookingState is BookAppointmentLoading;

        return BlocBuilder<AvailibleAppointmentsCubit, AvailibleAppointmentsState>(
          builder: (context, availState) {
            final availCubit = context.read<AvailibleAppointmentsCubit>();
            final availableDateTimes = availCubit.appointmentService;

            if (selectedDateTime == null && availableDateTimes.isNotEmpty) {
              selectedDateTime = availableDateTimes.first;
              selectedType = selectedDateTime!.typeOptions.isNotEmpty
                  ? selectedDateTime!.typeOptions.first
                  : null;
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
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.analysis?.labAnalysesName ?? "حجز موعد تحليل",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'اختر الموعد:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        const SizedBox(height: 8),

                        if (availState is AvailibleAppointmentsLoading) ...[
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ] else if (availableDateTimes.isEmpty) ...[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("لا توجد مواعيد متاحة حالياً",
                                  style: TextStyle(color: Colors.grey[700])),
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
                            child: DropdownButtonFormField<AvailableAppointmentsModel>(
                              value: selectedDateTime,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(12),
                              ),
                              items: availableDateTimes.map((dt) {
                                return DropdownMenuItem(
                                  value: dt,
                                  child: Text(_formatDateTime(dt.dateTime)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedDateTime = val;
                                  selectedType = val?.typeOptions.isNotEmpty == true
                                      ? val!.typeOptions.first
                                      : null;
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
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: (selectedDateTime?.typeOptions ?? []).map((t) {
                                  final isSelected = selectedType == t;
                                  return ChoiceChip(
                                    label: Text(t == "IN_LAB" ? "في المختبر" : "في المنزل"),
                                    selected: isSelected,
                                    onSelected: (_) => setState(() => selectedType = t),
                                    selectedColor: AppColors.accent.withOpacity(0.18),
                                    labelStyle: TextStyle(
                                      color: isSelected ? AppColors.primary : AppColors.textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),

                        const SizedBox(height: 16),

                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('اسم المريض:',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                              const SizedBox(height: 8),
                              NameFormField(
                                label: 'ادخل اسم المريض',
                                controller: _patientName,
                                type: TextInputType.name,
                                isRTL: true,
                                validator: (value) {
                                  final v = value?.trim() ?? '';
                                  if (v.isEmpty) return 'الاسم مطلوب';
                                  if (v.length < 2) return 'الاسم قصير جداً';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              Text('رقم الهاتف:',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                              const SizedBox(height: 8),
                              NameFormField(
                                label: 'ادخل رقم الهاتف',
                                controller: _patientPhone,
                                type: TextInputType.phone,
                                isRTL: true,
                                validator: (value) {
                                  final v = value?.trim() ?? '';
                                  if (v.isEmpty) return 'رقم الهاتف مطلوب';
                                  if (v.length < 9) return 'رقم الهاتف غير صالح';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              Text('الرقم الوطني:',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                              const SizedBox(height: 8),
                              NameFormField(
                                label: 'ادخل الرقم الوطني',
                                controller: _patientIdNumber,
                                type: TextInputType.number,
                                isRTL: true,
                                validator: (value) {
                                  final v = value?.trim() ?? '';
                                  if (v.isEmpty) return 'الرقم الوطني مطلوب';
                                  if (v.length < 6) return 'الرقم الوطني غير صالح';
                                  return null;
                                },
                              ),

                              const SizedBox(height: 24),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: isSubmitting
                                    ? const Center(child: CircularProgressIndicator())
                                    : CustomButton(
                                        function: _submitBooking,
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
      },
    );
  }
}
