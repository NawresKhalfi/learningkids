import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Keeps a runtime's [WebViewController] attached to a real platform
/// WebView without showing it — Python/JS execute in it, but the learner
/// only ever sees the console output Flutter renders separately.
class HiddenRuntimeWebView extends StatelessWidget {
  const HiddenRuntimeWebView({super.key, required this.controller});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0,
      height: 0,
      child: Offstage(child: WebViewWidget(controller: controller)),
    );
  }
}
