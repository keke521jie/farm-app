import "dart:convert";

import "package:dartx/dartx.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:webview_flutter/webview_flutter.dart";
import "package:webview_flutter_android/webview_flutter_android.dart";
import "package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart";

import "ClipMsgHandler.dart";

class ClipView extends HookWidget {
  final Uri uri;
  final List<ClipMsgHandler> msgHandlers;
  final GlobalKey<NavigatorState> navigatorKey;

  const ClipView({super.key, required this.uri, required this.msgHandlers, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    var view = useMemoized(() => _ClipView(uri: uri, msgHandlers: msgHandlers, navigatorKey: navigatorKey));
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        debugPrint("onPopInvoked, didPop: $didPop");
      },
      child: view,
    );
  }
}

class _ClipView extends HookWidget {
  final Uri uri;
  final List<ClipMsgHandler> msgHandlers;
  late final WebViewController webViewController;
  late final GlobalKey<NavigatorState> navigatorKey;

  _ClipView({required this.uri, required this.msgHandlers, required this.navigatorKey}) {
    PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    webViewController = WebViewController.fromPlatformCreationParams(params);
    webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webViewController.setBackgroundColor(const Color(0xffffffff));
    webViewController.setNavigationDelegate(
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
          debugPrint("allowing navigation to ${request.url}");
          return NavigationDecision.navigate;
        },
        onUrlChange: (UrlChange change) {
          debugPrint("url change to ${change.url}");
        },
      ),
    );
    if (webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (webViewController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      webViewController.addJavaScriptChannel(
        "Clipbus",
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint("Clipbus received message: ${message.message}");

          Map<String, dynamic> msg = jsonDecode(message.message);
          var type = msg.getOrElse("@type", () => "") as String;
          var id = msg.getOrElse("id", () => "") as String;
          var name = msg.getOrElse("name", () => "") as String;

          if (type == "MessagebusMsg" && id.isNotNullOrBlank && name.isNotNullOrBlank) {
            for (var handler in msgHandlers) {
              handler.handle(navigatorKey.currentContext, msg, (payload) {
                Map<String, dynamic> message = {"@type": type, "id": "replay:$id", "name": name, "payload": payload};
                var jsonData = jsonEncode(message);
                var javaScript = "postMessage('$jsonData')";

                debugPrint("Clipbus tell message: $javaScript");
                webViewController.runJavaScript(javaScript);
              });
            }
          }
        },
      );

      webViewController.loadRequest(uri);
      return null;
    });

    return Container(
      color: Colors.white,
      child: WebViewWidget(controller: webViewController),
    );
  }
}
