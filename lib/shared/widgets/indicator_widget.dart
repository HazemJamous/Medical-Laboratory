import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class IndicatorWidget extends StatelessWidget {
  final int selectedIndex;
  final int length;
  const IndicatorWidget({
    super.key,
    required this.selectedIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      // children: List.generate(length, (index) {
      //   return Container(
      //     width: 8,
      //     height: 8,
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: selectedIndex == index ? HomeColors.purppel : Colors.grey,
      //     ),
      //   );
      // }),
      children: [
        ...List.generate(length, (index) {
          return Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedIndex == index
                  ? AppColors.buttonSecondaryText
                  : Colors.grey,
            ),
          );
        }),
      ],
    );
  }
}
