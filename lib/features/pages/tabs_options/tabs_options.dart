import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/features/pages/booking/booking_page.dart';
import 'package:midical_laboratory/features/pages/evaluation_page/evaluation_page.dart';
import 'package:midical_laboratory/features/pages/laboratory/analayses_page.dart';

class CategoryTabsExample extends StatelessWidget {
  final int labId;
  final String labName;

  const CategoryTabsExample({
    super.key,
    required this.labId,
    required this.labName,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
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
            elevation: 0,
            centerTitle: true,
            title: Text(
              ' $labName',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),

            bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: [
                Tab(text: 'آراء المرضى'),
                Tab(text: 'التحاليل'),
                Tab(text: 'الحجـوزات'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ReviewsPage(labId: labId),
            AnalysesGridPage(),
            BookingWidget(labId: labId),
          ],
        ),
      ),
    );
  }
}
