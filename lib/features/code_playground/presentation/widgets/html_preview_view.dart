import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

/// The "aperçu visuel" for HTML/CSS from US27: a real WebView rendering
/// exactly what the learner wrote, refreshed on every "Exécuter" tap.
class HtmlPreviewView extends StatefulWidget {
  const HtmlPreviewView({super.key, required this.html});

  final String html;

  @override
  State<HtmlPreviewView> createState() => _HtmlPreviewViewState();
}

class _HtmlPreviewViewState extends State<HtmlPreviewView> {
  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadHtmlString(widget.html);

  @override
  void didUpdateWidget(HtmlPreviewView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.html != oldWidget.html) {
      _controller.loadHtmlString(widget.html);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: WebViewWidget(controller: _controller),
    );
  }
}
