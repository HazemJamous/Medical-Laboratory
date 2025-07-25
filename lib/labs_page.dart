import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/shared/widgets/custom_form_filed.dart';
import 'package:midical_laboratory/shared/widgets/filter_widget.dart';
import 'package:midical_laboratory/shared/widgets/search_widget.dart';

class LabsPage extends StatelessWidget {
  LabsPage({super.key});
  var co = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: NameFormField(
                      controller: co,
                      label: "Search",
                      type: TextInputType.name,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.tune)),
                ],
              ),

              MySearchWidget(
                filterController: co,
                onFilterTap: () =>
                    FilterWidget(initialOptions: FilterOptions()),
                onSearchChanged: (value) => (),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
