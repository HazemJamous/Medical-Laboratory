import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/models/filter_options.dart';
import 'package:midical_laboratory/shared/widgets/filter_widget.dart';

class MySearchWidget extends StatelessWidget {
  final TextEditingController filterController;
  final VoidCallback searchTap;
  FilterOptions filterOpt;

  MySearchWidget({
    super.key,
    required this.filterController,
    required this.searchTap,
    required this.filterOpt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          shape: CircleBorder(),
          color: AppColors.buttonSecondaryText,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: searchTap,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 20,
                weight: 20,
              ),
            ),
          ),
        ),
        SizedBox(width: 3),
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            alignment: Alignment.center,
            child: TextFormField(
              controller: filterController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                alignLabelWithHint: true,
                hintText: 'Search',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                // prefixIcon: Icon(
                //   Icons.search,
                //   size: 35,
                //   color: Colors.grey.shade600,
                // ),
              ),
            ),
          ),
        ),
        SizedBox(width: 3),
        Material(
          shape: CircleBorder(),
          color: AppColors.buttonSecondaryText,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () async {
              final result = await showModalBottomSheet<FilterOptions>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                isScrollControlled: true,
                builder: (_) => FilterWidget(filterOptions: filterOpt),
              );
              if (result != null) filterOpt = result;
            },
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.tune, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
