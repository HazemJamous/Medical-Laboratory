import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/analyses_cubit/cubit/analyses_cubit.dart';
import 'package:midical_laboratory/shared/widgets/analyses/analyse_card.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';

class AvailableDateTime {
  final DateTime dateTime;
  final List<String> typeOptions;
  AvailableDateTime({required this.dateTime, required this.typeOptions});
}

class AnalysesGridPage extends StatelessWidget {
  final int labId;
  final String labName;
  AnalysesGridPage({Key? key, required this.labId, required this.labName});

  @override
  Widget build(BuildContext context) {
    return RTLWrapper(
      child: BlocProvider(
        create: (context) => AnalysesCubit()..getAllAnalysesById(labId),
        child: BlocBuilder<AnalysesCubit, AnalysesState>(
          builder: (context, state) {
            if (state is AnalysesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AnalysesLoaded) {
              final analayses = context.read<AnalysesCubit>().allAnalysesById;

              return Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: analayses.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) => AnalysisCard(
                    labName: labName,
                    labId: labId,
                    analysis: analayses[index],
                  ),
                ),
              );
            } else if (state is AnalysesFailure) {
              return Center(
                child: Text(
                  'حدث خطأ',
                  style: TextStyle(color: Colors.red.shade600),
                ),
              );
            } else if (state is SelectionModeChanged) {
              final analayses = context.read<AnalysesCubit>().allAnalysesById;
              return Scaffold(
                appBar: AppBar(
                  title: state.isSelectionMode
                      ? Text("تم التحديد (${state.selectedIds.length})")
                      : Text("تحاليل $labName"),
                  actions: [
                    if (state.isSelectionMode)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            AnalysesCubit().toggleSelectionMode(false),
                      ),
                  ],
                ),
                backgroundColor: AppColors.buttonPrimaryText,
                body: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    itemCount: analayses.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) => AnalysisCard(
                      labName: labName,
                      labId: labId,
                      analysis: analayses[index],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
