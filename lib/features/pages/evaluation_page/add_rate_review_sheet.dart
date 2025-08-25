import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:midical_laboratory/cubit/all_evaluation/cubit/all_evaluation_cubit.dart';
import 'package:midical_laboratory/cubit/all_evaluation/cubit/all_evaluation_state.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';

class AddReviewSheet extends StatefulWidget {
  final int labId;
  const AddReviewSheet({required this.labId});

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet>
    with SingleTickerProviderStateMixin {
  final _reviewController = TextEditingController();
  num _rating = 0.0;

  late final AnimationController _controller;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    final cubit = context.read<AllEvaluationCubit>();
    final reviewText = _reviewController.text.trim();

    if (_rating == 0.0 || reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال تقييم وكتابة مراجعة')),
      );
      return;
    }

    cubit.submitReview(_rating, reviewText);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllEvaluationCubit, AllEvaluationState>(
      listener: (context, state) {
        if (state is AddReviewSuccess) {
          Navigator.of(context).pop(); // إغلاق البوتوم شيت
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ تم إرسال التقييم بنجاح')),
          );
        } else if (state is AddReviewFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: SlideTransition(
        position: _slideIn,
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'إضافة تقييم',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              const Text(
                'تقييمك:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                
                minRating: 1,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (val) => setState(() => _rating = val),
              ),
              const SizedBox(height: 16),
              const Text(
                'مراجعتك (تعليق):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _reviewController,
                maxLines: 5,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: 'اكتب تجربتك مع المخبر...',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<AllEvaluationCubit, AllEvaluationState>(
                builder: (context, state) {
                  if (state is AddReviewLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      text: 'إرسال التقييم',
                      function: _submit,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
