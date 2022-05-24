import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({Key? key, required this.path}) : super(key: key);

  final String? path;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: path,
    );
  }
}
