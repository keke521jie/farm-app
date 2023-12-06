import "package:app/gen/assets.gen.dart";
import "package:flutter/material.dart";

class AppScaffold extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  /// 带有默认背景图片的 [Scaffold]
  const AppScaffold({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF000000),
      body: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          image: DecorationImage(image: Assets.images.homeBg.provider(), fit: BoxFit.cover),
        ),
        child: child,
      ),
    );
  }
}
