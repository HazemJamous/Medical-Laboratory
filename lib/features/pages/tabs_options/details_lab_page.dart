import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/details_lab_cubit/details_lab_cubit.dart';
import 'package:midical_laboratory/cubit/details_lab_cubit/details_lab_state.dart';
import 'package:midical_laboratory/models/detalisLabModel/detailes_lab_model.dart';

class DetailsLabPage extends StatelessWidget {
  final int labId;
  const DetailsLabPage({super.key, required this.labId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailsLabCubit(labId)..getAllEvaluationsById(),
      child: BlocConsumer<DetailsLabCubit, DetailsLabState>(
        listener: (context, state) {
          if (state is DetailsLabFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<DetailsLabCubit>();

          return Scaffold(
            body: Builder(
              builder: (context) {
                if (state is DetailsLabLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DetailsLabLoaded) {
                  final DetalisLabModel? model = cubit.labModel;
                  if (model == null) {
                    return const Center(
                      child: Text('لم يتم العثور على بيانات المختبر'),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildHeaderCard(model, context),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.phone,
                          title: 'معلومات الاتصال',
                          content: model.contactInfo.isNotEmpty
                              ? model.contactInfo
                              : 'غير متوفرة',
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'العنوان',
                          content: model.location.address.isNotEmpty
                              ? '${model.location.address}\n${model.location.city.cityName}'
                              : 'العنوان غير متوفر',
                        ),
                        // const SizedBox(height: 24),
                        // _buildActionButtons(context),
                        // const SizedBox(height: 24),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text("حدث خطأ غير متوقع"));
                }
              },
            ),
          );
        },
      ),
    );
  }

  /// -----------------------
  /// بطاقة الهيدر: صورة + اسم + تقييم + اشتراك + مفضلة
  /// -----------------------
  Widget _buildHeaderCard(DetalisLabModel model, BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: model.imagePath.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: ApiLink.fileUrl(model.imagePath),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => _errorImage(),
                  )
                : _errorImage(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الاسم + التقييم
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.labName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: model.rate,
                            itemBuilder: (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                            itemSize: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            model.rate.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // الاشتراك + المفضلة
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: model.subscriptionsStatus == 1
                            ? Colors.green.withOpacity(0.08)
                            : Colors.grey.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        model.subscriptionsStatus == 1 ? 'مشترك' : 'غير مشترك',
                        style: TextStyle(
                          color: model.subscriptionsStatus == 1
                              ? Colors.green[700]
                              : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'ميزة الإضافة للمفضلة غير مفعلّة بعد',
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        model.isfavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: model.isfavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// -----------------------
  /// بطاقة معلومات (أيقونة + عنوان + محتوى)
  /// -----------------------
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(content, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// -----------------------
  /// الأزرار السفلية (تقييمات + اتصال/حجز)
  // /// -----------------------
  // Widget _buildActionButtons(BuildContext context) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: ElevatedButton.icon(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: AppColors.accent,
  //             padding: const EdgeInsets.symmetric(vertical: 14),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //           ),
  //           onPressed: () {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text('انتقل إلى صفحة المراجعات (ضع التنقل هنا)'),
  //               ),
  //             );
  //           },
  //           icon: const Icon(
  //             Icons.rate_review,
  //             color: AppColors.buttonPrimaryText,
  //           ),
  //           label: const Text(
  //             'عرض التقييمات',
  //             style: TextStyle(
  //               color: AppColors.buttonPrimaryText,
  //               fontSize: 15,
  //             ),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: OutlinedButton.icon(
  //           style: OutlinedButton.styleFrom(
  //             padding: const EdgeInsets.symmetric(vertical: 14),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             side: BorderSide(color: Colors.grey.shade300),
  //           ),
  //           onPressed: () {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text('زر للحجز/التواصل — ضع المنطق هنا'),
  //               ),
  //             );
  //           },
  //           icon: const Icon(Icons.phone_in_talk),
  //           label: const Text('اتصال/حجز'),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  /// -----------------------
  /// صورة خطأ
  /// -----------------------
  Widget _errorImage() {
    return Container(
      height: 180,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image, size: 48),
    );
  }

  /// -----------------------
  /// ديكور البطاقات
  /// -----------------------
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
      ],
    );
  }
}
