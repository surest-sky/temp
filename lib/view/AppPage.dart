import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:kwh/services/AuthService.dart';
import 'CoursePage.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  _loadInit() async {
    if (!await AuthService.isLogin()) {
      Timer.run(() {
        Navigator.pushNamed(context, "loginPage");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInit();
  }

  //底部导航栏数组
  final items = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.home), label: '首页', tooltip: ''),
    // ignore: prefer_const_constructors
    BottomNavigationBarItem(
        icon: const Icon(Icons.school), label: '课程管理', tooltip: ''),
    // ignore: prefer_const_constructors
    BottomNavigationBarItem(
        icon: const Icon(Icons.person), label: '我的', tooltip: ''),
  ];

  //底部导航栏页面
  final bodyList = [
    IndexedStackChild(child: const HomePage()),
    IndexedStackChild(child: const CoursePage()),
    IndexedStackChild(child: const ProfilePage()),
  ];

  int _currentIndex = 0;

  //底部导航栏切换
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
