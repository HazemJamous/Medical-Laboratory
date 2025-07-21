import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();
  static const style1 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );
  static const style2 = TextStyle(
    color: AppColors.accent,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );
}
