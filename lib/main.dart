import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwh/services/ShareService.dart';
import 'package:kwh/view/AppPage.dart';
import 'package:kwh/view/SearchPage.dart';
import 'package:kwh/view/SettingPage.dart';
import 'package:kwh/view/auth/login.dart';
import 'package:kwh/view/auth/register.dart';
import 'dart:async';
import 'package:kwh/view/pages/ItemWebViewPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEMO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, //修改页面的背景
        //修改AppBar的主体样式
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          elevation: 0, //隐藏AppBar底部的阴影分割线
          systemOverlayStyle: SystemUiOverlayStyle.light, //设置状态栏的背景
        ),
        visualDensity: VisualDensity.standard,
      ),
      routes: {
        'loginPage': (context) => const LoginPage(),
        'registerPage': (context) => const DropDownListExample(),
        'appPage': (context, {arguments}) => AppPage(arguments: arguments),
        'searchPage': (context) => const SearchPage(),
        'settingPage': (context) => const SettingPage(),
        'itemWebViewPage': (context) => const ItemWebViewPage(),
      },
      initialRoute: 'appPage',
      builder: EasyLoading.init(),
    );
  }
}
