import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/models/my_bookings_model/results_bookings_appointment_model.dart';

class ResultCard extends StatelessWidget {
  final ResultsBookingsAppointmentModel item;
  final VoidCallback? onView;

  const ResultCard({super.key, required this.item, this.onView});

  @override
  Widget build(BuildContext context) {
    final double? value = item.result;
    final bool hasValue = item.hasValue;
    final String formatted = hasValue
        ? NumberFormat('#,##0.##', 'en').format(value)
        : 'غير متوفر';
    final String unit = item.displayUnit.isEmpty ? '' : ' ${item.displayUnit}';
    final String refRange = item.range == null
        ? '—'
        : '${NumberFormat('#,##0.##', 'en').format(item.range!.min)} – ${NumberFormat('#,##0.##', 'en').format(item.range!.max)} ${item.range!.unit ?? ''}';

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

    final String statusLabel = _statusText(item.computedStatus);
    final Color statusColor = _statusColor(item.computedStatus);

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
            backgroundColor: AppColors.accent.withOpacity(0.10),
            child: Text(
              item.analysisName.isNotEmpty
                  ? item.analysisName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.analysisName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.pageTitle,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hasValue ? 'قيمة: $formatted$unit' : 'قيمة غير متوفرة',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                if (item.range != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'النطاق: $refRange',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: statusColor.withOpacity(0.35)),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            tooltip: hasValue ? 'عرض' : 'لا توجد نتيجة للعرض',
            icon: Icon(
              Icons.remove_red_eye,
              color: hasValue ? Colors.grey : Colors.grey.shade400,
            ),
            onPressed: hasValue ? onView : null,
          ),
        ],
      ),
    );
  }
}
