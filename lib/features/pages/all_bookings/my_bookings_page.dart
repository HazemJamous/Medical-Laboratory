// lib/features/pages/all_bookings/my_bookings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/my_bookings_cubit/cubit/my_bookings_cubit.dart';
import 'package:midical_laboratory/shared/widgets/my_bookings_card.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyBookingsCubit()..getMyBookingsNavBar(),
      child: Scaffold(
        appBar: AppBar(
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
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'مواعيدي القادمة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<MyBookingsCubit, MyBookingsState>(
          builder: (context, state) {
            if (state is MyBookingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyBookingsLoaded) {
              final now = DateTime.now();
              final upcoming = state.bookings
                  .where((b) => b.dateTime.isAfter(now))
                  .toList();

              if (upcoming.isEmpty) {
                return const Center(child: Text("لا يوجد مواعيد قادمة"));
              }

              // lib/features/pages/all_bookings/my_bookings_page.dart

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: upcoming.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = upcoming[index];
                  return MyBookingsCard(
                    booking: booking,
                    onTap: () => _showBookingDetails(context, booking),
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("تأكيد الحذف"),
                          content: const Text(
                            "هل أنت متأكد أنك تريد حذف هذا الموعد؟",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("إلغاء"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.read<MyBookingsCubit>().deleteBooking(
                                  booking.appointmentId,
                                );
                              },
                              child: const Text("حذف"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is MyBookingsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: Text("حدث خطأ غير متوقع"));
            }
          },
        ),
      ),
    );
  }

  /// نافذة تفاصيل الموعد الاحترافية
  void _showBookingDetails(BuildContext context, booking) {
    final date = booking.dateTime;
    final formattedDate = DateFormat('yyyy/MM/dd').format(date);
    final formattedTime = DateFormat('HH:mm').format(date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.38,
        maxChildSize: 0.7,
        minChildSize: 0.25,
        builder: (context, ctrl) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: ctrl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // شريط صغير أعلى البوتوم شيت
                Center(
                  child: Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // العنوان الرئيسي: اسم المختبر
                Text(
                  booking.labName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // بطاقة المعلومات الرئيسية
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.withOpacity(0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(Icons.calendar_today, 'التاريخ', formattedDate),
                      const SizedBox(height: 10),
                      _infoRow(Icons.access_time, 'الوقت', formattedTime),
                      const SizedBox(height: 10),
                      _infoRow(
                        Icons.confirmation_number,
                        'رقم الموعد',
                        booking.appointmentId.toString(),
                      ),
                      const SizedBox(height: 10),
                      _infoRow(Icons.place, 'المخبر', booking.labName),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// صفوف المعلومات داخل البوتوم شيت
  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.accent),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
