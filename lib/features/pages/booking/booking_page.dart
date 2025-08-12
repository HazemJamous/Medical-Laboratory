import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';

class BookingWidget extends StatefulWidget {
  final int labId;

  const BookingWidget({super.key, required this.labId});

  @override
  State<BookingWidget> createState() => _BookingWidgetState();
}

class AvailableDateTime {
  final DateTime dateTime;
  final List<String> typeOptions;

  AvailableDateTime({required this.dateTime, required this.typeOptions});
}

class _BookingWidgetState extends State<BookingWidget> {
  final _formKey = GlobalKey<FormState>();

  String patientName = '';
  String patientPhone = '';
  String patientIdNumber = '';

  late List<AvailableDateTime> availableDateTimes;
  AvailableDateTime? selectedDateTime;
  String? selectedType;

  @override
  void initState() {
    super.initState();

    availableDateTimes = [
      AvailableDateTime(
        dateTime: DateTime.parse("2025-08-12 09:00:00"),
        typeOptions: ["IN_LAB", "IN_HOME"],
      ),
      AvailableDateTime(
        dateTime: DateTime.parse("2025-08-13 11:00:00"),
        typeOptions: ["IN_LAB"],
      ),
    ];

    selectedDateTime = availableDateTimes.first;
    selectedType = selectedDateTime!.typeOptions.first;
  }

  void submitBooking() {
    if (_formKey.currentState!.validate() &&
        selectedDateTime != null &&
        selectedType != null) {
      _formKey.currentState!.save();

      final bookingRequest = {
        "type": selectedType,
        "patient_name": patientName,
        "patient_phone": patientPhone,
        "patient_id_number": patientIdNumber,
        "patient_id": 1,
        "lab_id": widget.labId,
        "date_time": selectedDateTime!.dateTime.toIso8601String(),
      };

      print("Booking Request: $bookingRequest");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إرسال طلب الحجز بنجاح')));
    }
  }

  String formatDateTime(DateTime dt) {
    return DateFormat('yyyy-MM-dd – HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = 16.0;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            'اختر الموعد:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
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
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: InputBorder.none,
              ),
              iconEnabledColor: AppColors.primary,
              items: availableDateTimes
                  .map(
                    (dt) => DropdownMenuItem(
                      value: dt,
                      child: Text(formatDateTime(dt.dateTime)),
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
          const SizedBox(height: 20),

          if (selectedDateTime != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نوع الحجز:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: InputBorder.none,
                    ),
                    iconEnabledColor: AppColors.primary,
                    items: selectedDateTime!.typeOptions
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type == "IN_LAB" ? "في المختبر" : "في المنزل",
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedType = val;
                      });
                    },
                  ),
                ),
              ],
            ),

          const SizedBox(height: 24),

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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'ادخل اسم المريض',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم المريض';
                    }
                    return null;
                  },
                  onSaved: (val) => patientName = val!.trim(),
                ),

                const SizedBox(height: 16),

                Text(
                  'رقم الهاتف:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'ادخل رقم الهاتف',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال رقم الهاتف';
                    }
                    if (!RegExp(r'^\d{9,15}$').hasMatch(value.trim())) {
                      return 'رقم الهاتف غير صحيح';
                    }
                    return null;
                  },
                  onSaved: (val) => patientPhone = val!.trim(),
                ),

                const SizedBox(height: 16),

                Text(
                  'رقم الهوية:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'ادخل رقم الهوية',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال رقم الهوية';
                    }
                    return null;
                  },
                  onSaved: (val) => patientIdNumber = val!.trim(),
                ),

                const SizedBox(height: 30),

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
    );
  }
}

   // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: AppColors.primary,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(borderRadius),
                    //     ),
                    //   ),
                    //   onPressed: submitBooking,
                    //   child: const Text(
                    //     'حجز موعد',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),