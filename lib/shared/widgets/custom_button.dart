// shared/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

Widget CustomButton({
  double radius = 12,
  double width = double.infinity,
  double height = 48,
  Color? background,
  required VoidCallback? function, // nullable ليتعطّل الزر عند اللودينغ
  required String text,
  Color textColor = Colors.white,
  TextStyle? textStyle,
  IconData? icon,
  bool isLoading = false, // ✅ جديد – اختياري
}) {
  final Color effectiveBackground = background ?? AppColors.buttonPrimary;

  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: isLoading ? null : function, // ✅ تعطيل أثناء اللودينغ
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBackground,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 4,
        shadowColor: Colors.green.shade200,
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
    ),
  );
}
