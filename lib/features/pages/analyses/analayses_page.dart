// analyses_grid_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/cubit/analyses_cubit/analyses_cubit.dart';
import 'package:midical_laboratory/features/pages/booking/booking_page.dart';
import 'package:midical_laboratory/shared/widgets/analyses/analyse_card.dart';
import 'package:midical_laboratory/shared/widgets/right_to_left.dart';
import 'package:midical_laboratory/shared/widgets/custom_button.dart';

// IMPORT: خدمة الرصيد
import 'package:midical_laboratory/services/analayse/analyses_service.dart';
import 'package:midical_laboratory/models/booking_appointments/get_balance_model.dart';

class AnalysesGridPage extends StatelessWidget {
  final int labId;
  final String labName;

  const AnalysesGridPage({Key? key, required this.labId, required this.labName})
    : super(key: key);

  /// Helper: safely extract id from an analysis item (works with Map or model)
  int? _idFromAnalysis(dynamic a) {
    try {
      if (a == null) return null;
      if (a is Map) {
        final v = a['id'] ?? a['ID'] ?? a['analysis_id'];
        if (v is int) return v;
        if (v is String) return int.tryParse(v);
      } else {
        final v = (a as dynamic).id;
        if (v is int) return v;
        if (v is String) return int.tryParse(v);
      }
    } catch (_) {}
    return null;
  }

  /// Helper: safely extract name/title from analysis
  String _nameFromAnalysis(dynamic a) {
    try {
      if (a == null) return '—';
      if (a is Map) {
        final v = a['name'] ?? a['title'] ?? a['analysis_name'];
        if (v != null) return v.toString();
      } else {
        final v = (a as dynamic).name ?? (a as dynamic).title;
        if (v != null) return v.toString();
      }
    } catch (_) {}
    return '—';
  }

  /// Helper: safely extract numeric price from analysis (tries multiple keys)
  double _priceFromAnalysis(dynamic a) {
    try {
      if (a == null) return 0.0;
      if (a is Map) {
        final candidates = [
          'price',
          'cost',
          'fee',
          'amount',
          'price_after_discount',
          'price_before',
        ];
        for (final key in candidates) {
          if (a.containsKey(key) && a[key] != null) {
            final v = a[key];
            if (v is num) return v.toDouble();
            if (v is String) {
              final parsed = double.tryParse(v.replaceAll(',', ''));
              if (parsed != null) return parsed;
            }
          }
        }
      } else {
        final dyn = a as dynamic;
        final candidates = ['price', 'cost', 'fee', 'amount'];
        for (final key in candidates) {
          // try toMap() if model provides it
          try {
            final map = dyn.toMap?.call();
            if (map is Map && map.containsKey(key) && map[key] != null) {
              final v = map[key];
              if (v is num) return v.toDouble();
              if (v is String) {
                final parsed = double.tryParse(v.replaceAll(',', ''));
                if (parsed != null) return parsed;
              }
            }
          } catch (_) {}
          // try direct fields: price / cost
          try {
            final v = dyn.price;
            if (v != null) {
              if (v is num) return v.toDouble();
              if (v is String) {
                final parsed = double.tryParse(v.replaceAll(',', ''));
                if (parsed != null) return parsed;
              }
            }
          } catch (_) {}
          try {
            final v = dyn.cost;
            if (v != null) {
              if (v is num) return v.toDouble();
              if (v is String) {
                final parsed = double.tryParse(v.replaceAll(',', ''));
                if (parsed != null) return parsed;
              }
            }
          } catch (_) {}
        }
      }
    } catch (_) {}
    return 0.0;
  }

