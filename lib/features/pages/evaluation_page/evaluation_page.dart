import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/all_evaluation/cubit/all_evaluation_cubit.dart';

class ReviewsPage extends StatelessWidget {
  final int labId;
  ReviewsPage({required this.labId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllEvaluationCubit(labId)..getAllEvaluationsById(),
      child: BlocBuilder<AllEvaluationCubit, AllEvaluationState>(
        builder: (context, state) {
          final evaluation_cubit = context.read<AllEvaluationCubit>();
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentLight,
                        AppColors.accent,
                        AppColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'آراء المرضى',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
            ),
            body: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: evaluation_cubit.allEvaluationService.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final eval = evaluation_cubit.allEvaluationService[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.accent,
                            child: Text(
                              eval.patientName.toString()[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              eval.patientName.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RatingBarIndicator(
                        rating: eval.rate,
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        itemSize: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        eval.review.toString(),
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
