import "package:dartx/dartx.dart";
import "package:flutter/cupertino.dart";

class ClipMsgHandler {
  void handle(BuildContext? context, Map<String, dynamic> msg, void Function(Map<String, dynamic> data) reply) {
    var name = msg.getOrElse("name", () => "");
    switch (name) {
      case "getScreenInfo":
        if (context == null) {
          reply({
            "pixelRatio": 0,
            "screenWidth": 0,
            "screenHeight": 0,
            "statusBarHeight": 0,
            "bottomBarHeight": 0,
          });
          break;
        }
        MediaQueryData mq = MediaQuery.of(context);
        var pixelRatio = mq.devicePixelRatio;
        var screenWidth = mq.size.width;
        var screenHeight = mq.size.height;
        var statusBarHeight = mq.padding.top;
        var bottomBarHeight = mq.padding.bottom;
        var payload = {
          "pixelRatio": pixelRatio,
          "screenWidth": screenWidth,
          "screenHeight": screenHeight,
          "statusBarHeight": statusBarHeight,
          "bottomBarHeight": bottomBarHeight,
        };

        debugPrint("getScreenInfo, result: ${payload.toString()}");
        reply(payload);
        break;
    }
  }
}