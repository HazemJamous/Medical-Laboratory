import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class MyDrawerHeader extends StatelessWidget {
  const MyDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent, AppColors.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.biotech_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "MatchLab",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Connecting Patients with Labs",
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
