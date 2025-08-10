import 'package:flutter/material.dart';

class DropShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double width = size.width;
    double height = size.height;

    path.lineTo(0, height - 80);
    path.quadraticBezierTo(width * 0.25, height, width * 0.5, height - 60);
    path.quadraticBezierTo(width * 0.75, height - 120, width, height - 60);
    // path.quadraticBezierTo(width * 0.25, height, width * 0.5, height - 60);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
