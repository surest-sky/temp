import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kwh/models/NoteItem.dart';
import 'package:kwh/components/HomeNoteItem.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/widgets/list_empty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kwh/mixins/ItemAction.dart';

import 'package:kwh/widgets/CustomWidget.dart';
import '../enums/ListActionEnum.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<HomePage> with ItemAction {
  final prefs = SharedPreferences.getInstance();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<NoteItem> lists = [];
  late ScrollController _scrollController;
  var page = 1;
  var isLoading = false;
  var isNoMore = false;
  var prefListKey = "home-list";

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
      _loadList();
      return;
      final List<String> _lists = prefs.getStringList(prefListKey) ?? [];
      if (_lists.isEmpty) {
        _loadList();
        return;
      }

      for (var item in _lists) {
        lists.add(NoteItem.fromJson(json.decode(item)));
      }
    });
  }

  _loadList() async {
    _refreshIndicatorKey.currentState!.show();
    final List<NoteItem> tempList = await service.getLastNoteItem(page);
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

  updateList(ListActionEnum action, NoteItem? item) {
    final List<NoteItem> _list = [];
    if (action == ListActionEnum.delete) {
      lists.forEach((NoteItem _item) {
        if (_item.dataid != item!.dataid) {
          _list.add(_item);
        }
      });
      setState(() {
        lists = _list;
      });
    } else if (action == ListActionEnum.update) {
      lists.forEach((NoteItem _item) {
        if (_item.dataid == item!.dataid) {
          _item = item;
        }
        _list.add(_item);
      });
      setState(() {
        lists = _list;
      });
    } else {
      _onRefresh();
    }
  }

  Future _loadMore() async {
    if (isNoMore || isLoading) return;

    isLoading = true;
    page++;
    _loadList();
  }

  _add() {
    setEditItem(
      null,
      (NoteItem? _item) => {updateList(ListActionEnum.refresh, _item)},
    );
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, //重
      builder: itemAdd,
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
    super.initState();
    Timer.run(() {
      _loadListByPrefs();
    });

    _scrollController = ScrollController();
    _scrollController.addListener(
      () async {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
          await _loadMore();
        }
      },
    );
  }

  Widget _buildSliverFixedExtentList() {
    return SliverFixedExtentList(
      itemExtent: 150,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == lists.length) {
            return _buildProgressMoreIndicator();
          }
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: HomeNoteItem(
              item: lists[index],
              updateList: updateList,
            ),
          );
        },
        childCount: lists.length + 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        child: CustomScrollView(
          slivers: <Widget>[
            CustomWidget.buildSliverAppBar(
              "首页",
              leading: const SizedBox(height: 1),
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
            _buildSliverFixedExtentList()
          ],
        ),
        onRefresh: _onRefresh,
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
}
