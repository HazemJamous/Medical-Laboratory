import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/models/advertisment_model/advertisment_modle.dart';

class AdvertismentHomeCard extends StatelessWidget {
  final AdvertismentModel advert;
  final double width;
  final bool rtl;

  const AdvertismentHomeCard({
    Key? key,
    required this.advert,
    this.width = 260,
    this.rtl = true,
  }) : super(key: key);

  String _labInitials(String name) {
    if (name.trim().isEmpty) return "";
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: InkWell(
        onTap: () => _openDetails(context),
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: width,
          child: Card(
            elevation: 10,
            shadowColor: AppColors.primary.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.hardEdge,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Text(
                          _labInitials(advert.lab.labName),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          advert.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.campaign,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// Description
                  Expanded(
                    child: Text(
                      advert.descriptions,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  /// Footer
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              color: Colors.white.withOpacity(0.15),
                              child: Text(
                                advert.lab.labName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => _openDetails(context),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text(
                          'عرض',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // لتمكين الحواف المستديرة الظاهرة
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.65,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (context, controller) {
              // helper محلي لبناء أيقونات الإجراءات (لا يغير اللوجيك)
              Widget actionButton(IconData icon, String label, Color color) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      color: color.withOpacity(0.12),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {}, // ضع هنا أي معالجة عند الحاجة
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(icon, color: color, size: 22),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              }

              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- drag handle
                        Center(
                          child: Container(
                            width: 56,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // --- Header card: gradient + avatar + titles
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor: Colors.white,
                                child: Text(
                                  advert.lab.labName.isNotEmpty
                                      ? advert.lab.labName[0]
                                      : '?',
                                  style: AppTextStyle.style2.copyWith(
                                    fontSize: 22,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      advert.lab.labName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.style2.copyWith(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      advert.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.style1.copyWith(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Tag صغيرة لإضافة تميّز بصري (اختياري)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'إعلان مميز',
                                        style: AppTextStyle.style2.copyWith(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
                        Divider(color: Colors.grey.shade300, thickness: 1),
                        const SizedBox(height: 14),

                        // --- Description (خط واضح ومريح للقراءة)
                        Text(
                          advert.descriptions,
                          style: AppTextStyle.style2.copyWith(
                            fontSize: 15,
                            height: 1.6,
                            color: AppColors.textColor,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // --- Actions row (اتصال - مشاركة - حفظ)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            actionButton(
                              Icons.call,
                              "اتصال",
                              AppColors.primary,
                            ),
                            actionButton(
                              Icons.share,
                              "مشاركة",
                              AppColors.accent,
                            ),
                            actionButton(
                              Icons.bookmark_border,
                              "حفظ",
                              Colors.grey,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // --- Primary CTA (عرض / إغلاق) — زر كامل العرض أنيق
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(

                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.check_circle_outline,
                              color: AppColors.buttonPrimaryText,
                              size: 20,
                            ),
                            label: const Text(
                              'حسناً',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.buttonPrimaryText,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
