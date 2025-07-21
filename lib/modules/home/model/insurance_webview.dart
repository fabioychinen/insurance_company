import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  static Future<void> open(
    BuildContext context, {
    required String url,
    required String title,
  }) async {
    if (kIsWeb) {
      await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WebViewPage(url: url, title: title),
        ),
      );
    }
  }

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() => isLoading = true);
        },
        onPageFinished: (url) {
          setState(() => isLoading = false);
        },
        onWebResourceError: (error) {
          setState(() => isLoading = false);
        },
      ))
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}