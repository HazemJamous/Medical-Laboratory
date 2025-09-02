import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:midical_laboratory/cubit/avalible_appointments_cubit/cubit/availible_appointments_cubit.dart';
import 'package:midical_laboratory/cubit/avalible_appointments_cubit/cubit/availible_appointments_state.dart';
import 'package:midical_laboratory/cubit/book_appointment_cubit/Place/appointment_place_cubit.dart';
import 'package:midical_laboratory/cubit/book_appointment_cubit/Time/book_appointment_cubit.dart';
import 'package:midical_laboratory/models/analayses_model/analayses_model.dart';
import 'package:midical_laboratory/models/booking_appointments/get_available_appointments_model.dart';
import 'package:midical_laboratory/models/booking_appointments/request_booking_model.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/shared/widgets/book_appointment_widgets/map_picker_widget.dart';

class BookingBottomSheetWrapper {
  static Future<bool?> show(
    BuildContext context,
    double totalPrice,
    int labId, {
    List<int>? selectedIds,
    AnalayseModel? analysis,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  AvailibleAppointmentsCubit(labId)..getAvallibleAppointments(),
            ),
            BlocProvider(create: (_) => BookAppointmentCubit()),
            BlocProvider(create: (_) => AppointmentPlaceCubit()), // ✅ ضروري
          ],
          child: BookingBottomSheet(
            labId: labId,
            analysis: analysis,
            preSelectedIds: selectedIds,
          ),
        );
      },
    );
  }
}

class BookingBottomSheet extends StatefulWidget {
  final AnalayseModel? analysis;
  final int labId;
  final List<int>? preSelectedIds;

  const BookingBottomSheet({
    Key? key,
    this.analysis,
    required this.labId,
    this.preSelectedIds,
  }) : super(key: key);

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _patientName = TextEditingController();
  final _patientPhone = TextEditingController();
  final _patientIdNumber = TextEditingController();

  AvailableAppointmentsModel? selectedDateTime;
  String? selectedType;
  List<int> selectedAnalysesIds = [];
  LatLng? selectedLocation; // ✅ الموقع المختار

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedIds != null) {
      selectedAnalysesIds = List.from(widget.preSelectedIds!);
    }
  }

  @override
  void dispose() {
    _patientName.dispose();
    _patientPhone.dispose();
    _patientIdNumber.dispose();
    super.dispose();
  }

  void _submitBooking() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    if (selectedDateTime == null || selectedType == null) return;
    if (selectedAnalysesIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار تحليل واحد على الأقل")),
      );
      return;
    }
    if (selectedType == "IN_HOME" && selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى اختيار موقع المنزل على الخريطة")),
      );
      return;
    }

    final req = BookingAppointmentRequestModel(
      type: selectedType!,
      patientName: _patientName.text.trim(),
      patientPhone: _patientPhone.text.trim(),
      patientIdNumber: _patientIdNumber.text.trim(),
      labId: widget.labId,
      dateTime: selectedDateTime!.dateTime,
      analyses: selectedAnalysesIds,
      latitude: selectedLocation?.latitude,
      longitude: selectedLocation?.longitude,
    );

    context.read<BookAppointmentCubit>().submit(req);
  }

  String _formatDate(DateTime dt) =>
      DateFormat('yyyy-MM-dd – HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookAppointmentCubit, BookAppointmentState>(
      listener: (context, state) {
        if (state is BookAppointmentSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is BookAppointmentFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, bookingState) {
        final isSubmitting = bookingState is BookAppointmentLoading;

        return BlocBuilder<
          AvailibleAppointmentsCubit,
          AvailibleAppointmentsState
        >(
          builder: (context, availState) {
            final availCubit = context.read<AvailibleAppointmentsCubit>();
            final availableDateTimes = availCubit.appointmentService;

            if (selectedDateTime == null && availableDateTimes.isNotEmpty) {
              selectedDateTime = availableDateTimes.first;
              selectedType = selectedDateTime!.typeOptions.isNotEmpty
                  ? selectedDateTime!.typeOptions.first
                  : null;
            }

            return BlocBuilder<AppointmentPlaceCubit, AppointmentPlaceState>(
              builder: (context, state) {
                final isInHome = state is InHome;

                return Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
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

                      const Center(
                        child: Text(
                          "حجز موعد",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dropdown اختيار الموعد
                      DropdownButtonFormField<AvailableAppointmentsModel>(
                        value: selectedDateTime,
                        items: availableDateTimes
                            .map(
                              (dt) => DropdownMenuItem(
                                value: dt,
                                child: Text(_formatDate(dt.dateTime)),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() {
                          selectedDateTime = val;
                          selectedType = val?.typeOptions.isNotEmpty == true
                              ? val!.typeOptions.first
                              : null;
                        }),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // اختيار نوع الحجز + Emit InHome / InLab
                      Wrap(
                        spacing: 8,
                        children: (selectedDateTime?.typeOptions ?? []).map((
                          t,
                        ) {
                          final isSelected = selectedType == t;
                          return ChoiceChip(
                            label: Text(
                              t == "IN_LAB" ? "في المختبر" : "في المنزل",
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => selectedType = t);
                              if (t == "IN_LAB") {
                                context.read<AppointmentPlaceCubit>().emit(
                                  InLaboratory(),
                                );
                              } else {
                                context.read<AppointmentPlaceCubit>().emit(
                                  InHome(),
                                );
                              }
                            },
                            selectedColor: Colors.blue.shade50,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.blue : Colors.black87,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      if (isInHome) ...[
                        MapPickerWidget(
                          onLocationSelected: (LatLng point) {
                            setState(() {
                              selectedLocation = point;
                            });
                            print(
                              "تم اختيار الموقع: ${point.latitude}, ${point.longitude}",
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Form الحقول
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            NameFormField(
                              label: "الاسم",
                              controller: _patientName,
                              type: TextInputType.name,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? "الاسم مطلوب"
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            NameFormField(
                              label: "رقم الهاتف",
                              controller: _patientPhone,
                              type: TextInputType.phone,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? "رقم الهاتف مطلوب"
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            NameFormField(
                              label: "الرقم الوطني",
                              controller: _patientIdNumber,
                              type: TextInputType.number,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? "الرقم الوطني مطلوب"
                                  : null,
                            ),
                            const SizedBox(height: 24),

                            // زر الحجز
                            CustomButton(
                              text: "حجز موعد",
                              function: isSubmitting ? null : _submitBooking,
                              isLoading: isSubmitting,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
