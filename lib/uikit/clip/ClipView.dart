import "dart:convert";

import "package:dartx/dartx.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:webview_flutter/webview_flutter.dart";
import "package:webview_flutter_android/webview_flutter_android.dart";
import "package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart";

import "../../base/store/IdentityStore.dart";
import "../getIt.dart";
import "ClipMsgHandler.dart";

class ClipView extends HookWidget {
  final Uri _uri;
  final List<ClipMsgHandler> _msgHandlers;
  final ClipViewController _clipViewController;
  late final WebViewController _webViewController;
  late final GlobalKey<NavigatorState> _navigatorKey;
  var identityStore = getIt<IdentityStore>();

  ClipView({
    super.key,
    required Uri uri,
    required List<ClipMsgHandler> msgHandlers,
    required ClipViewController controller,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _uri = uri,
        _msgHandlers = msgHandlers,
        _clipViewController = controller,
        _navigatorKey = navigatorKey {
    PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    _webViewController = WebViewController.fromPlatformCreationParams(params);
    _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController.setBackgroundColor(const Color(0xffffffff));
    _webViewController.setNavigationDelegate(
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
    if (_webViewController.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_webViewController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    _clipViewController._setup(_webViewController);
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _webViewController.addJavaScriptChannel(
        "Clipbus",
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint("Clipbus received message: ${message.message}");

          Map<String, dynamic> msg = jsonDecode(message.message);
          var type = msg.getOrElse("@type", () => "") as String;
          var id = msg.getOrElse("id", () => "") as String;
          var name = msg.getOrElse("name", () => "") as String;

          if (type == "MessagebusMsg" && id.isNotNullOrBlank && name.isNotNullOrBlank) {
            for (var handler in _msgHandlers) {
              handler.handle(_navigatorKey.currentContext, msg, (payload) {
                Map<String, dynamic> message = {"@type": type, "id": "replay:$id", "name": name, "payload": payload};
                var jsonData = jsonEncode(message);
                var javaScript = "postMessage('$jsonData')";

                debugPrint("Clipbus tell message: $javaScript");
                _webViewController.runJavaScript(javaScript);
              });
            }
          }
        },
      );

      _webViewController.loadRequest(_uri);
      return null;
    });

    return Container(
      color: Colors.white,
      child: WebViewWidget(controller: _webViewController),
    );
  }
}

class ClipViewController {
  late WebViewController _controller;

  _setup(WebViewController controller) {
    _controller = controller;
  }
}
