import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/api/api_link.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/features/pages/tabs_options/tabs_options.dart';
import 'package:midical_laboratory/models/lap_information_model.dart';
import 'package:midical_laboratory/shared/widgets/favorite_widget.dart';

class LabCardWidget extends StatelessWidget {
  final LabInformationModel cardModel;

  const LabCardWidget({Key? key, required this.cardModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cardHeight = MediaQuery.of(context).size.height / 5;

    return InkWell(
      onTap: () {
        print('lab-----------');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategoryTabs(labId: cardModel.id, labName: cardModel.labName),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.secondary, Colors.white, AppColors.accentLight],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        height: cardHeight,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: CachedNetworkImage(
                width: 120,
                height: cardHeight,
                fit: BoxFit.contain,
                imageUrl: ApiLink.fileUrl(cardModel.imagePath),
                // "https://beauty-station-back.bayanmasters.com/storage/services/e4Wb2qS1JQ55c0PFIfionHNKVImCIku7PuZAxDj0.jpg",
                placeholder: (ctx, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (ctx, url, err) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cardModel.labName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pageTitle,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${cardModel.location.city} • ${cardModel.location.address}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: FavoriteWidget(
                isFavorite: cardModel.isfavorite,
                labId: cardModel.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class LabCardWidget extends StatelessWidget {
//   final LabInformationModel cardModel;
//   const LabCardWidget({super.key, required this.cardModel});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Container(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height / 5,
//         clipBehavior: Clip.hardEdge,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: const Color.fromARGB(255, 164, 188, 228),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FavoriteWidget(
//               isFavorite: cardModel.isfavorite,
//               labId: cardModel.id,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 spacing: 13,
//                 children: [
//                   Text(
//                     "${cardModel.labName}",
//                     style: TextStyle(
//                       color: AppColors.textColor,
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "${cardModel.location.city} - ${cardModel.location.address}",
//                     style: TextStyle(
//                       // fontFamily: 'Almarai',
//                       color: Colors.black,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: double.maxFinite,
//               width: 115,

//               child: CachedNetworkImage(
//                 fit: BoxFit.cover,
//                 // imageUrl: "http://127.0.0.1:8000${cardModel.imagePath}",
//                 imageUrl:
//                     "https://imgs.search.brave.com/hLrdVsVDfYeR4Ursp5NosSudQR3uqlWDLxihqS4FZmg/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/cHJlbWl1bS1waG90/by9yZWFsaXN0aWMt/cGhvdG8tYnJpZ2h0/LWxhYnJhdG9yeS13/aXRoLWJsdWUtd2hp/dGUtdG9uZXMtbWlj/cm9zY29wZS1mb3Jl/Z3JvdW5kLW1lZGlj/YWwtZXF1XzM0Mzk2/MC0xMTIwMzYuanBn/P3NpemU9NjI2JmV4/dD1qcGc",
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