  /// يعرض Dialog ملخص الأسعار ويطلب التأكيد. يعيد true إذا أكد المستخدم.
  /// الآن: يعرض أيضاً رصيد المستخدم (getMyBalance) داخل نفس الديالوج،
  /// ويتحقق عند الضغط على "متابعة الحجز" ما إذا كان الرصيد يكفي.
  Future<bool> _showConfirmationDialog(
    BuildContext context, {
    required List<dynamic> selectedItems,
    required double total,
  }) async {
    // جلب الرصيد (محاولة آمنة)
    GetBalanceModel? balanceModel;
    try {
      balanceModel = await AnalysesService.getMyBalance();
    } catch (_) {
      balanceModel = null;
    }

    // تنسيق الأرقام: سنعرض العدد ثنائي العلامات العشرية ونلحق رمز العملة إن وُجد
    String currency = balanceModel?.currency ?? '';
    String formatAmount(double v) {
      final nf = NumberFormat('#,##0.00', 'en_US');
      final s = nf.format(v);
      if (currency.trim().isEmpty) return '\$ $s';
      // إذا كان currency نصًا قصيرًا (مثل "USD" أو "د.أ") نلحقه يمين الرقم
      return '$s $currency';
    }

    final double balanceAmount = (balanceModel?.total != null)
        ? balanceModel!.total.toDouble()
        : 0.0;
    final bool balanceUnavailable = balanceModel == null;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 560),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      // header
                      const SizedBox(height: 8),
                      Text(
                        'ملخص التحاليل',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'راجع قائمة التحاليل والأسعار قبل المتابعة',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // قائمة العناصر — Scrollable
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              itemCount: selectedItems.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 12),
                              itemBuilder: (ctx2, idx) {
                                final it = selectedItems[idx];
                                final name = _nameFromAnalysis(it);
                                final price = _priceFromAnalysis(it);

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary.withOpacity(0.95),
                                            AppColors.primary.withOpacity(0.7),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.12),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.biotech_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      formatAmount(price),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 10),

                      // TOTAL row
                      RTLWrapper(
                        child: Row(
                          children: [
                            const Text(
                              'المجموع:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Container()),
                            Text(
                              formatAmount(total),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.pageTitle,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // BALANCE row
                      RTLWrapper(
                        child: Row(
                          children: [
                            const Text(
                              'الرصيد:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Container()),
                            if (balanceUnavailable)
                              Text(
                                'غير متوفر',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              )
                            else
                              Text(
                                formatAmount(balanceAmount),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pageTitle,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),
                      const Text(
                        'في حال كان رصيدك كافياً سيتم خصم المبلغ تلقائياً عند تأكيد الحجز.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 14),

                      // الأزرار: إلغاء و متابعة الحجز
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              icon: const Icon(Icons.close),
                              label: const Text('إلغاء'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey.shade300),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                foregroundColor: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // استعمل context الأصلي لإظهار SnackBar عند الحاجة
                                if (balanceUnavailable) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'تعذّر جلب رصيدك، حاول لاحقاً',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                if (balanceAmount < total) {
                                  // عرض حوار "رصيد غير كافٍ" أبيض ومنسق
                                  await showDialog<void>(
                                    context: ctx,
                                    barrierDismissible: true,
                                    builder: (insCtx) => Dialog(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      insetPadding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 20,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade50,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons
                                                    .account_balance_wallet_outlined,
                                                size: 40,
                                                color: Colors.red.shade700,
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            const Text(
                                              'رصيد غير كافٍ',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'رصيدك الحالي ${formatAmount(balanceAmount)} أقل من مجموع التحاليل ${formatAmount(total)}.\nالرجاء شحن حسابك لإتمام الحجز.',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 18),
                                            Row(
                                              children: [
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        insCtx,
                                                      ).pop();
                                                      // TODO: توجه المستخدم لصفحة الشحن إن وُجدت (مثلاً: Navigator.push(...))
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.red.shade700,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      'الغاء',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );

                                  // أغلق الديالوج الرئيسي وأعد false (لا نتابع الحجز)
                                  Navigator.of(ctx).pop(false);
                                  return;
                                }

                                // الرصيد كافٍ: نخصم محليًا للعرض ونباشر (الخصم الحقيقي يجب أن يتم في السيرفر عند طلب الحجز)
                                final double newBalance = balanceAmount - total;
                                // نعلم المستخدم باختصار أن المبلغ خصم (عرض مرئي سريع)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تم خصم ${formatAmount(total)} من رصيدك. الرصيد المتبقي ${formatAmount(newBalance)}',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // أعد true لمتابعة الحجز (الخطوة التالية في الكود ستفتح bottom sheet لإكمال الحجز)
                                Navigator.of(ctx).pop(true);
                              },
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'متابعة الحجز',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ) ??
        false;
  }

  /// يفتح الـ bottom sheet وينتظر نتيجة الحجز
  Future<void> openBookingSheet(
    BuildContext context,
    int labId, {
    List<int>? selectedIds, // ✅ متوافق مع الـ Cubit
  }) async {
    // fetch analyses from cubit (already in the widget tree)
    final analyses = context.read<AnalysesCubit>().allAnalysesById;

    // If no selected ids provided, open sheet directly (original behavior)
    if (selectedIds == null || selectedIds.isEmpty) {
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم الحجز بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      return;
    }

    // Build selected items by matching IDs (robust to Map/model)
    final selectedItems = <dynamic>[];
    for (final a in analyses) {
      final id = _idFromAnalysis(a);
      if (id != null && selectedIds.contains(id)) {
        selectedItems.add(a);
      }
    }

    // compute total price
    double total = 0.0;
    for (final it in selectedItems) {
      total += _priceFromAnalysis(it);
    }

    // Show confirmation dialog (now includes balance check)
    final confirm = await _showConfirmationDialog(
      context,
      selectedItems: selectedItems,
      total: total,
    );

    if (!confirm) {
      // user canceled or balance insufficient
      return;
    }

    // user confirmed -> open booking sheet as before
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم الحجز بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
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
                              selectedIds: state.selectedIds,
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
