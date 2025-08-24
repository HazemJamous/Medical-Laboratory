import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // لو حبيت تستخدمه لاحقًا للتواريخ
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/models/analayses_model/analayses_model.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';

class AnalysisDetailsSheet extends StatefulWidget {
  final AnalayseModel analysis;
  final String labName;

  const AnalysisDetailsSheet({
    Key? key,
    required this.analysis,
    required this.labName,
  }) : super(key: key);

  @override
  State<AnalysisDetailsSheet> createState() => _AnalysisDetailsSheetState();
}

class _AnalysisDetailsSheetState extends State<AnalysisDetailsSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideIn;
  bool _expandPreconditions = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, {String? toast}) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(toast ?? 'تم النسخ')));
  }

  Widget _header() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [AppColors.accentLight, AppColors.accent, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drag handle
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // عنوان التحليل
          Text(
            widget.analysis.labAnalysesName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),

          // سطر المخبر + السعر كبادج
          Row(
            children: [
              const Icon(Icons.business, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.labName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${widget.analysis.price.toStringAsFixed(0)} \$",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          // الشروط المختصرة داخل الهيدر
          if (widget.analysis.preconditions.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              "الشروط المختصرة",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.analysis.preconditions.length > 70
                  ? widget.analysis.preconditions.substring(0, 70) + '...'
                  : widget.analysis.preconditions,
              style: const TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.pageTitle,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 13.5,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _preconditionsCard() {
    final hasPre = widget.analysis.preconditions.trim().isNotEmpty;
    final fullText = hasPre
        ? widget.analysis.preconditions.trim()
        : 'لا توجد شروط خاصة لهذا التحليل.';
    final maxLines = _expandPreconditions ? null : 3;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان + أزرار النسخ/المشاركة
          Row(
            children: [
              const Icon(Icons.rule, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'الشروط والتعليمات',
                style: TextStyle(
                  color: AppColors.pageTitle,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'نسخ',
                onPressed: () =>
                    _copyToClipboard(fullText, toast: 'تم نسخ الشروط'),
                icon: const Icon(
                  Icons.copy,
                  size: 20,
                  color: AppColors.pageTitle,
                ),
              ),
              // IconButton(
              //   tooltip: 'مشاركة',
              //   onPressed: () =>
              //       _copyToClipboard(fullText, toast: 'تم تجهيز النص للمشاركة'),
              //   icon: const Icon(
              //     Icons.share,
              //     size: 20,
              //     color: AppColors.pageTitle,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 6),

          // النص مع عرض المزيد/أقل
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Text(
              fullText,
              maxLines: maxLines,
              overflow: _expandPreconditions
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
          ),

          // زر عرض المزيد/أقل
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: hasPre
                  ? () => setState(
                      () => _expandPreconditions = !_expandPreconditions,
                    )
                  : null,
              child: Text(
                _expandPreconditions ? 'عرض أقل' : 'عرض المزيد',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RTLWrapper(
      child: SlideTransition(
        position: _slideIn,
        child: SizedBox(
          height: size.height * 0.9,
          child: Column(
            children: [
              _header(),
              Expanded(
                child: Container(
                  color: const Color(0xFFF7F8FA),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _infoTile(
                          icon: Icons.medical_information,
                          title: 'اسم التحليل',
                          value: widget.analysis.labAnalysesName,
                        ),
                        const SizedBox(height: 12),
                        _infoTile(
                          icon: Icons.confirmation_number_outlined,
                          title: 'رمز/معرّف التحليل',
                          value: '#${widget.analysis.id}',
                        ),
                        const SizedBox(height: 12),
                        _infoTile(
                          icon: Icons.attach_money,
                          title: 'السعر',
                          value:
                              "${widget.analysis.price.toStringAsFixed(0)} \$",
                        ),
                        const SizedBox(height: 12),
                        _preconditionsCard(),
                        const SizedBox(height: 16),
                        // زر إغلاق
                        CustomButton(
                          text: 'إغلاق',
                          function: () => Navigator.of(context).maybePop(),
                          height: 48,
                          radius: 12,
                          background: AppColors.primary, // إن حبيت تخصص اللون
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
