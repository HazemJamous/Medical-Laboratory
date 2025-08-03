import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/cubit/advertisment_cubit/advertisment_cubit.dart';
import 'package:midical_laboratory/services/advertisment/advertisment_service.dart';

class AdvertismentPage extends StatelessWidget {
  const AdvertismentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AdvertismentCubit(AdvertismentService())..getAdvertismentCubit(),
      child: BlocBuilder<AdvertismentCubit, AdvertismentState>(
        builder: (context, state) {
          if (state is AdvertismentLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is AdvertismentLoadedState) {
            final adverts = context.read<AdvertismentCubit>().advertService;
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
              body: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                itemCount: adverts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final ad = adverts[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.secondary,
                          Colors.white,
                          AppColors.accentLight,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: AppColors.accentLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.accent,
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.medical_services_outlined,
                                size: 38,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ad.lab.labName,
                                    style: AppTextStyle.style2?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.pageTitle,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Divider(
                                    color: Colors.grey.shade300,
                                    thickness: 1,
                                    height: 1,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    ad.title,
                                    style: AppTextStyle.style1?.copyWith(
                                      fontSize: 15,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ad.descriptions,
                                    style: AppTextStyle.style2?.copyWith(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
