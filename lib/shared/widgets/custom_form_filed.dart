import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NameFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final bool? isRTL;
  const NameFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.type,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      textDirection: Directionality.of(context),
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        label: Align(
          alignment:
              isRTL == true ? Alignment.centerLeft : Alignment.centerRight,
          child: Text(label),
        ),
        filled: true,
        fillColor: Colors.green.shade100,
        hintStyle: TextStyle(color: Colors.blueGrey[600]),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      ),
    );
  }
}

class GenderFormField extends StatelessWidget {
  final String? selectedGender;
  final void Function(String?)? onChanged;
  final String label;
  final String? Function(String?)? validator;

  const GenderFormField({
    Key? key,
    required this.selectedGender,
    required this.onChanged,
    this.label = 'الجنس',
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      decoration: InputDecoration(
        fillColor: Colors.green.shade100,
        filled: true,
        labelText: label,
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

  const DateFormField({
    Key? key,
    required this.controller,
    this.label = 'تاريخ',
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.validator,
  }) : super(key: key);

  @override
  State<DateFormField> createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        labelText: widget.label,
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
    );
  }
}

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool isRtl;

  const PasswordFormField({
    Key? key,
    required this.controller,
    this.label = 'كلمة المرور',
    this.validator,
    this.isRtl = true,
  }) : super(key: key);

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscure = true;

  void _toggleVisibility() {
    setState(() => _obscure = !_obscure);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,

      textDirection: Directionality.of(context),
      decoration: InputDecoration(
        fillColor: Colors.green.shade100,

        prefixIcon: Icon(Icons.password),
        hintStyle: TextStyle(color: Colors.blueGrey[600]),

        hintText: widget.label,
        // label: Align(
        //   alignment:
        //       widget.isRtl ? Alignment.centerRight : Alignment.centerLeft,
        //   child: Text(widget.label),
        // ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}
