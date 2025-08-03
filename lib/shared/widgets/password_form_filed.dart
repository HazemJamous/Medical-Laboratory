import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool isRtl;
  final double? width;

  const PasswordFormField({
    Key? key,
    required this.controller,
    this.label = 'كلمة المرور',
    this.validator,
    this.isRtl = true,
    this.width,
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
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: 50,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscure,
        validator: widget.validator,

        textDirection: Directionality.of(context),
        decoration: InputDecoration(
          fillColor: AppColors.accentLight,

          prefixIcon: Icon(Icons.password),
          hintStyle: TextStyle(color: Colors.blueGrey[600]),

          hintText: widget.label,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: _toggleVisibility,
          ),
        ),
      ),
    );
  }
}
