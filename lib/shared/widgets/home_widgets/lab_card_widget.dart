import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/core/constant/app_text_style.dart';
import 'package:midical_laboratory/features/pages/evaluation_page/evaluation_page.dart';

class LabCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double cardHeight;
  final int labId;

  const LabCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.cardHeight,
    required this.labId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardHeight * 1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.secondary, Colors.white, AppColors.accentLight],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          print("+++++++++++++++++++++++++++++");
          print("lab id :$labId");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewsPage(labId: labId)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                width: double.infinity,
                height: cardHeight,
                fit: BoxFit.contain,
                imageUrl: imageUrl.isNotEmpty
                    ? imageUrl
                    : "https://via.placeholder.com/150x100.png?text=Lab",
                placeholder: (ctx, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (ctx, url, err) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                child: Text(
                  title,
                  style: AppTextStyle.style2.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.pageTitle,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
