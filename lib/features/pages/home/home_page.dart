import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/home/cubit/home_cubit.dart';
import 'package:midical_laboratory/shared/widgets/home_widgets/appointment_button.dart';
import 'package:midical_laboratory/shared/widgets/home_widgets/horizantall_labs.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getDataOfHomePage(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final home_cubit = context.read<HomeCubit>();
          if (state is HomeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.accent,
                          AppColors.accentLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  title: const Text(
                    "الصفحة الرئيسية",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildUpcomingAppointmentCard(),
                    const SizedBox(height: 20),
                    NewAppointmentButton(
                      onPressed: () {
                        print("hhhhhhhhhhh");
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "المخابر المفضلة",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    HorizontalLabs(labDataService: home_cubit.labDataService),
                    const SizedBox(height: 30),
                    const Text(
                      "المخابر الأقرب إليك",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // HorizontalLabs(),
                  ],
                ),
              ),
            );
          } else {
            return Text("out of expecting");
          }
        },
      ),
    );
  }

  Widget buildUpcomingAppointmentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: AppColors.primary, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "موعدك القادم",
                  style: TextStyle(
                    color: AppColors.pageTitle,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "الأربعاء، 19 يونيو - الساعة 10:30 ص",
                  style: TextStyle(color: AppColors.textColor, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _horizontalLabList(double cardHeight) {
  //   String imageUrl1 =
  //       'https://imgs.search.brave.com/hLrdVsVDfYeR4Ursp5NosSudQR3uqlWDLxihqS4FZmg/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/cHJlbWl1bS1waG90/by9yZWFsaXN0aWMt/cGhvdG8tYnJpZ2h0/LWxhYnJhdG9yeS13/aXRoLWJsdWUtd2hp/dGUtdG9uZXMtbWlj/cm9zY29wZS1mb3Jl/Z3JvdW5kLW1lZGlj/YWwtZXF1XzM0Mzk2/MC0xMTIwMzYuanBn/P3NpemU9NjI2JmV4/dD1qcGc';
  //   String imageUrl2 =
  //       'https://imgs.search.brave.com/1AepPO3o7vGuPHC0eyTmiF4hJkFr2J5gPRb7asrk630/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZG4u/c290b3IuY29tL3Ro/dW1icy9maXQ2MzB4/MzAwLzM5MTcxLzE2/MTUzMDAzODIvJUQ4/JUIxJUQ5JTg1JUQ5/JTg4JUQ4JUIyXyVE/OCVBNyVEOSU4NCVE/OCVBQSVEOCVBRCVE/OCVBNyVEOSU4NCVE/OSU4QSVEOSU4NF8l/RDglQTclRDklODQl/RDglQjclRDglQTgl/RDklOEElRDglQTlf/JUQ5JTg4JUQ5JTg1/JUQ4JUI5JUQ4JUFG/JUQ5JTg0JUQ4JUE3/JUQ4JUFBJUQ5JTg3/JUQ4JUE3XyVEOCVB/NyVEOSU4NCVEOCVC/NyVEOCVBOCVEOSU4/QSVEOCVCOSVEOSU4/QSVEOCVBOS5qcGc';
  //   String imageUrl3 =
  //       'https://images.pexels.com/photos/256381/pexels-photo-256381.jpeg';
  //   final List<String> images = [
  //     imageUrl2,
  //     imageUrl1,

  //     imageUrl2,
  //     imageUrl3,
  //     imageUrl1,
  //   ];
  //   return SizedBox(
  //     height: cardHeight + 40,
  //     child: ListView.separated(
  //       scrollDirection: Axis.horizontal,
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       itemCount: images.length,
  //       separatorBuilder: (_, __) => const SizedBox(width: 16),
  //       itemBuilder: (_, index) {
  //         return _buildSingleLabCard(
  //           "مخبر ${index + 1}",
  //           images[index],
  //           cardHeight,
  //         );
  //       },
  //     ),
  //   );
  // }
}
