import "dart:convert";

import "package:dartx/dartx.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:webview_flutter/webview_flutter.dart";
import "package:webview_flutter_android/webview_flutter_android.dart";
import "package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart";

import "ClipMsgHandler.dart";

class ClipView extends HookWidget {
  Uri uri;
  List<ClipMsgHandler> msgHandlers;

  ClipView({super.key, required this.uri, required this.msgHandlers});

  @override
  Widget build(BuildContext context) {
    WebViewController controller = useMemoized(() {
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }
      var controller = WebViewController.fromPlatformCreationParams(params);
      controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      controller.setBackgroundColor(const Color(0x00000000));
      controller.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint("WebView is loading (progress : $progress%)");
          },
          onPageStarted: (String url) {
            debugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) {
            debugPrint("Page finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("""
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          """);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith("https://www.youtube.com/")) {
              debugPrint("blocking navigation to ${request.url}");
              return NavigationDecision.prevent;
            }
            debugPrint("allowing navigation to ${request.url}");
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint("url change to ${change.url}");
          },
        ),
      );
      controller.addJavaScriptChannel(
        "Clipbus",
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint("Clipbus received message: ${message.message}");

          Map<String, dynamic> msg = jsonDecode(message.message);
          var t = msg.getOrElse("@type", () => "") as String;
          var id = msg.getOrElse("id", () => "") as String;
          var name = msg.getOrElse("name", () => "") as String;

          if (t.isNotNullOrBlank && id.isNotNullOrBlank && name.isNotNullOrBlank) {
            for (var handler in msgHandlers) {
              handler.handle(context, msg, (payload) {
                Map<String, dynamic> message = {"@type": t, "id": "replay:$id", "name": name, "payload": payload};
                var jsonData = jsonEncode(message);
                var javaScript = "postMessage('$jsonData')";

                debugPrint("Clipbus tell message: $javaScript");
                controller.runJavaScript(javaScript);
              });
            }
          }
        },
      );

      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
      }

      return controller;
    });

    useEffect(() {
      controller.loadRequest(uri);
      return null;
    });

    return Container(
      color: Colors.white,
      child: WebViewWidget(controller: controller),
    );
  }
}
