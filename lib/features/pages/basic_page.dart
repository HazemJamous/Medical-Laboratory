import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/features/pages/advertisment/advertisment_page.dart';
import 'package:midical_laboratory/features/pages/all_bookings/my_bookings_page.dart';
import 'package:midical_laboratory/features/pages/home/home_page.dart';
import 'package:midical_laboratory/features/pages/laboratory/laboratorys_page.dart';
import 'package:midical_laboratory/features/pages/tests/my_tests_page.dart';

class BasicPage extends StatefulWidget {
  const BasicPage({super.key});

  @override
  State<BasicPage> createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  int currentIndex = 0;

  final List<Widget> screens = [
    HomePage(),
    LabsPage(),
    MyTestsPage(),
    MyBookingsPage(),
    AdvertismentPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey.shade500,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 28),
              label: "الرئيسية",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on, size: 28),
              label: "المخابر",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bloodtype, size: 28),
              label: "تحاليلي",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, size: 28),
              label: "مواعيدي",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long, size: 28),
              label: "الإعلانات",
            ),
          ],
        ),
      ),
    );
  }
}
