import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({Key? key, required this.path}) : super(key: key);

  final String? path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: path,
        onPageStarted: (url) {
          print('page started $url');
          if (url.contains('order-ok')) {
            context.push('/success');
          } else if (url.contains('order-error')) {
            context.pop();
          }
        },
        onPageFinished: (url) {
          print('page loaded $url');
        },
      ),
    );
  }
}
