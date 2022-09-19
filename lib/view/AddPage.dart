import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import './pages/TextAddPage.dart';
import './pages/ImageAddPage.dart';
import 'package:flutter/services.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  var _currentIndex = 0;
  final moduleList = [
    IndexedStackChild(child: const TextAddPage()),
    IndexedStackChild(child: const ImageAddPage()),
  ];

  //底部导航栏切换
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: _currentIndex,
    );
    _tabController.addListener(() {
      _onTap(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("添加"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          GFSegmentTabs(
            tabController: _tabController,
            length: 2,
            tabs: const <Widget>[
              Text(
                "文字|链接",
              ),
              Text(
                "图片",
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(5),
            child: ProsteIndexedStack(
              index: _currentIndex,
              children: moduleList,
            ),
          ),
        ],
      ),
    );
  }
}
