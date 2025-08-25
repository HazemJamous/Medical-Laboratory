import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/all_evaluation/cubit/all_evaluation_cubit.dart';
import 'package:midical_laboratory/cubit/all_evaluation/cubit/all_evaluation_state.dart';
import 'package:midical_laboratory/features/pages/evaluation_page/add_rate_review_sheet.dart';

class ReviewsPage extends StatelessWidget {
  final int labId;
  const ReviewsPage({super.key, required this.labId});

  Future<void> _openAddReviewSheet(
    BuildContext context,
    AllEvaluationCubit cubit,
  ) async {
    // نفتح البوتوم شيت
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddReviewSheet(labId: labId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllEvaluationCubit(labId)..getAllEvaluationsById(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<AllEvaluationCubit>();

          return Scaffold(
            body: BlocConsumer<AllEvaluationCubit, AllEvaluationState>(
              listener: (context, state) {
                if (state is AddReviewSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ تم إرسال التقييم بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // بعد النجاح، نحدث التقييمات بالكامل
                  cubit.getAllEvaluationsById();
                } else if (state is AddReviewFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is AllEvaluationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AllEvaluationLoaded) {
                  final items = cubit.allEvaluationService;
                  if (items.isEmpty) {
                    return const Center(child: Text('لا توجد مراجعات بعد'));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final eval = items[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.accent,
                                  child: Text(
                                    eval.patientName.isNotEmpty
                                        ? eval.patientName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    eval.patientName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            RatingBarIndicator(
                              rating: eval.rate.toDouble(),
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                              itemSize: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              eval.review,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is AllEvaluationFailure) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("حدث خطأ غير متوقع"));
                }
              },
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _openAddReviewSheet(context, cubit),
              icon: const Icon(
                Icons.add_comment,
                color: AppColors.buttonPrimaryText,
              ),
              label: const Text(
                'إضافة تقييم',
                style: TextStyle(
                  color: AppColors.buttonPrimaryText,
                  fontSize: 15,
                ),
              ),
              backgroundColor: AppColors.accent,
            ),
          );
        },
      ),
    );
  }
}
