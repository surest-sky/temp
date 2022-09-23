import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:kwh/services/AuthService.dart';
import 'AddPage.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class AppPage extends StatefulWidget {
  final Map? arguments;

  const AppPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _currentIndex = 0;
  late StreamSubscription _intentDataStreamSubscription;
  late StreamSubscription<bool> keyboardSubscription;

  void _toAddPage() {
    setState(() {
      _currentIndex = 1;
    });
  }

  _keyboardState() {
    var keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      if(!visible) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  _loadInit() async {
    if (!await AuthService.isLogin()) {
      Timer.run(() {
        Navigator.pushReplacementNamed(context, "loginPage");
      });
    }
    Timer.run(() {
      ReceiveSharingIntent.getTextStream().listen((String value) {
        _toAddPage();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInit();
    _keyboardState();

    if ((widget.arguments ?? {}).isNotEmpty) {
      int tapIndex = widget.arguments!["index"] ?? 0;
      setState(() {
        _currentIndex = tapIndex;
      });
    }
  }

  //底部导航栏数组
  final items = [
    // ignore: prefer_const_constructors
    BottomNavigationBarItem(icon: const Icon(Icons.home), label: '首页'),
    // ignore: prefer_const_constructors
    BottomNavigationBarItem(icon: const Icon(Icons.add_circle), label: '添加'),
    // ignore: prefer_const_constructors
    BottomNavigationBarItem(icon: const Icon(Icons.person), label: '我的'),
  ];

  //底部导航栏页面
  final bodyList = [
    IndexedStackChild(child: const HomePage()),
    IndexedStackChild(child: const AddPage()),
    IndexedStackChild(child: const ProfilePage()),
  ];

  //底部导航栏切换
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: _currentIndex, //当前选中标识符
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
      ),
      //ProsteIndexedStack包裹，实现底部导航切换时保持原页面状态
      body: ProsteIndexedStack(
        index: _currentIndex,
        children: bodyList,
      ),
    );
  }
}
