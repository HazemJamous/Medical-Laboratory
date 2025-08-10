import 'package:flutter/material.dart';

import 'package:midical_laboratory/services/lab_search/lab_search_service.dart';

class FavoriteWidget extends StatefulWidget {
  FavoriteWidget({super.key, required this.isFavorite, required this.labId});
  int labId;
  bool isFavorite;

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      color: const Color.fromARGB(255, 208, 207, 210),
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: () async {
          bool isSuccess = await LabSearchService.putDeleteFavoriteLab(
            widget.labId,
          );
          if (isSuccess) {
            widget.isFavorite = !widget.isFavorite;
            setState(() {});
          }
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Icon(
            widget.isFavorite
                ? Icons.favorite_outlined
                : Icons.favorite_border_outlined,
            // Icons.search_rounded,
            color: Colors.redAccent,
            size: 20,
            weight: 20,
          ),
        ),
      ),
    );
  }
}
