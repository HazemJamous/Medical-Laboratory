// lib/shared/widgets/results/result_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/models/my_bookings_model/results_bookings_appointment_model.dart';

class ResultCard extends StatelessWidget {
  final ResultsBookingsAppointmentModel item;
  final VoidCallback? onView; // فتح التفاصيل (BottomSheet)
  final VoidCallback? onDownloadPdf; // توليد وتحميل PDF (كل النتائج)

  const ResultCard({
    Key? key,
    required this.item,
    this.onView,
    this.onDownloadPdf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double? value = item.result;
    final bool hasValue = value != null && !value.isNaN;
    final String formatted = hasValue
        ? NumberFormat('#,##0.##', 'en').format(value)
        : 'غير متوفر';

    final Color valueColor = hasValue ? AppColors.accent : Colors.grey;

    return Container(
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: valueColor.withOpacity(0.12),
            child: Text(
              item.analysisName.isNotEmpty
                  ? item.analysisName[0].toUpperCase()
                  : '?',
              style: TextStyle(color: valueColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.analysisName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.pageTitle,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hasValue ? 'قيمة الاختبار' : 'قيمة غير متوفرة',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: valueColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: valueColor.withOpacity(0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatted,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: valueColor,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: hasValue ? 'عرض' : 'لا توجد نتيجة للعرض',
                icon: Icon(
                  Icons.remove_red_eye,
                  color: hasValue ? Colors.grey : Colors.grey.shade400,
                ),
                onPressed: hasValue ? onView : null,
              ),
              IconButton(
                tooltip: 'تحميل PDF (كل نتائج الموعد)',
                icon: const Icon(Icons.picture_as_pdf, color: AppColors.accent),
                onPressed: onDownloadPdf,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
