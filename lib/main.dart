import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/lab_search_cubit/lab_search_cubit.dart';

import 'package:midical_laboratory/features/pages/auth/login/login_page.dart';
import 'package:midical_laboratory/features/pages/basic_page.dart';
import 'package:midical_laboratory/features/pages/evaluation_page/evaluation_page.dart';
import 'package:midical_laboratory/features/pages/home/home_page.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LabSearchCubit>(create: (_) => LabSearchCubit()),
        // ممكن تحط Cubits/Blocs تانين
      ],
      child: MidicalLaboratoryApp(),
    ),
  );
}

class MidicalLaboratoryApp extends StatelessWidget {
  const MidicalLaboratoryApp({super.key});
  @override
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFF3498DB),
        scaffoldBackgroundColor: Color(0xFFF8F8F8),
        fontFamily: 'Roboto',
      ),

      home: LoginPage(),
    );
  }
}
