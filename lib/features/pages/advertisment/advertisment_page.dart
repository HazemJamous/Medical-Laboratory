import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/cubit/advertisment_cubit/advertisment_cubit.dart';
import 'package:midical_laboratory/services/advertisment/advertisment_service.dart';
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
    // عندما يتغير نص البحث نعيد بناء الواجهة لعرض الفلترة
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    // أفترض أن الدالة تعيد Future؛ إن لم تكن تعيد Future فغيّر ذلك في الكيوبت
    await context.read<AdvertismentCubit>().getAdvertismentCubit();
    // إضافة تأخير بسيط ليستحسن رؤية الـ RefreshIndicator (اختياري)
    await Future.delayed(const Duration(milliseconds: 200));
  }

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
            // الحصول على قائمة الإعلانات من الكيوبت كما في كودك الأصلي
            final List<AdvertismentModel> adverts =
                context.read<AdvertismentCubit>().advertService ?? [];

            // فلترة بسيطة بالبحث (العنوان، الوصف، واسم المختبر)
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
                preferredSize: const Size.fromHeight(80),
                child: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  automaticallyImplyLeading: true,
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
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: Column(
                      children: [
                        // Search field
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12,
                          ),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(12),
                            child: TextField(
                              controller: _searchController,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                hintText: 'ابحث عن إعلان أو مختبر...',
                                hintStyle: AppTextStyle.style2.copyWith(
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          _searchController.clear();
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // محتوى القائمة
                        Expanded(
                          child: filtered.isEmpty
                              ? ListView(
                                  // ListView حتى يعمل RefreshIndicator عند الفراغ
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
