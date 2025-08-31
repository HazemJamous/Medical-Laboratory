// lib/features/pages/my_bookings/results_of_bookings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/results_cubit/cubit/results_cubit.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';
import 'package:midical_laboratory/models/my_bookings_model/results_bookings_appointment_model.dart';
 // اختياري: لفتح روابط إن وُجدت

class ResultsOfBookingsPage extends StatelessWidget {
  final MyBokingsModel booking;
  const ResultsOfBookingsPage({super.key, required this.booking});

  String _formatDate(DateTime dt) =>
      DateFormat('yyyy/MM/dd • HH:mm', 'en').format(dt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نتائج الفحص'),
        backgroundColor: AppColors.accent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // رأس الصفحة — بطاقة مختصر عن الموعد
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _Header(booking: booking),
          ),

          // المحتوى: نتائج (BlocBuilder)
          Expanded(
            child: BlocBuilder<ResultsCubit, ResultsState>(
              builder: (context, state) {
                if (state is ResultsLoading || state is ResultsInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ResultsFailure) {
                  return Center(
                    child: Text(state.message, style: const TextStyle(color: Colors.red)),
                  );
                } else if (state is ResultsEmpty) {
                  return const Center(
                    child: Text("لا توجد نتائج لهذا الموعد بعد", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  );
                } else if (state is ResultsLoaded) {
                  final items = state.results;
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<ResultsCubit>().getResults(booking.appointmentId);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final r = items[index];
                        return _ResultTile(
                          item: r,
                          onTap: () => _showResultDetail(context, r),
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

  void _showResultDetail(BuildContext context, ResultsBookingsAppointmentModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.95,
        minChildSize: 0.3,
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
                Text(item.analysisName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(item.result, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text('مشاركة'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                      onPressed: () {
                        // استخدم package:share_plus لمشاركة النص لو حبيت
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0,6))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.accent.withOpacity(0.12),
            child: Text(
              _avatarLetters(booking.labName),
              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(booking.labName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text('$formatted  •  $time', style: const TextStyle(color: Colors.grey)),
              ]),
            ]),
          ),
          // زر تحميل/تحديث بسيط
          IconButton(
            onPressed: () => context.read<ResultsCubit>().getResults(booking.appointmentId),
            icon: const Icon(Icons.refresh, color: AppColors.accent),
            tooltip: 'تحديث',
          ),
        ],
      ),
    );
  }

  String _avatarLetters(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    final a = parts[0].isNotEmpty ? parts[0][0] : '';
    final b = parts[1].isNotEmpty ? parts[1][0] : '';
    return (a + b).toUpperCase();
  }
}

// ---------------- result tile widget ----------------
class _ResultTile extends StatelessWidget {
  final ResultsBookingsAppointmentModel item;
  final VoidCallback? onTap;
  const _ResultTile({required this.item, this.onTap});

  bool _looksLikeUrl(String s) => s.startsWith('http://') || s.startsWith('https://');

  // Future<void> _openIfUrl(String s) async {
  //   if (_looksLikeUrl(s)) {
  //     final uri = Uri.parse(s);
  //     if (await canLaunchUrl(uri)) await launchUrl(uri);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final resultText = item.result;
    final short = resultText.length > 120 ? resultText.substring(0, 120) + '...' : resultText;

    // لون تبع النتيجة (heuristic): لو فيها كلمات تدل على مشكلة خليها أحمر
    final lower = resultText.toLowerCase();
    Color valueColor = Colors.green;
    if (lower.contains('high') || lower.contains('elevated') || lower.contains('positive') || lower.contains('غير طبيعي') || lower.contains('موجب')) {
      valueColor = Colors.red;
    } else if (lower.contains('low') || lower.contains('negative') || lower.contains('منخفض') || lower.contains('سالب')) {
      valueColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () {
        if (_looksLikeUrl(resultText)) {
          // _openIfUrl(resultText);
        } else {
          onTap?.call();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.06)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0,4))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: valueColor.withOpacity(0.12),
              child: Text(item.analysisName.isNotEmpty ? item.analysisName[0].toUpperCase() : '?', style: TextStyle(color: valueColor, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.analysisName, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(short, style: const TextStyle(color: Colors.grey)),
              ]),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.remove_red_eye, color: Colors.grey),
              onPressed: onTap,
              tooltip: 'عرض',
            ),
          ],
        ),
      ),
    );
  }
}
