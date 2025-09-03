import 'package:flutter/material.dart';
import 'package:midical_laboratory/core/constant/app_colors.dart';
import 'package:midical_laboratory/services/lab_search/lab_search_service.dart';

class FavoriteWidget extends StatefulWidget {
  FavoriteWidget({super.key, required this.isFavorite, required this.labId});
  int labId;
  bool isFavorite;

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _loading = false;
  bool _pressed = false;

  Future<void> _toggleFavorite() async {
    if (_loading) return;
    setState(() => _loading = true);
    final success = await LabSearchService.putDeleteFavoriteLab(widget.labId);
    if (success) {
      widget.isFavorite = !widget.isFavorite; // نفس اللوجيك السابق
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: _toggleFavorite,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.92 : 1.0,
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: Colors.grey.shade200,
            // gradient: const LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [AppColors.accent, Colors.white],
            // ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 14,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.2,
            ),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: _loading
                  ? const SizedBox(
                      key: ValueKey('loader'),
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      widget.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      key: ValueKey(widget.isFavorite),
                      color: AppColors.buttonPrimary,
                      // Colors.red,
                      size: 30,
                      weight: 20,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
