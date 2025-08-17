import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/features/pages/booking/booking_page.dart';
import 'package:midical_laboratory/features/pages/evaluation_page/evaluation_page.dart';
import 'package:midical_laboratory/features/pages/analyses/analayses_page.dart';

class CategoryTabs extends StatelessWidget {
  final int labId;
  final String? labName;

  const CategoryTabs({super.key, required this.labId, this.labName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
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
              "$labName",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 22,
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
            AnalysesGridPage(labId: labId, labName: labName!),
            BookingWidget(labId: labId),
          ],
        ),
      ),
    );
  }

  dynamic getLabName() {
    return this.labName;
  }
}
