import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/models/advertisment_model/advertisment_modle.dart';

class AdvertCard extends StatelessWidget {
  const AdvertCard({
    super.key,
    required this.ad,
  });

  final AdvertismentModel ad;

  void _openDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.55,
            minChildSize: 0.35,
            maxChildSize: 0.95,
            builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Avatar مبدئي (يمكنك استبداله بصورة من الشبكة لو متاحة)
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.accentLight,
                        child: Text(
                          ad.lab.labName.isNotEmpty
                              ? ad.lab.labName[0]
                              : '?',
                          style: AppTextStyle.style2.copyWith(
                              fontSize: 20, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ad.lab.labName,
                              style: AppTextStyle.style2.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.pageTitle),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ad.title,
                              style: AppTextStyle.style1.copyWith(
                                  fontSize: 15, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text(
                    ad.descriptions,
                    style: AppTextStyle.style2.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 18),
                  // مثال لأزرار تفاعلية (اتصال، مشاركة، تعليم كمفضل)
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // مثال: تنفيذ مكالمة أو فتح تفاصيل تواصل
                        },
                        icon: const Icon(Icons.call),
                        label: const Text('اتصال'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          // مشاركة الإعلان
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('مشاركة'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // تمييز كمفضل
                        },
                        icon: const Icon(Icons.bookmark_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openDetails(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [
                AppColors.secondary,
                Colors.white,
                AppColors.accentLight,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مربع الأيقونة / الأفاتار
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accent,
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    ad.lab.labName.isNotEmpty ? ad.lab.labName[0] : '?',
                    style: AppTextStyle.style2.copyWith(
                        fontSize: 26, color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المختبر وسطر العنوان
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ad.lab.labName,
                            style: AppTextStyle.style2.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.pageTitle),
                          ),
                        ),
                        // مثال على شِب/وَسْم صغير
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'إعلان',
                            style: AppTextStyle.style2.copyWith(
                                fontSize: 12, color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ad.title,
                      style: AppTextStyle.style1.copyWith(
                          fontSize: 15, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ad.descriptions,
                      style: AppTextStyle.style2.copyWith(
                          fontSize: 13, color: AppColors.textColor),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // أيقونة للانتقال / مفضلة
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      // action (مثلاً علامة مفضلة)
                    },
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
