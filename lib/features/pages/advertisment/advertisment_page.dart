import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/cubit/advertisment_cubit/advertisment_cubit.dart';
import 'package:midical_laboratory/shared/widgets/advert_card.dart';
import 'package:midical_laboratory/models/advertisment_model/advertisment_modle.dart';

class AdvertismentPage extends StatefulWidget {
  const AdvertismentPage({Key? key}) : super(key: key);

  @override
  State<AdvertismentPage> createState() => _AdvertismentPageState();
}

class _AdvertismentPageState extends State<AdvertismentPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdvertismentCubit()..getAdvertismentCubit(),
      child: BlocBuilder<AdvertismentCubit, AdvertismentState>(
        builder: (context, state) {
          if (state is AdvertismentLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is AdvertismentLoadedState) {
            final List<AdvertismentModel> adverts =
                context.read<AdvertismentCubit>().advertService ?? [];

            final query = _searchController.text.trim().toLowerCase();
            final filtered = query.isEmpty
                ? adverts
                : adverts.where((a) {
                    final combined =
                        '${a.title} ${a.descriptions} ${a.lab.labName}'
                            .toLowerCase();
                    return combined.contains(query);
                  }).toList();

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
                    'الإعلانات',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              ),
              body: SafeArea(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Search field like LabsPage
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'ابحث عن إعلان أو مختبر...',
                              hintStyle: AppTextStyle.style2.copyWith(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              border: InputBorder.none,
                              icon: const Icon(
                                Icons.search,
                                color: AppColors.primary,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Content list
                      Expanded(
                        child: filtered.isEmpty
                            ? ListView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 36,
                                ),
                                children: [
                                  Icon(
                                    Icons.announcement_outlined,
                                    size: 72,
                                    color: AppColors.primary.withOpacity(0.9),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'لا توجد إعلانات مطابقة',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.style2.copyWith(
                                      fontSize: 16,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final ad = filtered[index];
                                  return AdvertCard(ad: ad);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is AdvertismentFailureState) {
            return Scaffold(
              body: Center(
                child: Text(
                  'حدث خطأ: ${state.message}',
                  style: TextStyle(color: Colors.red.shade600),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
