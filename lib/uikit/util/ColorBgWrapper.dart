import "package:flutter/material.dart";

class ColorBgWrapper extends StatelessWidget {
  late Widget child;
  Color bgColor;

  ColorBgWrapper({
    super.key,
    required this.child,
    this.bgColor = const Color(0xFF003300),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: child,
    );
  }
}
