import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/lab_search_cubit/lab_search_cubit.dart';
import 'package:midical_laboratory/features/pages/advertisment/advertisment_page.dart';
import 'package:midical_laboratory/features/pages/auth/login/login_page.dart';
import 'package:midical_laboratory/features/pages/auth/register/register_page.dart';
import 'package:midical_laboratory/features/pages/basic_page.dart';
import 'package:midical_laboratory/features/pages/home/home_page.dart';
import 'package:midical_laboratory/features/pages/laboratory/laboratorys_page.dart';
import 'package:midical_laboratory/models/lap_information_model.dart';
import 'package:midical_laboratory/shared/widgets/lab_card_widget.dart';

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
      // Scaffold(
      //   body: LabCardWidget(
      //     cardModel: LabInformationModel(
      //       id: 1,
      //       imagePath:
      //           "https://static.vecteezy.com/system/resources/previews/036/324/708/non_2x/ai-generated-picture-of-a-tiger-walking-in-the-forest-photo.jpg",
      //       isfavorite: true,
      //       labName: "Labrotary Name",
      //       // isSubscrip: 1,
      //       location: Location(
      //         id: 2,
      //         address: 'Al-bahra',
      //         city: City(id: 3, cityName: "cityName"),
      //       ),
      //       subscriptionsStatus: 1,
      //     ),
      //   ),
      // ),
    );
  }
}
//