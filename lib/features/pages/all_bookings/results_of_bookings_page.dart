import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/results_cubit/cubit/results_cubit.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';
import 'package:midical_laboratory/models/my_bookings_model/results_bookings_appointment_model.dart';
import 'package:midical_laboratory/services/my_bookings/result_pdf_convert_service.dart';
import 'package:midical_laboratory/shared/widgets/result_card.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';

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
          'نتائج التحاليل',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  final visible = allItems.where((r) => r.hasValue).toList();

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

                  // ✅ القائمة مع زر PDF أسفل النتائج
                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
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
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final r = visible[index];
                              return ResultCard(
                                item: r,
                                onView: () => _showResultDetail(context, r),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'تحميل النتائج كـ PDF',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () =>
                              _exportAllAsPdf(context, booking, allItems),
                        ),
                      ),
                    ],
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
    final formattedValue = _formatNumber(item.result);
    final unit = (item.displayUnit.isEmpty ? '' : ' ${item.displayUnit}');
    final refRange = item.range == null
        ? '—'
        : '${_formatNumber(item.range!.min)} – ${_formatNumber(item.range!.max)} ${item.range!.unit ?? ''}';

    Color _statusColor(String s) {
      switch (s.toLowerCase()) {
        case 'high':
          return Colors.red.shade600;
        case 'low':
          return Colors.orange.shade700;
        case 'normal':
          return Colors.green.shade700;
        case 'pending':
          return Colors.blue.shade700;
        default:
          return Colors.grey.shade700;
      }
    }

    String _statusText(String s) {
      switch (s.toLowerCase()) {
        case 'high':
          return 'مرتفع';
        case 'low':
          return 'منخفض';
        case 'normal':
          return 'طبيعي';
        case 'pending':
          return 'معلّق';
        default:
          return s;
      }
    }

    Widget _chip(String label, Color color) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.58,
        maxChildSize: 0.95,
        minChildSize: 0.40,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.analysisName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pageTitle,
                        ),
                      ),
                    ),
                    _chip(
                      _statusText(item.computedStatus),
                      _statusColor(item.computedStatus),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // --- عرض اسم المريض و معرف التحليل بشكل واضح تحت العنوان (نفس تنسيق الشيب)
                Row(
                  children: [
                    if (item.patientName.trim().isNotEmpty)
                      _chip(item.patientName, Colors.blueGrey.shade700),
                    const SizedBox(width: 8),
                    _chip('ID: ${item.analysisId}', Colors.grey.shade700),
                    const Spacer(),
                  ],
                ),

                const SizedBox(height: 14),

                // القيمة الأساسية
                RTLWrapper(
                  child: Row(
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
                            child: Text(
                              '$formattedValue$unit',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          // IconButton(
                          //   tooltip: 'نسخ القيمة',
                          //   onPressed: () {
                          //     Clipboard.setData(
                          //       ClipboardData(text: '$formattedValue$unit'),
                          //     );
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(content: Text('تم نسخ القيمة')),
                          //     );
                          //   },
                          //   icon: Icon(Icons.copy, color: AppColors.accent),
                          // ),
                          const SizedBox(height: 6),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.copy, color: Colors.white),
                            label: const Text(
                              'نسخ التفاصيل',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text:
                                      '${item.analysisName}: $formattedValue$unit • النطاق: $refRange',
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم نسخ التفاصيل للمشاركة'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // --- معلومات عامة/إضافية (تُعرض بنفس تنسيق _infoGrid)
                // _sectionTitle('معلومات إضافية'),
                RTLWrapper(
                  child: _infoGrid([
                    _InfoRow('اسم المريض', item.patientName),
                    _InfoRow('معرف التحليل', item.analysisId.toString()),
                    _InfoRow('حالة نسبة التحليل', item.status ?? '—'),
                    _InfoRow(
                      'وحدة المصدر',
                      (item.unit == null || item.unit!.isEmpty)
                          ? '—'
                          : item.unit!,
                    ),
                  ]),
                ),

                const SizedBox(height: 10),

                // معلومات مرجعية سريعة
                RTLWrapper(
                  child: _infoGrid([
                    _InfoRow('النطاق المرجعي', refRange),
                    _InfoRow(
                      'الوحدة',
                      item.displayUnit.isEmpty ? '—' : item.displayUnit,
                    ),
                    if ((item.category ?? '').isNotEmpty)
                      _InfoRow('الفئة', item.category!),
                  ]),
                ),

                const SizedBox(height: 10),

                // بيانات المريض المرتبطة بالنتيجة (إن وُجدت)
                // if (item.patientAgeYears != null ||
                //     (item.patientGender ?? '').isNotEmpty)
                //   _sectionTitle('بيانات المريض'),
                // if (item.patientAgeYears != null ||
                //     (item.patientGender ?? '').isNotEmpty)
                //   _infoGrid([
                //     if (item.patientAgeYears != null)
                //       _InfoRow('العمر', '${item.patientAgeYears} سنة'),
                //     if ((item.patientGender ?? '').isNotEmpty)
                //       _InfoRow('الجنس', item.patientGender!),
                //   ]),
                // ملاحظات
                if ((item.notes ?? '').isNotEmpty) const SizedBox(height: 10),
                if ((item.notes ?? '').isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.withOpacity(0.08)),
                    ),
                    child: Text(
                      item.notes!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                      ),
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

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w800,
        color: AppColors.pageTitle,
      ),
    ),
  );

  Widget _infoGrid(List<_InfoRow> rows) {
    final visible = rows
        .where((r) => r.value.trim().isNotEmpty && r.value != '—')
        .toList();
    if (visible.isEmpty) {
      // إن لم توجد معلومات لا نعرض شيئاً
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final isNarrow = c.maxWidth < 360;
          final col = isNarrow ? 1 : 2;
          return Wrap(
            runSpacing: 10,
            spacing: 12,
            children: visible
                .map(
                  (r) => SizedBox(
                    width: (c.maxWidth - (col - 1) * 12) / col,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            r.label,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          r.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.pageTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
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
            tooltip: 'تحديث النتائج',
            icon: const Icon(Icons.refresh, color: AppColors.accent),
            onPressed: () =>
                context.read<ResultsCubit>().getResults(booking.appointmentId),
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
