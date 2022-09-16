import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kwh/models/ListItem.dart';
import 'package:kwh/components/home_list_item.dart';
import 'package:kwh/services/ListService.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/components/widgets/list_empty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kwh/components/home_list_show_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<HomePage> {
  final service = ListService();
  final prefs = SharedPreferences.getInstance();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<ListItem> lists = [];
  late ScrollController _scrollController;
  final TextEditingController _textEditingController =
      TextEditingController(text: "你好测试");
  var page = 1;
  var isLoading = false;
  var isNoMore = false;
  var prefListKey = "home-list";

  // 文本输入框提交
  void submitText() async {
    final text = _textEditingController.text;
    if (text.isEmpty) {
      EasyLoading.showToast("请输入");
      return;
    }
    EasyLoading.show(status: "提交中...");
    await service.submit(text);
    EasyLoading.dismiss();
    EasyLoading.showToast("提交成功");
    _textEditingController.clear();
  }

  // 将当前数据存储到列表中
  _saveList(lists) async {
    final List<String> _lists = [];
    lists.forEach((e) {
      _lists.add(json.encode(e));
    });
    prefs.then((prefs) {
      prefs.setStringList(prefListKey, _lists);
    });
  }

  // 从存储中加载List
  _loadListByPrefs() {
    prefs.then((prefs) {
      final List<String> _lists = prefs.getStringList(prefListKey) ?? [];
      if (_lists.isEmpty) {
        _loadList();
        return;
      }

      for (var item in _lists) {
        lists.add(ListItem.fromJson(json.decode(item)));
      }
    });
  }

  _loadList() async {
    EasyLoading.show(status: '加载中...');
    final List<ListItem> tempList = await service
        .getLastListItem(page)
        .whenComplete(() => EasyLoading.dismiss());

    if (tempList.isEmpty) {
      isNoMore = true;
      return;
    }
    setState(() {
      if (page == 1) {
        lists = tempList;
      } else {
        lists.addAll(tempList);
      }
      isLoading = false;
      _saveList(lists);
    });
  }

  Future _loadMore() async {
    if (isNoMore || isLoading) return;

    isLoading = true;
    page++;
    _loadList();
  }

  // 添加目标
  _add() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, //重
      builder: _itemAdd,
    );
  }

  void showButtonSheet(ListItem item) {
    FocusManager.instance.primaryFocus?.unfocus();
    showBarModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeItemSheet(
        item: item,
      ),
    );
  }

  void actionSheet(ListItem item) {
    showAdaptiveActionSheet(
      context: context,
      title: const Text('操作'),
      androidBorderRadius: 30,
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: _itemAction("编辑", Icons.cancel), onPressed: (context) {}),
      ],
      cancelAction: CancelAction(
        title: _itemAction("取消", Icons.close),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  // 跳转到搜索
  _pushSearch() {
    Navigator.pushNamed(context, "searchPage");
  }

  Future _onRefresh() async {
    page = 1;
    await _loadList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.run(() {
      _loadListByPrefs();
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        await _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DEMO"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _pushSearch,
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: _add,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        child: lists.isEmpty
            ? ListView(children: [const ListEmpty()])
            : ListView.builder(
                controller: _scrollController,
                itemCount: lists.length + 1,
                itemBuilder: (context, index) {
                  if (index == lists.length) {
                    return _buildProgressMoreIndicator();
                  }
                  return HomeListItem(
                    item: lists[index],
                    showButtonSheet: showButtonSheet,
                    actionSheet: actionSheet,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildProgressMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Center(
        child: Text("没有更多了", style: TextStyle(color: Colors.black45)),
      ),
    );
  }

  Widget _itemAdd(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.3,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 20),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: const Text(
                      "取消",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Text(
                    "添加/修改",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: submitText, child: const Text("保存"))
                ],
              ),
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: '请输入或粘贴网址 https://...',
                  fillColor: Color(0XFFF5F5F5),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      color: Color(0XFFF5F5F5),
                    ), //<-- SEE HERE
                  ),
                  focusedBorder: OutlineInputBorder(
                    //<-- SEE HERE
                    borderSide: BorderSide(
                      width: 0,
                      color: Color(0XFFF5F5F5),
                    ),
                  ),
                ),
                controller: _textEditingController,
                maxLines: 20,
                onEditingComplete: () {},
                enableInteractiveSelection: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemAction(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon), Text(text)],
    );
  }
}
