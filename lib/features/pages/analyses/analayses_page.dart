// analyses_grid_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/analyses_cubit/cubit/analyses_cubit.dart';
import 'package:midical_laboratory/features/pages/booking/booking_page.dart';
import 'package:midical_laboratory/shared/widgets/analyses/analyse_card.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';

class AnalysesGridPage extends StatelessWidget {
  final int labId;
  final String labName;

  const AnalysesGridPage({Key? key, required this.labId, required this.labName})
    : super(key: key);

  /// يفتح الـ bottom sheet وينتظر نتيجة الحجز (true لو نجح)
  Future<void> openBookingSheet(BuildContext context, int labId) async {
    // BookingBottomSheetWrapper.show الآن يرجع Future<bool?> (انظر التعديل المرفق في booking_page.dart)
    final bool? result = await BookingBottomSheetWrapper.show(context, labId);

    // لو الحجز تم بنجاح -> نخرج من وضع التحديد ونعيد تحميل التحاليل
    if (result == true) {
      final cubit = context.read<AnalysesCubit>();

      // اخرج من وضع الاختيار
      cubit.toggleSelectionMode(false);

      // أعد تحميل التحاليل (لضمان تحديث UI وإلغاء الاختيارات)
      // إذا كانت الميثود getAllAnalysesById تعيد Future فمن الممكن انتظارها، لكن عادة emit داخلها يكفي.
      cubit.getAllAnalysesById(labId);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم الحجز بنجاح')));
      }
    }
  }

  Widget _buildGrid(BuildContext context, List analyses) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: analyses.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) => AnalysisCard(
          labName: labName,
          labId: labId,
          analysis: analyses[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RTLWrapper(
      child: BlocProvider(
        create: (_) => AnalysesCubit()..getAllAnalysesById(labId),
        child: BlocBuilder<AnalysesCubit, AnalysesState>(
          builder: (context, state) {
            // استخدم watch أو read حسب حاجتك؛ هنا نستخدم read لأن الـ BlocBuilder يعيد بناء الواجهة
            final analyses = context.read<AnalysesCubit>().allAnalysesById;

            if (state is AnalysesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnalysesLoaded) {
              // الحالة الافتراضية: شبكة التحاليل (بدون AppBar)
              return _buildGrid(context, analyses);
            } else if (state is AnalysesFailure) {
              return Center(
                child: Text(
                  'حدث خطأ',
                  style: TextStyle(color: Colors.red.shade600),
                ),
              );
            } else if (state is SelectionModeChanged) {
              // حالة Selection Mode: لو isSelectionMode true عرض AppBar خاص بالتحديد
              if (state.isSelectionMode) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("تم التحديد (${state.selectedIds.length})"),
                    backgroundColor: AppColors.accentLight,
                    actions: [
                      // زر X -> يخرج من وضع التحديد (ولا يعيد AppBar العام)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context.read<AnalysesCubit>().toggleSelectionMode(
                            false,
                          );
                        },
                      ),

                      // زر Submit -> يفتح bottom sheet وينتظر النتيجة
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: CustomButton(
                            width: 100,
                            height: 38,
                            radius: 10,
                            text: "Submit",
                            function: () async =>
                                await openBookingSheet(context, labId),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: _buildGrid(context, analyses),
                );
              } else {
                // لو SelectionModeChanged لكنها false -> نعرض الواجهة الافتراضية (بدون AppBar)
                return _buildGrid(context, analyses);
              }
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
