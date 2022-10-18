import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ItemWebViewPage extends StatefulWidget {
  final String url;
  const ItemWebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  State<ItemWebViewPage> createState() => _ItemWebViewPageState();
}

class _ItemWebViewPageState extends State<ItemWebViewPage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://flutter.dev',
    );
  }
}
