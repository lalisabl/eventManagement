import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.startLoad) {
        print("Loading: ${widget.url}");
      }
    });
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      withJavascript: true,
      withZoom: true,
    );
  }
}
