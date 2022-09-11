import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kwh/components/browser.dart';
import 'package:kwh/models/ListItem.dart';
import 'package:kwh/components/home_list_item.dart';
import 'package:kwh/services/ListService.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<HomePage> {
  final service = ListService();
  List<ListItem> lists = [];

  _load() async {
    final _lists = await service.getListApi();
    setState(() {
      lists = _lists;
    });
  }

  _initList() async {
    Timer.run(() async {
      EasyLoading.show(status: '加载中...');
      await _load();
      EasyLoading.dismiss();
    });
  }

  _pushSearch() {
    Navigator.pushNamed(context, "searchPage");
  }

  Future _onRefresh() async {
    setState(() {
      lists = [];
    });
    return Future.delayed(Duration(seconds: 1), () {
      _load();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("首页"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _pushSearch,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: lists.length,
          itemBuilder: (context, index) {
            return HomeListItem(item: lists[index]);
          },
        ),
      ),
    );
  }
}
