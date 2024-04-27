import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Giving extends StatefulWidget {

  const Giving({super.key});

  
  @override
  _GivingState createState() => _GivingState();
}

class _GivingState extends State<Giving> {

  final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://crichurch.org/partnership'));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partnership'),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: WebViewWidget(controller: controller),
      )
    );
  }
}

