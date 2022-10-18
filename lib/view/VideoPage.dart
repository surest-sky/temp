import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kwh/widgets/CustomStyle.dart';
import 'package:kwh/widgets/CustomWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late WebViewController _controller;
  String url = "";
  bool loading = true;

  initUrl() {
    EasyLoading.show();
    getUrl().then((value) {
      setState(() {
        url = value;
        loading = false;
      });
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    super.initState();
    initUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("爱奇艺"),
        actions: [_buildPopupMenuButton(context)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration:
                        CustomStyle.getTextFieldDecoration("输入链接", padding: 5),
                  ),
                ),
                GFButton(
                  onPressed: () {},
                  child: const Text("Vip解析"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: loading
                  ? SizedBox()
                  : WebView(
                      zoomEnabled: false,
                      userAgent:
                          "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
                      initialUrl: url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webcontroller) {
                        _controller = webcontroller;
                      },
                      navigationDelegate: (NavigationRequest request) {
                        final url = request.url;
                        if(url.startsWith('https://www.iqiyi.com/app/register')) {
                          return NavigationDecision.prevent;
                        }
                        if(url.startsWith('https://m.iqiyi.com/') || url.startsWith('https://www.iqiyi.com') ) {
                          return NavigationDecision.navigate;
                        }
                        return NavigationDecision.prevent;
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        CustomWidget.buildPopupItem("Vip播放", Icons.play_circle),
        CustomWidget.buildPopupItem("回到首页", Icons.home),
      ],
      offset: const Offset(0, 50),
      color: Colors.white,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
        ),
      ),
      onSelected: (e) async {
        if (e == "回到首页") {
          _controller.loadUrl("https://www.iqiyi.com");
          return;
        }
        final url = await _controller.currentUrl();
        remberUrl(url ?? "");
        // Navigator.pushNamed(context, 'vipVideoPage', arguments: url);
        _launchUrl(url ?? "");
      },
      onCanceled: () => print('onCanceled'),
    );
  }

  void remberUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("url", url);
  }

  Future<String> getUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = await prefs.getString("url");
    if (url == null) {
      return 'https://www.iqiyi.com';
    }
    return url;
  }

  _launchUrl(String url) async {
    final Uri _url = Uri.parse("https://jx.bozrc.com:4433/player/?url=$url");
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      EasyLoading.showError("打开链接失败");
    }
  }
}
