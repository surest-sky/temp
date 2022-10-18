import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/models/ItemView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ItemWebViewPage extends StatefulWidget {
  const ItemWebViewPage({Key? key}) : super(key: key);

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

  _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      EasyLoading.showError("打开链接失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemView = ModalRoute.of(context)!.settings.arguments as ItemView;
    String title = itemView.title;
    if (title.length > 10) {
      title = title.substring(0, 10) + '...';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              _launchUrl(itemView.url);
            },
            icon: Image.asset(
              "assets/images/browser.png",
              alignment: Alignment.center,
              width: 25,
            ),
          ),
        ],
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: itemView.url,
      ),
    );
  }
}
