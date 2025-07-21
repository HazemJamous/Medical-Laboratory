import 'package:flutter/material.dart';
import 'package:midical_laboratory/features/pages/auth/login/login_page.dart';
import 'package:midical_laboratory/features/pages/auth/register/register_page.dart';
import 'package:midical_laboratory/test._file.dart';

void main() {
  runApp(const MidicalLaboratoryApp());
}

class MidicalLaboratoryApp extends StatelessWidget {
  const MidicalLaboratoryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF3498DB),
        scaffoldBackgroundColor: Color(0xFFF8F8F8),
        fontFamily: 'Roboto',
      ),

      home: RegisterPageTest(),
    );
  }
}
//