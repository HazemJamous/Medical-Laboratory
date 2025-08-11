import 'package:flutter/material.dart';
import 'package:midical_laboratory/features/pages/evaluation_page/evaluation_page.dart';

class CategoryTabsExample extends StatelessWidget {
  final int labId;

  const CategoryTabsExample({super.key, required this.labId});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('اسم المخبر'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'آراء المرضى'),
              Tab(text: 'التحاليل'),
              Tab(text: 'الحجـوزات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: ReviewsPage(labId: labId)),
            Center(child: Text('قائمة الأصدقاء')),
            Center(child: Text('قائمة البوتات')),
          ],
        ),
      ),
    );
  }
}
