import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class NameFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final bool isRTL;
  final double? width;
  final GestureTapCallback? onTap;

  const NameFormField({
    Key? key,
    required this.label,
    required this.controller,
    required this.type,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isRTL = false,
    this.width,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 50,

      child: TextFormField(
        controller: controller,
        keyboardType: type,
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
        validator: validator,

        decoration: InputDecoration(
          hintText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.green.shade100,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey.shade600)
              : null,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: Colors.grey.shade600)
              : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class GenderFormField extends StatelessWidget {
  final String? selectedGender;
  final void Function(String?)? onChanged;
  final String label;
  final String? Function(String?)? validator;
  final double? width;

  const GenderFormField({
    Key? key,
    required this.selectedGender,
    required this.onChanged,
    this.label = 'الجنس',
    this.validator,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: 50,
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        decoration: InputDecoration(
          hintText: label,
          fillColor: Colors.green.shade100,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          // suffixIcon: const Icon(Icons.arrow_drop_down),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
          ),
        ),
        items: const [
          DropdownMenuItem(value: 'male', child: Text('ذكر')),
          DropdownMenuItem(value: 'female', child: Text('أنثى')),
          DropdownMenuItem(value: 'no', child: Text('أفضل عدم ذكر ذلك')),
        ],
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

class DateFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDateSelected;
  final String? Function(String?)? validator;
  final double? width;

  const DateFormField({
    Key? key,
    required this.controller,
    this.label = 'تاريخ',
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.validator,
    this.width,
  }) : super(key: key);

  @override
  State<DateFormField> createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: 50,

      child: TextFormField(
        textDirection: Directionality.of(context),
        controller: widget.controller,
        readOnly: true,
        validator: widget.validator,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.green.shade100,

          hintStyle: TextStyle(color: Colors.blueGrey[600]),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
          ),

          hintText: 'اختر ${widget.label}',
          suffixIcon: const Icon(Icons.calendar_today_rounded),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),

        onTap: () async {
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: widget.initialDate ?? DateTime.now(),
            firstDate: widget.firstDate ?? DateTime(1920),
            lastDate: widget.lastDate ?? DateTime.now(),
          );

          if (pickedDate != null) {
            final formatted = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() => widget.controller.text = formatted);
            if (widget.onDateSelected != null) {
              widget.onDateSelected!(pickedDate);
            }
          }
        },
      ),
    );
  }
}
