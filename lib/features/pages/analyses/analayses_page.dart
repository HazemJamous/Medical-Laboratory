// analyses_grid_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/analyses_cubit/analyses_cubit.dart';
import 'package:midical_laboratory/features/pages/booking/booking_page.dart';
import 'package:midical_laboratory/shared/widgets/analyses/analyse_card.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';

class AnalysesGridPage extends StatelessWidget {
  final int labId;
  final String labName;

  const AnalysesGridPage({Key? key, required this.labId, required this.labName})
    : super(key: key);

  /// يفتح الـ bottom sheet وينتظر نتيجة الحجز
  Future<void> openBookingSheet(
    BuildContext context,
    int labId, {
    List<int>? selectedIds, // ✅ متوافق مع الـ Cubit
  }) async {
    final bool? result = await BookingBottomSheetWrapper.show(
      context,
      labId,
      selectedIds: selectedIds,
    );

    if (result == true) {
      final cubit = context.read<AnalysesCubit>();
      cubit.toggleSelectionMode(false);
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
            final analyses = context.read<AnalysesCubit>().allAnalysesById;

            if (state is AnalysesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AnalysesLoaded) {
              return _buildGrid(context, analyses);
            } else if (state is AnalysesFailure) {
              return Center(
                child: Text(
                  'حدث خطأ',
                  style: TextStyle(color: Colors.red.shade600),
                ),
              );
            } else if (state is SelectionModeChanged) {
              if (state.isSelectionMode) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("تم التحديد (${state.selectedIds.length})"),
                    backgroundColor: AppColors.accentLight,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context.read<AnalysesCubit>().toggleSelectionMode(
                            false,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: CustomButton(
                            width: 100,
                            height: 38,
                            radius: 10,
                            text: "Submit",
                            function: () async => await openBookingSheet(
                              context,
                              labId,
                              selectedIds: state.selectedIds, // ✅ تمرير الـ IDs
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: _buildGrid(context, analyses),
                );
              } else {
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
