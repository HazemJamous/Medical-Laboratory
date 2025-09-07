import 'package:flutter/material.dart';
import 'package:midical_laboratory/models/advertisment_model/advertisment_modle.dart';
import 'package:midical_laboratory/shared/widgets/home_widgets/advertisment_home_card.dart';

class HorizantallAdvertisment extends StatelessWidget {
  final List<AdvertismentModel> advertismentList;

  const HorizantallAdvertisment({super.key, required this.advertismentList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: advertismentList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, index) {
          advertismentList[index].id;
          return AdvertismentHomeCard(advert: advertismentList[index]);
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