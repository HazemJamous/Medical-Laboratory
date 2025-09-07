import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/home/cubit/home_cubit.dart';
import 'package:midical_laboratory/features/pages/auth/login/login_page.dart';
import 'package:midical_laboratory/features/pages/home/drawer/profile_page.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';
import 'package:midical_laboratory/shared/widgets/home_widgets/drawer_container.dart';
import 'package:midical_laboratory/shared/widgets/home_widgets/drawer_header.dart';
import 'package:midical_laboratory/shared/widgets/home_widgets/horizantall_advertisment.dart';
import 'package:midical_laboratory/shared/widgets/home_widgets/horizantall_labs.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';

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
            return const Center(child: CircularProgressIndicator());
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
              drawer: _buildDrawer(context),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildUpcomingAppointmentCard(
                      home_cubit.nearestAppointment!,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "الإعلانات",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    HorizantallAdvertisment(
                      advertismentList: home_cubit.advertDataService,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "المخابر",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    HorizontalLabs(labDataService: home_cubit.labDataService),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          } else {
            return const Text("out of expecting");
          }
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyDrawerHeader(),
            Expanded(
              child: RTLWrapper(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerContainer(
                        title: "الملف الشخصي",
                        icon: Icons.person_pin,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                      ),
                      DrawerContainer(
                        title: "تسجيل الخروج",
                        icon: Icons.logout_outlined,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: RTLWrapper(
                          child: Text(
                            'سياسة الخصوصية',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUpcomingAppointmentCard(MyBokingsModel bokingModel) {
    final DateTime appt = bokingModel.dateTime.toLocal();
    final DateTime now = DateTime.now();
    final bool isUpcoming = appt.isAfter(now);

    // --- Helpers محليين ---
    String _weekdayArabic(DateTime d) {
      const names = {
        1: 'الاثنين',
        2: 'الثلاثاء',
        3: 'الأربعاء',
        4: 'الخميس',
        5: 'الجمعة',
        6: 'السبت',
        7: 'الأحد',
      };
      return names[d.weekday] ?? '';
    }

    String _monthArabic(int m) {
      const months = [
        '',
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];
      return months[m];
    }

    String _formatTime12(DateTime d) {
      final hour = d.hour;
      final minute = d.minute.toString().padLeft(2, '0');
      final isAm = hour < 12;
      final hour12 = (hour % 12 == 0) ? 12 : hour % 12;
      final meridiem = isAm ? 'ص' : 'م';
      return '$hour12:$minute $meridiem';
    }

    String _timeLeftText(DateTime target, DateTime from) {
      final diff = target.difference(from);
      if (diff.inMinutes < 1) return 'بعد قليل';
      if (diff.inHours < 1) {
        final m = diff.inMinutes;
        return 'بعد $m دقيقة${m == 1 ? '' : ''}';
      }
      if (diff.inDays < 1) {
        final h = diff.inHours;
        final m = diff.inMinutes.remainder(60);
        if (m == 0) return 'بعد $h ساعة';
        return 'بعد $h ساعة و $m دقيقة';
      }
      final days = diff.inDays;
      if (days == 1) return 'غداً';
      return 'بعد $days يوم';
    }

    final dayNumber = appt.day;
    final weekday = _weekdayArabic(appt);
    final month = _monthArabic(appt.month);
    final timeStr = _formatTime12(appt);
    final countdown = isUpcoming ? _timeLeftText(appt, now) : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // كتلة التاريخ الملونة (صورة مصغرة للتقويم)
            Container(
              width: 78,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accentLight, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekday,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$dayNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    month,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'موعدك القادم',
                          style: const TextStyle(
                            color: AppColors.pageTitle,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentLight.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: AppColors.accentDark,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'قادم',
                              style: TextStyle(
                                color: AppColors.accentDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$weekday، $dayNumber $month - الساعة $timeStr',
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.science, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bokingModel.labName,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${bokingModel.tests.length} فحص',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      if (isUpcoming) ...[
                        Icon(
                          Icons.timer,
                          size: 16,
                          color: AppColors.accentDark,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          countdown!,
                          style: const TextStyle(
                            color: AppColors.accentDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.visibility,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'تفاصيل',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'لا يوجد موعد قادم حالياً',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
