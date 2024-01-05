import "dart:convert";

import "package:dartx/dartx.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:uuid/uuid.dart";
import "package:webview_flutter/webview_flutter.dart";
import "package:webview_flutter_android/webview_flutter_android.dart";
import "package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart";

import "ClipMsgHandler.dart";

class ClipView extends HookWidget {
  final Uri uri;
  final List<ClipMsgHandler> msgHandlers;
  final GlobalKey<NavigatorState> navigatorKey;
  late WebViewController webViewController;

  ClipView({super.key, required this.uri, required this.msgHandlers, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    webViewController = useMemoized(() {
      PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }
      return WebViewController.fromPlatformCreationParams(params);
    });

    var view = useMemoized(() {
      return _ClipView(
        uri: uri,
        msgHandlers: msgHandlers,
        navigatorKey: navigatorKey,
        controller: webViewController,
      );
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        var msg = MessagebusMsg(const Uuid().v4(), "pop", {});
        debugPrint("onPopInvoked, didPop: $didPop, script: ${msg.toScript()}");
        await webViewController.runJavaScript(msg.toScript());
        debugPrint("onPopInvoked, didPop: $didPop, complete");
      },
      child: view,
    );
  }
}

class _ClipView extends HookWidget {
  final Uri uri;
  final List<ClipMsgHandler> msgHandlers;
  late final WebViewController controller;
  late final GlobalKey<NavigatorState> navigatorKey;

  _ClipView({required this.uri, required this.msgHandlers, required this.navigatorKey, required this.controller}) {
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setBackgroundColor(const Color(0xffffffff));
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
          debugPrint("allowing navigation to ${request.url}");
          return NavigationDecision.navigate;
        },
        onUrlChange: (UrlChange change) {
          debugPrint("url change to ${change.url}");
        },
      ),
    );
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      controller.addJavaScriptChannel(
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
                var msg = MessagebusMsg("replay:$id", name, payload);
                debugPrint("Clipbus tell message: ${msg.toScript()}");
                controller.runJavaScript(msg.toScript());
              });
            }
          }
        },
      );

      controller.loadRequest(uri);
      return null;
    });

    return Container(
      color: Colors.white,
      child: WebViewWidget(controller: controller),
    );
  }
}

class MessagebusMsg {
  String id;
  String name;
  dynamic payload;

  MessagebusMsg(this.id, this.name, this.payload);

  Map<String, dynamic> toMap() {
    return {
      "@type": "MessagebusMsg",
      "id": id,
      "name": name,
      "payload": payload,
    };
  }

  String toScript() {
    return "window.postMessage('${jsonEncode(toMap())}')";
  }
}

class MessagebusReplayMsg extends MessagebusMsg {
  MessagebusReplayMsg(MessagebusMsg origin, dynamic payload) : super("replay:${origin.id}", origin.name, payload);
}
