import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://sites.google.com/view/indonesiachord/home'),
      );

    return WebViewWidget(controller: controller);
  }
}
