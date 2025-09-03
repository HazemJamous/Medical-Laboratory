// lab_card_home.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/features/pages/tabs_options/tabs_options.dart';
import 'package:midical_laboratory/models/lap_information_model.dart';
import 'package:midical_laboratory/shared/widgets/favorite_widget.dart';

class LabCardHome extends StatefulWidget {
  final LabInformationModel labInfo;
  const LabCardHome({Key? key, required this.labInfo}) : super(key: key);

  @override
  State<LabCardHome> createState() => _LabCardState();
}

class _LabCardState extends State<LabCardHome> {
  bool _pressed = false;

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    // حجم الكارد يمكن تعديله بحسب استخدامك في الـ Grid
    final double base = 140;
    final double cardWidth = base * 1.12;
    final double imageHeight = base * 0.62;

    final String imageUrl = ApiLink.fileUrl(widget.labInfo.imagePath);

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _pressed ? 0.985 : 1.0,
      curve: Curves.easeOutCubic,
      child: SizedBox(
        width: cardWidth,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // الكارد الرئيسي
              Container(
                // height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.10),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    // لا تغيير في اللوجيك: التنقل كما كان
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryTabs(
                          labId: widget.labInfo.id,
                          labName: widget.labInfo.labName,
                        ),
                      ),
                    );
                  },
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  onTapCancel: _onTapCancel,
                  splashColor: AppColors.primary.withOpacity(0.06),
                  highlightColor: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // الصورة بالأعلى
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                        child: SizedBox(
                          height: imageHeight,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: imageUrl.isNotEmpty
                                    ? imageUrl
                                    : "https://via.placeholder.com/300x200.png?text=Lab",
                                fit: BoxFit.fill,
                                placeholder: (ctx, url) => Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (ctx, url, err) => Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image_rounded,
                                      color: Colors.grey,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ),

                              // Gradient لتحسين التباين أسفل الصورة (نستعمله لو وضعنا نص فوق الصورة لاحقاً)
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.12),
                                      ],
                                      stops: const [0.5, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // مسافة بين الصورة والنص
                      const SizedBox(height: 8),

                      // اسم المختبر
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.labInfo.labName,
                          style: AppTextStyle.style2.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.pageTitle,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // الموقع مع أيقونة صغيرة
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${widget.labInfo.location.city.cityName}\n${widget.labInfo.location.address}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // زر المفضلة: مثبت في الركن السفلي الأيمن فوق الحافة (نستخدم الـ FavoriteWidget لديك)
              Positioned(
                bottom: 8,
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  child: FavoriteWidget(
                    isFavorite: widget.labInfo.isfavorite,
                    labId: widget.labInfo.id,
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
