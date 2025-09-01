// lib/features/pages/my_bookings/results_of_bookings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // للنسخ للحافظة
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/results_cubit/cubit/results_cubit.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';
import 'package:midical_laboratory/models/my_bookings_model/results_bookings_appointment_model.dart';
import 'package:midical_laboratory/services/my_bookings/result_pdf_convert_service.dart';

// استدعاء خدمة الـ PDF (المسار المعدل)

import 'package:midical_laboratory/shared/widgets/result_card.dart';

// استدعاء الـ ResultCard (المسار المعدل)

class ResultsOfBookingsPage extends StatelessWidget {
  final MyBokingsModel booking;
  const ResultsOfBookingsPage({super.key, required this.booking});

  String _formatDate(DateTime dt) =>
      DateFormat('yyyy/MM/dd • HH:mm', 'en').format(dt);

  String _formatNumber(double? v) {
    if (v == null || v.isNaN) return 'غير متوفر';
    final nf = NumberFormat('#,##0.##', 'en');
    return nf.format(v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نتائج الفحص'),
        backgroundColor: AppColors.accent,
        centerTitle: true,
        actions: [
          BlocBuilder<ResultsCubit, ResultsState>(
            builder: (context, state) {
              if (state is ResultsLoaded) {
                return IconButton(
                  tooltip: 'تحميل كل النتائج PDF',
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () =>
                      _exportAllAsPdf(context, booking, state.results),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _Header(booking: booking),
          ),

          Expanded(
            child: BlocBuilder<ResultsCubit, ResultsState>(
              builder: (context, state) {
                if (state is ResultsLoading || state is ResultsInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ResultsFailure) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is ResultsEmpty) {
                  return const Center(
                    child: Text(
                      "لا توجد نتائج لهذا الموعد بعد",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                } else if (state is ResultsLoaded) {
                  final allItems = state.results;

                  final visible = allItems.where((r) {
                    final double? v = r.result;
                    return v != null && !v.isNaN;
                  }).toList();

                  if (allItems.isEmpty) {
                    return const Center(
                      child: Text(
                        "لا توجد نتائج لهذا الموعد بعد",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  if (visible.isEmpty) {
                    return const Center(
                      child: Text(
                        "لا توجد نتائج ذات قيمة حالياً",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<ResultsCubit>().getResults(
                        booking.appointmentId,
                      );
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final r = visible[index];
                        return ResultCard(
                          item: r,
                          onView: () => _showResultDetail(context, r),
                          onDownloadPdf: () =>
                              _exportAllAsPdf(context, booking, allItems),
                        );
                      },
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAllAsPdf(
    BuildContext context,
    MyBokingsModel booking,
    List<ResultsBookingsAppointmentModel> allItems,
  ) async {
    try {
      await ResultPdfService.saveAndShareResultsPdf(
        context: context,
        booking: booking,
        results: allItems,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تعذر إنشاء PDF: $e')));
    }
  }

  void _showResultDetail(
    BuildContext context,
    ResultsBookingsAppointmentModel item,
  ) {
    final formatted = _formatNumber(item.result);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.48,
        maxChildSize: 0.95,
        minChildSize: 0.32,
        builder: (context, ctrl) => Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: SingleChildScrollView(
            controller: ctrl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  item.analysisName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "القيمة",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.accent.withOpacity(0.18),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                formatted,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        IconButton(
                          tooltip: 'نسخ القيمة',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: formatted));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم نسخ القيمة')),
                            );
                          },
                          icon: Icon(Icons.copy, color: AppColors.accent),
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.share),
                          label: const Text('مشاركة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: '${item.analysisName}: $formatted',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم نسخ التفاصيل للمشاركة'),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.06)),
                  ),
                  child: Text(
                    'ملاحظة: قد تحتاج لمعرفة نطاقات القيم المرجعية (Reference Range) لفهم ما إذا كانت هذه القيمة طبيعية. إذا كانت لديك أي شكوك، تواصل مع المختبر أو طبيبك.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- header widget ----------------
class _Header extends StatelessWidget {
  final MyBokingsModel booking;
  const _Header({required this.booking});

  @override
  Widget build(BuildContext context) {
    final date = booking.dateTime;
    final formatted = DateFormat('yyyy/MM/dd').format(date);
    final time = DateFormat('HH:mm').format(date);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.accent.withOpacity(0.12),
            child: Text(
              _avatarLetters(booking.labName),
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.labName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$formatted  •  $time',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                context.read<ResultsCubit>().getResults(booking.appointmentId),
            icon: const Icon(Icons.refresh, color: AppColors.accent),
            tooltip: 'تحديث',
          ),
        ],
      ),
    );
  }

  String _avatarLetters(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    } else {
      final a = parts[0].isNotEmpty ? parts[0][0] : '';
      final b = parts[1].isNotEmpty ? parts[1][0] : '';
      return (a + b).toUpperCase();
    }
  }
}
