import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "الصفحة الرئيسية",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        shadowColor: Colors.grey,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: AppColors.primary, size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "موعدك القادم",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          "الأربعاء، 19 يونيو - الساعة 10:30 ص",
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // زر حجز موعد
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.black,
                  size: 22,
                  weight: 10,
                ),
                label: Text(
                  "حجز موعد جديد",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigate to booking page
                },
              ),
            ),
            SizedBox(height: 24),

            // المخابر المفضلة
            Text(
              "المخابر المفضلة",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildLabCard("مخبر الشفاء", "assets/lab1.png"),
                  _buildLabCard("مخبر المستقبل", "assets/lab2.png"),
                  _buildLabCard("مخبر المستقبل", "assets/lab2.png"),
                  _buildLabCard("مخبر المستقبل", "assets/lab2.png"),
                  _buildLabCard("مخبر المستقبل", "assets/lab2.png"),
                  _buildLabCard("مخبر المستقبل", "assets/lab2.png"),
                ],
              ),
            ),
            SizedBox(height: 24),

            // المخابر الأقرب إليك
            Text(
              "المخابر الأقرب إليك",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildLabCard("مخبر الحياة", "assets/lab3.png"),
                  _buildLabCard("مخبر المدينة", "assets/lab4.png"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "المخابر",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: "التحاليل",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "مواعيدي",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "تحاليلي",
          ),
        ],
      ),
    );
  }

  Widget _buildLabCard(String name, String imagePath) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 80,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
    );
  }
}
