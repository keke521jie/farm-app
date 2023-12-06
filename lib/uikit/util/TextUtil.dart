import "package:flutter/material.dart";

class TextUtil {
  static Size calculateTextHeight(
    String value,
    fontSize,
    FontWeight? fontWeight,
    String fontFamily,
    double maxWidth,
    int maxLines,
    BuildContext context,
  ) {
    value = _filterText(value);
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
      locale: Localizations.localeOf(context),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: value,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontFamily: fontFamily,
        ),
      ),
    );
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return Size(painter.width, painter.height);
  }

  static String _filterText(String text) {
    String tag = "<br>";
    while (text.contains("<br>")) {
      // flutter 算高度,单个\n算不准,必须加两个
      text = text.replaceAll(tag, "\n\n");
    }
    return text;
  }
}
