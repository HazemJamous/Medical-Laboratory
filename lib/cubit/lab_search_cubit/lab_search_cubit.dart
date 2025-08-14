// LabSearchCubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/cubit/lab_search_cubit/lab_search_state.dart';
import 'package:midical_laboratory/models/filter_options.dart';
import 'package:midical_laboratory/models/lap_information_model.dart';
import 'package:midical_laboratory/services/lab_search/lab_search_service.dart';

class LabSearchCubit extends Cubit<LabSearchState> {
  LabSearchCubit() : super(LoadingState());

  var searchController = TextEditingController();
  FilterOptions filterOptions = FilterOptions();
  late List<LabInformationModel> labInfo;

  Future<void> getLabs(String? query, FilterOptions filterOptions) async {
    emit(LoadingState());
    try {
      if ((query == null || query.isEmpty) &&
          filterOptions.isFavorite == false &&
          filterOptions.rating == 0) {
        labInfo = await LabSearchService.getAllLab();
      } else {
        labInfo = await LabSearchService.getLabWithFilter(
          query!,
          filterOptions,
        );
      }
      emit(SuccessState(labInfo: labInfo));
    } catch (e) {
      emit(FailureState(errorMessege: e.toString()));
    }
  }
}
