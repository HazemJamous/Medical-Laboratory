import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/features/pages/analyses/analayses_page.dart';
import 'package:midical_laboratory/models/analayses_model/analayses_model.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';

class BookingBottomSheet extends StatefulWidget {
  final AnalayseModel analysis;
  const BookingBottomSheet({required this.analysis});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late List<AvailableDateTime> availableDateTimes;
  AvailableDateTime? selectedDateTime;
  String? selectedType;

  String patientName = '';
  String patientPhone = '';
  String patientIdNumber = '';

  late final AnimationController _controller;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();

    availableDateTimes = [
      AvailableDateTime(
        dateTime: DateTime.parse("2025-08-12 09:00:00"),
        typeOptions: const ["IN_LAB", "IN_HOME"],
      ),
      AvailableDateTime(
        dateTime: DateTime.parse("2025-08-13 11:00:00"),
        typeOptions: const ["IN_LAB"],
      ),
    ];
    selectedDateTime = availableDateTimes.first;
    selectedType = selectedDateTime!.typeOptions.first;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) =>
      DateFormat('yyyy-MM-dd – HH:mm').format(dt);

  void _submit() {
    if (_formKey.currentState!.validate() &&
        selectedDateTime != null &&
        selectedType != null) {
      _formKey.currentState!.save();
      final payload = {
        "type": selectedType,
        "patient_name": patientName,
        "patient_phone": patientPhone,
        "patient_id_number": patientIdNumber,
        "patient_id": 1,
        "lab_id":
            widget.analysis.id, 
        "date_time": selectedDateTime!.dateTime.toIso8601String(),
      };

      debugPrint("Booking Request => $payload");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال طلب الحجز بنجاح')));
      Navigator.of(context).maybePop();
    }
  }

  Widget _header() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [AppColors.accentLight, AppColors.accent, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.analysis.labAnalysesName,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.business, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.analysis.labAnalysesName,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${widget.analysis.price.toStringAsFixed(0)} \$",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (widget.analysis.preconditions.isNotEmpty)
            Text(
              "الشروط: ${widget.analysis.preconditions}",
              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final view = MediaQuery.of(context).size;
    return SlideTransition(
      position: _slideIn,
      child: SizedBox(
        height: view.height * 0.92,
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Container(
                color: const Color(0xFFF7F8FA),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'اختر الموعد',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.pageTitle,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                          child: DropdownButtonFormField<AvailableDateTime>(
                            value: selectedDateTime,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: availableDateTimes
                                .map(
                                  (dt) => DropdownMenuItem(
                                    value: dt,
                                    child: Text(_formatDateTime(dt.dateTime)),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedDateTime = val;
                                selectedType = val?.typeOptions.first;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 14),

                        const Text(
                          'نوع الحجز',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.pageTitle,
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Wrap(
                            key: ValueKey(selectedDateTime),
                            spacing: 8,
                            children: (selectedDateTime?.typeOptions ?? [])
                                .map(
                                  (t) => ChoiceChip(
                                    label: Text(
                                      t == "IN_LAB"
                                          ? "في المختبر"
                                          : "في المنزل",
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
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'بيانات المريض',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.pageTitle,
                          ),
                        ),
                        const SizedBox(height: 10),

                        TextFormField(
                          decoration: _fieldDecoration('اسم المريض'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'الرجاء إدخال اسم المريض'
                              : null,
                          onSaved: (v) => patientName = v!.trim(),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: _fieldDecoration('رقم الهاتف'),
                          validator: (v) {
                            final t = v?.trim() ?? '';
                            if (t.isEmpty) return 'الرجاء إدخال رقم الهاتف';
                            if (!RegExp(r'^\d{9,15}$').hasMatch(t)) {
                              return 'رقم الهاتف غير صحيح';
                            }
                            return null;
                          },
                          onSaved: (v) => patientPhone = v!.trim(),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          decoration: _fieldDecoration('رقم الهوية'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'الرجاء إدخال رقم الهوية'
                              : null,
                          onSaved: (v) => patientIdNumber = v!.trim(),
                          textInputAction: TextInputAction.done,
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          height: 50,
                          child: CustomButton(
                            function: _submit,
                            text: "حجز موعد",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
