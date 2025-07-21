import 'package:flutter/material.dart';

Widget CustomButton({
  double radius = 12,
  double width = double.infinity,
  double height = 48,
  Color? background,
  required VoidCallback function,
  required String text,
  Color textColor = Colors.white,
  TextStyle? textStyle,
  IconData? icon,
}) {
  final Color effectiveBackground =
      background ?? const Color(0xFF4CAF50); // أخضر متناسق

  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveBackground,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        elevation: 4,
        shadowColor: Colors.green.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style:
                textStyle ??
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
