import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/api/api_link.dart';

import 'package:midical_laboratory/models/lap_information_model.dart';
import 'package:midical_laboratory/shared/widgets/home_widgets/lab_card_widget.dart';

class HorizontalLabs extends StatelessWidget {
  final List<LabInformationModel> labDataService;

  const HorizontalLabs({super.key, required this.labDataService});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: labDataService.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, index) {
          final int labId = labDataService[index].id;
          return LabCard(
            title: labDataService[index].labName ?? 'مخبر',
            imageUrl: ApiLink.fileUrl(labDataService[index].imagePath) ?? '',
            cardHeight: 130,
            labId: labId,
          );
        },
      ),
    );
  }
}








  // Image.network(
              //   imageUrl,
              //   height: cardHeight,
              //   fit: BoxFit.contain,
              //   loadingBuilder: (context, child, progress) {
              //     if (progress == null) return child;
              //     return const Center(child: CircularProgressIndicator());
              //   },
              //   errorBuilder: (context, error, stack) =>
              //       const Center(child: Icon(Icons.error)),
              // ),