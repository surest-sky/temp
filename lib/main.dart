import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwh/components/widgets/styles/app_colors.dart';
import 'package:kwh/components/widgets/styles/text_styles.dart';
import 'package:kwh/services/ShareService.dart';
import 'package:kwh/view/AppPage.dart';
import 'package:kwh/view/SearchPage.dart';
import 'package:kwh/view/SettingPage.dart';
import 'package:kwh/view/ShowPage.dart';
import 'package:kwh/view/auth/login.dart';
import 'package:kwh/view/auth/register.dart';
import 'package:kwh/view/example/light.dart';
import 'dart:async';
import 'package:kwh/view/pages/ItemWebViewPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/view/pages/SyncConfigPage.dart';
import 'package:kwh/view/pages/SyncConfigItemPage.dart';
import 'package:kwh/view/pages/TagPage.dart';
import 'package:kwh/view/pages/TagsManagerPage.dart';

void main() {
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.ring;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 除半透明状态栏
    if (Theme.of(context).platform == TargetPlatform.android) {
      // android 平台
      SystemUiOverlayStyle _style =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(_style);
    }

    return MaterialApp(
      title: '熊啊熊',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade100, //修改页面的背景
        //修改AppBar的主体样式
        appBarTheme: const AppBarTheme(
          titleTextStyle:  TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: AppColors.AppBarTitleColor,
          ),
          color: AppColors.AppBarColor,
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
        'syncConfigPage': (context) => const SyncConfigPage(),
        'tagsManagerPage': (context) => const TagsManagerPage(),
        'tagPage': (context) =>
            TagPage(tag: ModalRoute.of(context)!.settings.arguments as String),
        'showPage': (context) =>
            ShowPage(dataId: ModalRoute.of(context)!.settings.arguments as String),
      },
      initialRoute: 'appPage',
      builder: EasyLoading.init(),
    );
  }
}
