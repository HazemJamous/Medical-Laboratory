import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String image_url;

  const ImageCard({super.key, required this.image_url});

  @override
  Widget build(BuildContext context) {
    print('image url${image_url}');
    return Container(
      clipBehavior: Clip.hardEdge,
      width: context.width - 16,
      height: 150,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: CachedNetworkImage(
        width: context.width - 16,
        height: 150,
        fit: BoxFit.fitWidth,
        imageUrl:
            'https://beauty-station-back.bayanmasters.com/storage/${image_url}',
      ),
    );
  }
}

extension MyBuilcContextExtension on BuildContext {
  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;
  double get height => size.height;
}
