// lib/features/pages/all_bookings/my_bookings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/my_bookings_cubit/cubit/my_bookings_cubit.dart';
import 'package:midical_laboratory/features/pages/analyses/analayses_page.dart';
import 'package:midical_laboratory/features/pages/basic_page.dart';
import 'package:midical_laboratory/shared/widgets/map_widget/map_show_widget.dart';
import 'package:midical_laboratory/shared/widgets/my_bookings_card.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';

// تأكد أن المسار صحيح لهذا الملف في مشروعك

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

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: upcoming.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = upcoming[index];
                  return MyBookingsCard(
                    booking: booking,
                    onTap: () => _showBookingDetails(context, booking),
                    onEdit: () => _onEditBooking(context, booking),
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

  /// --- دوال مساعدة لاستخراج labId وlabName بطريقة مرنة من كائن الحجز ---
  int? _extractLabId(dynamic booking) {
    try {
      if (booking == null) return null;

      // 1) حقل مباشر باسم labId
      try {
        final v = (booking as dynamic).labId;
        if (v is int) return v;
        if (v is String) {
          final p = int.tryParse(v);
          if (p != null) return p;
        }
      } catch (_) {}

      // 2) حقل باسم lab_id
      try {
        final v = (booking as dynamic).lab_id;
        if (v is int) return v;
        if (v is String) {
          final p = int.tryParse(v);
          if (p != null) return p;
        }
      } catch (_) {}

      // 3) داخل كائن lab: booking.lab.id أو booking.lab['id']
      try {
        final lab = (booking as dynamic).lab;
        if (lab != null) {
          if (lab is Map) {
            final idVal = lab['id'] ?? lab['lab_id'] ?? lab['ID'];
            if (idVal is int) return idVal;
            if (idVal is String) {
              final p = int.tryParse(idVal);
              if (p != null) return p;
            }
          } else {
            final idVal = lab.id;
            if (idVal is int) return idVal;
            if (idVal is String) {
              final p = int.tryParse(idVal);
              if (p != null) return p;
            }
          }
        }
      } catch (_) {}

      // 4) إذا كان booking نفسه Map: booking['lab_id'] أو booking['lab']['id']
      try {
        if (booking is Map) {
          final v =
              booking['lab_id'] ??
              booking['labId'] ??
              booking['lab'] ??
              booking['lab_id'];
          if (v is int) return v;
          if (v is String) {
            final p = int.tryParse(v);
            if (p != null) return p;
          }
          if (v is Map) {
            final idVal = v['id'] ?? v['ID'];
            if (idVal is int) return idVal;
            if (idVal is String) {
              final p = int.tryParse(idVal);
              if (p != null) return p;
            }
          }
        }
      } catch (_) {}

      return null;
    } catch (_) {
      return null;
    }
  }

  String _extractLabName(dynamic booking) {
    try {
      if (booking == null) return '';
      try {
        final n = (booking as dynamic).labName;
        if (n != null) return n.toString();
      } catch (_) {}
      try {
        final n = (booking as dynamic).lab_name;
        if (n != null) return n.toString();
      } catch (_) {}
      try {
        final lab = (booking as dynamic).lab;
        if (lab != null) {
          if (lab is Map) {
            final n = lab['name'] ?? lab['lab_name'] ?? lab['title'];
            if (n != null) return n.toString();
          } else {
            final n = lab.name ?? lab.title;
            if (n != null) return n.toString();
          }
        }
      } catch (_) {}
      if (booking is Map) {
        final n = booking['labName'] ?? booking['lab_name'] ?? booking['lab'];
        if (n != null) return n.toString();
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  /// عند الضغط على تعديل: محاولة استخراج labId ثم الانتقال لصفحة التحاليل.
  Future<void> _onEditBooking(
    BuildContext context,
    MyBokingsModel booking,
  ) async {
    final int? labId = _extractLabId(booking);
    final String labName = _extractLabName(booking);

    if (labId == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'غير قادر على الحصول على معرف المختبر (labId) للحجز.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // push AnalysesGridPage and wait for a result (true = edited successfully)
    final bool? result = await Navigator.of(context).push<bool?>(
      MaterialPageRoute(
        builder: (_) => AnalysesGridPage(
          labId: labId,
          labName: labName.isNotEmpty ? labName : (booking.labName ?? ''),
          existingBooking: booking,
        ),
      ),
    );

    if (!context.mounted) return;

    if (result == true) {
      // ✅ ضمان أن الـ navigation stack مستقر قبل pushAndRemoveUntil
      await Future.delayed(const Duration(milliseconds: 50));

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const BasicPage(
            initialIndex: 3,
            showSnackMessage: 'تم تعديل الموعد بنجاح',
          ),
        ),
        (route) => false,
      );
    }
  }

  void _showBookingDetails(BuildContext context, booking) {
    final DateTime date = booking.dateTime;
    final formattedDate = DateFormat('yyyy/MM/dd').format(date);
    final formattedTime = DateFormat('HH:mm').format(date);
    final tests = (booking.tests as List<dynamic>?) ?? [];

    String initials(String? name) {
      final n = (name ?? '').trim();
      if (n.isEmpty) return '';
      final parts = n.split(' ');
      if (parts.length == 1) return parts[0][0].toUpperCase();
      final a = parts[0][0];
      final b = parts.length > 1 ? parts[1][0] : '';
      return (a + b).toUpperCase();
    }

    String testName(dynamic t) {
      try {
        if (t == null) return '';
        if (t is Map) {
          return (t['name'] ?? t['test_name'] ?? t['title'] ?? t.toString())
              .toString();
        }
        final nameProp = (t as dynamic).name;
        if (nameProp != null) return nameProp.toString();
      } catch (_) {}
      return t.toString();
    }

    Color bookingTypeColor(String? type) {
      final t = (type ?? '').toLowerCase();
      if (t.contains('home')) return Colors.teal;
      if (t.contains('online')) return Colors.indigo;
      if (t.contains('lab')) return AppColors.accent;
      return AppColors.primary;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.38,
        maxChildSize: 0.85,
        minChildSize: 0.25,
        expand: false,
        builder: (context, ctrl) {
          final width = MediaQuery.of(context).size.width;
          final scale = (width / 390).clamp(0.85, 1.15);

          final showMap =
              booking.latitude != null &&
              booking.longitude != null &&
              booking.latitude != 0.0 &&
              booking.longitude != 0.0;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16 * scale,
              vertical: 14 * scale,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: ctrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 56 * scale,
                      height: 6 * scale,
                      margin: EdgeInsets.only(bottom: 12 * scale),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  if (showMap)
                    SizedBox(
                      height: 250,
                      child: MapShowWidget(
                        latitude: booking.latitude,
                        longitude: booking.longitude,
                      ),
                    ),
                  if (!showMap)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12 * scale),
                        child: Text(
                          "لا توجد إحداثيات متاحة",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  SizedBox(height: 12 * scale),
                  Text(
                    booking.labName ?? '-',
                    style: TextStyle(
                      fontSize: 20 * scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10 * scale),
                  _bookingInfoCard(
                    booking,
                    formattedDate,
                    formattedTime,
                    scale,
                    bookingTypeColor,
                  ),
                  SizedBox(height: 14 * scale),
                  _patientCard(booking, scale, initials),
                  SizedBox(height: 14 * scale),
                  RTLWrapper(
                    child: Text(
                      'الفحوصات (${tests.length})',
                      style: TextStyle(
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 8 * scale),
                  if (tests.isEmpty)
                    RTLWrapper(
                      child: Text(
                        'لا توجد فحوصات مسجلة.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14 * scale,
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8 * scale,
                      runSpacing: 8 * scale,
                      children: tests.map<Widget>((t) {
                        final tName = testName(t);
                        return RTLWrapper(
                          child: Chip(
                            elevation: 2,
                            backgroundColor: AppColors.accent.withOpacity(0.12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            label: Text(
                              tName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13 * scale,
                                color: Colors.black87,
                              ),
                            ),
                            avatar: Icon(
                              Icons.science_rounded,
                              size: 18 * scale,
                              color: AppColors.accent,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 18 * scale),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: EdgeInsets.symmetric(vertical: 14 * scale),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * scale,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'إغلاق',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14 * scale),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: AppColors.accent),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'نسخ التفاصيل',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14 * scale,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * scale),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bookingInfoCard(
    booking,
    String formattedDate,
    String formattedTime,
    double scale,
    Color Function(String?) typeColor,
  ) {
    return Container(
      padding: EdgeInsets.all(14 * scale),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.06)),
      ),
      child: RTLWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _infoRow(
                    Icons.calendar_today,
                    'التاريخ',
                    formattedDate,
                    scale,
                  ),
                ),
                SizedBox(width: 8 * scale),
                Expanded(
                  child: _infoRow(
                    Icons.access_time,
                    'الوقت',
                    formattedTime,
                    scale,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8 * scale),
            Row(
              children: [
                Expanded(
                  child: _infoRow(
                    Icons.confirmation_number,
                    'رقم الموعد',
                    booking.appointmentId.toString(),
                    scale,
                  ),
                ),
                SizedBox(width: 8 * scale),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * scale,
                      vertical: 8 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag,
                          size: 18 * scale,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: 8 * scale),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'نوع الحجز',
                                style: TextStyle(
                                  fontSize: 12 * scale,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4 * scale),
                              Text(
                                booking.bookingType ?? '-',
                                style: TextStyle(
                                  fontSize: 14 * scale,
                                  fontWeight: FontWeight.w700,
                                  color: typeColor(booking.bookingType),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8 * scale),
            // اسم المخبر خليه طبيعي
            _infoRow(Icons.place, 'المخبر', booking.labName ?? '-', scale),
          ],
        ),
      ),
    );
  }

  Widget _patientCard(
    booking,
    double scale,
    String Function(String?) initials,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 12 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28 * scale,
            backgroundColor: AppColors.accent,
            child: Text(
              initials(booking.patientName),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.patientName ?? '-',
                  style: TextStyle(
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6 * scale),
                Row(
                  children: [
                    Icon(Icons.perm_identity, size: 14 * scale),
                    SizedBox(width: 6 * scale),
                    Expanded(
                      child: Text(
                        booking.patientIdNumber ?? '-',
                        style: TextStyle(
                          fontSize: 14 * scale,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, double scale) {
    return Row(
      children: [
        Icon(icon, size: 20 * scale, color: AppColors.accent),
        SizedBox(width: 12 * scale),
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14 * scale),
        ),
        SizedBox(width: 8 * scale),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14 * scale,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
