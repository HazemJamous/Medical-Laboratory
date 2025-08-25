import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/lab_search_cubit/lab_search_cubit.dart';
import 'package:midical_laboratory/cubit/lab_search_cubit/lab_search_state.dart';
import 'package:midical_laboratory/models/filter_options.dart';
import 'package:midical_laboratory/shared/widgets/lab_card_widget.dart';

class LabsPage extends StatefulWidget {
  LabsPage({Key? key}) : super(key: key);

  @override
  State<LabsPage> createState() => _LabsPageState();
}

class _LabsPageState extends State<LabsPage> {
  final searchController = TextEditingController();
  final filterOptions = FilterOptions();

  @override
  void initState() {
    super.initState();
    context.read<LabSearchCubit>().getLabs(null, filterOptions);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'خيارات الفلترة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Divider(height: 20, thickness: 1),
                  SwitchListTile(
                    activeColor: AppColors.accent,
                    title: const Text('المخابر المفضلة'),
                    value: filterOptions.isFavorite,
                    onChanged: (v) {
                      setModalState(() {
                        filterOptions.isFavorite = v;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'التقييم الأدنى:',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: filterOptions.rating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemSize: 28,
                    onRatingUpdate: (rating) {
                      setModalState(() {
                        filterOptions.rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            filterOptions.isFavorite = false;
                            filterOptions.isSubscrip = 0;
                            filterOptions.rating = 0;
                          });
                          Navigator.pop(context);
                          context.read<LabSearchCubit>().getLabs(
                            null,
                            filterOptions,
                          );
                        },
                        child: const Text('مسح الفلترة'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<LabSearchCubit>().getLabs(
                            searchController.text,
                            filterOptions,
                          );
                        },
                        child: const Text(
                          'حفظ الفلترة',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.accent,
                  AppColors.accentLight,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'المخابر',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: AppColors.primary),
                      ),
                      onSubmitted: (_) => context
                          .read<LabSearchCubit>()
                          .getLabs(searchController.text, filterOptions),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: _showFilterSheet,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<LabSearchCubit, LabSearchState>(
              builder: (context, state) {
                if (state is SuccessState) {
                  return ListView.builder(
                    itemCount: state.labInfo.length,
                    itemBuilder: (context, i) {
                      return LabCardWidget(cardModel: state.labInfo[i]);
                    },
                  );
                } else if (state is FailureState) {
                  return const Center(child: Text("Check Internet"));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showFilterOptions(BuildContext context, FilterOptions filterOpt) {}
