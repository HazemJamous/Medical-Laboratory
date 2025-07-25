import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';

class FilterOptions {
  bool onlyOpenNow;
  bool hasWeekendService;
  double minRating;

  FilterOptions({
    this.onlyOpenNow = false,
    this.hasWeekendService = false,
    this.minRating = 0.0,
  });
}

class FilterWidget extends StatelessWidget {
  late FilterOptions opts;
  final FilterOptions initialOptions;

  FilterWidget({super.key, required this.initialOptions});

  void _openFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<FilterOptions>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => FilterWidget(initialOptions: opts),
    );

    if (result != null) {
      opts = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // لضبط المساحة بالنسبة للكيبورد
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Wrap(
        
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('خيارات الفلترة', style: AppTextStyle.style2),
          ),
          Divider(),

          // خيار: مفتوح الآن
          SwitchListTile(
            title: Text('مفتوح الآن'),
            value: opts.onlyOpenNow,
            onChanged: (v) => opts.onlyOpenNow = v,
          ),

          // خيار: يعمل في العطلة
          SwitchListTile(
            title: Text('خدمة نهاية الأسبوع'),
            value: opts.hasWeekendService,
            onChanged: (v) => opts.hasWeekendService = v,
          ),

          // خيار: تقييم أدنى
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('التقييم الأدنى: ${opts.minRating.toStringAsFixed(1)}'),
                Slider(
                  min: 0,
                  max: 5,
                  divisions: 10,
                  value: opts.minRating,
                  onChanged: (v) => opts.minRating = v,
                ),
              ],
            ),
          ),

          // أزرار المسح والتطبيق
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // إعادة القيم الافتراضية
                      opts = FilterOptions();
                    },
                    child: Text('مسح الفلترة'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // إرجاع الخيارات للخارج
                      Navigator.of(context).pop(opts);
                    },
                    child: Text('تطبيق'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
