import 'package:flutter/material.dart';

class LTRWrapper extends StatelessWidget {
  final Widget child;

  const LTRWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.ltr, child: child);
  }
}
