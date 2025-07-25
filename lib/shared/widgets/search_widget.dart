import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/shared/widgets/filter_widget.dart';

class MySearchWidget extends StatelessWidget {
  final TextEditingController filterController;
  final ValueChanged<String>? onSearchChanged;
  final GestureTapCallback? onFilterTap;

  const MySearchWidget({
    Key? key,
    required this.filterController,
    // required
    this.onSearchChanged,
    this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            alignment: Alignment.center,
            child: TextFormField(
              controller: filterController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Search',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 35,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 3),
        Material(
          shape: CircleBorder(),
          color: AppColors.accentDark,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () => FilterWidget(initialOptions: FilterOptions()),
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
