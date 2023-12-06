import "package:flutter/material.dart";

/// App内普通文字，基本都是白色，字体为interRegular
class AppText extends Text {
  /// 普通白色文字，fontSize：16，fontWeight：500，fontFamily：interRegular
  const AppText.white(
    super.data, {
    super.key,
    super.maxLines,
    super.textAlign,
    super.overflow = TextOverflow.ellipsis,
    super.style = const AppTextStyle(),
  });

  /// 白色标题文字，fontSize：40，fontWeight：bold，fontFamily：aktivGroteskXBold
  const AppText.whiteTitle(
    super.data, {
    super.key,
    super.style = const AppTextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
  });

  /// 普通白色文字，fontSize：16，fontWeight：600，fontFamily：interRegular
  const AppText.black(
    super.data, {
    super.key,
    super.maxLines,
    super.textAlign,
    super.style = const AppTextStyle(color: Colors.black, fontWeight: FontWeight.w600),
  });
}

class AppTextStyle extends TextStyle {
  const AppTextStyle({
    super.color = Colors.white,
    super.fontSize = 16,
    super.letterSpacing = -0.02,
    super.height = 1.33,
    super.fontWeight = FontWeight.w500,
  });
}
