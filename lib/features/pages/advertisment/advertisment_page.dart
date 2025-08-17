import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';

import 'package:midical_laboratory/cubit/advertisment_cubit/advertisment_cubit.dart';

import 'package:midical_laboratory/services/advertisment/advertisment_service.dart';
import 'package:midical_laboratory/shared/widgets/advert_card.dart';

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
                  return AdvertCard(ad: ad);
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
