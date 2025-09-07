import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/features/pages/home/drawer/profile_page.dart';

class DrawerContainer extends StatelessWidget {
  const DrawerContainer({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: onTap,
      ),
    );
  }
}
