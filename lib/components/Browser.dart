import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WebViewPageState();
  }
}

class WebViewPageState extends State<WebViewPage> {
  final String _title = "webview";

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return const WebView(
      initialUrl: 'https://h5.tutorpage.net/auth/login',
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
