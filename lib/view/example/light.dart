import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 除半透明状态栏
    if (Theme.of(context).platform == TargetPlatform.android) {
      // android 平台
      SystemUiOverlayStyle _style =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(_style);
    }
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: LeftDrawerHome());
  }
}

class LeftDrawerHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LeftDrawerHomeState();
  }
}

class LeftDrawerHomeState extends State<LeftDrawerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // 标题居中
        title: Text(
          "标题名2",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white, // 背景白色
        elevation: 0, // 去除阴影
        brightness: Brightness.light, // 状态栏白底黑字
      ),
    );
  }
}