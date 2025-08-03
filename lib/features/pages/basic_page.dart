import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/features/pages/advertisment/advertisment_page.dart';
import 'package:midical_laboratory/features/pages/appointment/my_appointments_page.dart';
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
    MyAppointmentsPage(),
    AdvertismentPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "المخابر",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: "تحاليلي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "مواعيدي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "الاعلانات",
          ),
        ],
      ),
    );
  }
}
