import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/models/my_bookings_model/my_bookings_model.dart';

class MyBookingsCard extends StatefulWidget {
  final MyBokingsModel booking;

  /// Callbacks
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MyBookingsCard({
    Key? key,
    required this.booking,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  State<MyBookingsCard> createState() => _MyBookingsCardState();
}

class _MyBookingsCardState extends State<MyBookingsCard> {
  bool _pressed = false;

  String get _formattedDate {
    try {
      return DateFormat(
        "yyyy/MM/dd • HH:mm",
        'en',
      ).format(widget.booking.dateTime);
    } catch (_) {
      return "${widget.booking.dateTime.toLocal()}";
    }
  }

  String _relativeTime(DateTime dt) {
    final now = DateTime.now();
    final diff = dt.difference(now);

    if (diff.inSeconds.abs() < 60) return 'الآن';
    if (diff.isNegative) {
      final dd = diff.inDays.abs();
      if (dd >= 1) return 'منذ $dd ${dd == 1 ? "يوم" : "أيام"}';
      final hh = diff.inHours.abs();
      if (hh >= 1) return 'منذ $hh ${hh == 1 ? "ساعة" : "ساعات"}';
      final mm = diff.inMinutes.abs();
      return 'منذ $mm ${mm == 1 ? "دقيقة" : "دقائق"}';
    } else {
      final dd = diff.inDays;
      if (dd >= 1) return 'بعد $dd ${dd == 1 ? "يوم" : "أيام"}';
      final hh = diff.inHours;
      if (hh >= 1) return 'بعد $hh ${hh == 1 ? "ساعة" : "ساعات"}';
      final mm = diff.inMinutes;
      return 'بعد $mm ${mm == 1 ? "دقيقة" : "دقائق"}';
    }
  }

  String _statusLabel(DateTime dt) {
    final now = DateTime.now();
    final dateOnlyNow = DateTime(now.year, now.month, now.day);
    final dateOnlyDt = DateTime(dt.year, dt.month, dt.day);

    if (dateOnlyDt.isAtSameMomentAs(dateOnlyNow)) return 'اليوم';
    if (dateOnlyDt.isBefore(dateOnlyNow)) return 'منتهي';
    return 'قادم';
  }

  Color _statusColor(DateTime dt) {
    final status = _statusLabel(dt);
    switch (status) {
      case 'اليوم':
        return Colors.orange;
      case 'منتهي':
        return Colors.black87;
      default:
        return AppColors.accent;
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد'),
        content: const Text('هل أنت متأكد من إلغاء هذا الموعد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      widget.onDelete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dt = widget.booking.dateTime;
    final relative = _relativeTime(dt);
    final status = _statusLabel(dt);
    final statusColor = _statusColor(dt);
    final bool isUpcoming = status != 'منتهي';

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _pressed ? 0.985 : 1.0,
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap?.call();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.06)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // شريط جانبي
              Container(
                width: 6,
                height: 84,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withOpacity(0.9),
                      statusColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),

              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: statusColor.withOpacity(0.12),
                child: Text(
                  _avatarLetters(widget.booking.labName),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.booking.labName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formattedDate,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          relative,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'ID ${widget.booking.appointmentId}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // أيقونات التحكم (فقط إذا الموعد غير منتهي)
              if (isUpcoming)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: AppColors.accent.withOpacity(0.12),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'تعديل الموعد',
                        onPressed: widget.onEdit,
                        icon: Icon(Icons.edit, color: AppColors.accent),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      color: Colors.red.withOpacity(0.12),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'إلغاء الموعد',
                        onPressed: _confirmDelete,
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _avatarLetters(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].isEmpty ? '?' : parts[0][0].toUpperCase();
    } else {
      final a = parts[0].isNotEmpty ? parts[0][0] : '';
      final b = parts[1].isNotEmpty ? parts[1][0] : '';
      return (a + b).toUpperCase();
    }
  }
}
