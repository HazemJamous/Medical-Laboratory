import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/models/filter_options.dart';

class FilterWidget extends StatefulWidget {
  FilterOptions filterOptions;

  FilterWidget({super.key, required this.filterOptions});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
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
          SwitchListTile(
            title: Text('المخابر المفضلة'),
            value: widget.filterOptions.isFavorite,
            onChanged: (v) {
              widget.filterOptions.isFavorite = v;
              setState(() {});
            },
          ),
          SwitchListTile(
            title: Text('المخابر المشترك فيها'),
            value: widget.filterOptions.isSubscrip == 1 ? true : false,
            onChanged: (v) {
              widget.filterOptions.isSubscrip = v == true ? 1 : 0;
              setState(() {});
            },
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text('التقييم الأدنى: ${opts.minRating.toStringAsFixed(1)}'),
          //       Slider(
          //         min: 0,
          //         max: 5,
          //         divisions: 10,
          //         value: opts.minRating,
          //         onChanged: (v) => opts.minRating = v,
          //       ),
          //     ],
          //   ),
          // ),

          // أزرار المسح والتطبيق
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      widget.filterOptions.reset();
                      setState(() {});
                    },
                    child: Text('مسح الفلترة'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(widget.filterOptions);
                    },
                    child: Text('حفظ الفلترة'),
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
