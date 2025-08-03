import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();
  static const style1 = TextStyle(
    color: AppColors.buttonPrimary,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );
  static const style2 = TextStyle(
    color: AppColors.heading,
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );
}
