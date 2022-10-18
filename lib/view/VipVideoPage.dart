import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/widgets/CustomWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VipVideoPage extends StatefulWidget {
  final String url;
  const VipVideoPage({Key? key, required this.url}) : super(key: key);

  @override
  State<VipVideoPage> createState() => _VipVideoPageState();
}

class _VipVideoPageState extends State<VipVideoPage> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vip 解析"),
        actions: [_buildPopupMenuButton(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: WebView(
          initialUrl: 'https://jx.bozrc.com:4433/player/?url=${widget.url}',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webcontroller){
            _controller = webcontroller;
          },
        ),
      ),
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        CustomWidget.buildPopupItem("刷新", Icons.refresh),
        CustomWidget.buildPopupItem("浏览器打开", Icons.refresh),
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
        if(e == '浏览器打开') {
          _launchUrl(widget.url);
          return;
        }
         _controller.reload();
      },
      onCanceled: () => print('onCanceled'),
    );
  }


  _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      EasyLoading.showError("打开链接失败");
    }
  }
}
