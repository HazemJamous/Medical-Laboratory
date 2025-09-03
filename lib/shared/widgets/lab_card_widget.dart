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
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategoryTabs(labId: cardModel.id, labName: cardModel.labName),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: AppColors.secondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // لمسة زخرفية خفيفة بالخلفية (فقاعة لونية شفافة)
            // Positioned(
            //   right: -20,
            //   bottom: -20,
            //   child: Container(
            //     width: 80,
            //     height: 80,
            //     decoration: BoxDecoration(
            //       color: AppColors.accentLight.withOpacity(0.35),
            //       shape: BoxShape.circle,
            //     ),
            //   ),
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // صورة المختبر مع إطار متدرّج و ظل ناعم
                Container(
                  width: 120,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.accent, AppColors.secondary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2), // يعطي إحساس "إطار"
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: ApiLink.fileUrl(cardModel.imagePath),
                        placeholder: (ctx, url) => Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        errorWidget: (ctx, url, err) => Container(
                          color: Colors.grey.shade100,
                          child: const Icon(
                            Icons.broken_image_rounded,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // معلومات المختبر
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم المختبر + سهم تلميحي يمين
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                cardModel.labName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.pageTitle,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: AppColors.accentDark.withOpacity(0.7),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // موقع المختبر (مدينة + عنوان) مع أيقونة
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(
                                Icons.location_on_rounded,
                                size: 16,
                                color: AppColors.buttonPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${cardModel.location.city.cityName}\n${cardModel.location.address}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13.2,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // شريط تأثير سفلي خفيف (جمالية بصرية)
                        Container(
                          height: 6,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.primary.withOpacity(0.18),
                                AppColors.accent.withOpacity(0.18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // زر المفضلة المطفو أعلى يمين الكارد
            Positioned(
              bottom: 8,
              right: 8,
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
