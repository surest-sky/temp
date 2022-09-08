import 'package:flutter/material.dart';
import 'package:tutor_page_h5/components/browser.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("首页"),
        automaticallyImplyLeading: false,
      ),
      body: WebViewPage(),
    );
  }
}
