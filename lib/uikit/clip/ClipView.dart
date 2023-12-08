import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:webview_flutter/webview_flutter.dart";

class ClipView extends HookWidget {
  ClipView({super.key, required Uri uri}) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(uri);
  }

  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebViewWidget(controller: controller),
    );
  }
}
