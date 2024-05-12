import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
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
      ..loadRequest(Uri.parse(
          'https://storage.googleapis.com/20ktpm-studenthub-storage/resumes/1715249446929-resume.pdf?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=studenthub-storage%40fast-lattice-416510.iam.gserviceaccount.com%2F20240509%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20240509T153220Z&X-Goog-Expires=604800&X-Goog-SignedHeaders=host&X-Goog-Signature=5924c9f8e903581c3217f9d4e990b649d910e805e17be191b62c405fa89143e86479d1a8d2916c3e95249fb4c32862713f0a9f0682691d53499702783824e0253bbcc62454fcda610b6431177d420a509be52697e77d7babc731b56617fc4838361348c32070af1a2406e6fb558c9fed86f4e7fd222d2334cb7548c87e413afb0c9b5075a1b5f7ccc0fdac97d968ac9a89d29368742bced9710823e77bd461f8fa1c60fdbe1a6f34576090a0f6006689c4237d1f105364ec9c4807dc817a744204a398a3bd1c093ac257c93f48740509a1b073167be6b58c2668eb8398b18402b65a44d0546c6b549a20244bd722f4a902769e1494927360ad41c70820a95a42'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(controller: controller),
    );
  }
}
