import 'package:flutter/material.dart';
import 'package:kwh/models/ListItem.dart';
import '../components/home_list_item.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/components/widgets/list_empty.dart';
import 'package:kwh/mixins/ItemAction.dart';
import 'package:kwh/enums/ListActionEnum.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with ItemAction {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController _searchController =
      TextEditingController(text: "");
  late ScrollController _scrollController;
  List<ListItem> _searchList = [];

  var page = 1;
  var isLoading = false;
  var isNoMore = false;

  _search() async {
    final keyword = _searchController.text;
    EasyLoading.show();
    final List<ListItem> tempList = await service
        .searchListItem(keyword, page)
        .whenComplete(() => EasyLoading.dismiss());

    if (tempList.isEmpty) {
      isNoMore = true;
      return;
    }
    setState(() {
      if (page == 1) {
        _searchList = tempList;
      } else {
        _searchList.addAll(tempList);
      }
      isLoading = false;
    });
  }

  updateList(ListActionEnum action, ListItem? item) {
    final List<ListItem> _list = [];
    if(action == ListActionEnum.delete) {
      _searchList.forEach((ListItem _item) {
        if(_item.dataid != item!.dataid) {
          _list.add(_item);
        }
      });
    }else if(action == ListActionEnum.update) {
      _searchList.forEach((ListItem _item) {
        if(_item.dataid == item!.dataid) {
          _item = item;
        }
        _list.add(_item);
      });
    }

    setState(() {
      _searchList = _list;
    });
  }

  Future _onRefresh() async {
    _search();
  }

  Future _loadMore() async {
    if (isNoMore) {
      return;
    }
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      page++;
      _search();
    }
  }


  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              textInputAction: TextInputAction.search,
              controller: _searchController,
              onEditingComplete: _search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _search();
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        child: _searchList.isEmpty
            ? const ListEmpty()
            : ListView.builder(
                itemCount: _searchList.length + 1,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index == _searchList.length) {
                    return _buildProgressMoreIndicator();
                  }
                  return HomeListItem(
                    item: _searchList[index],
                    updateList: updateList,
                    // callback: updateList,
                  );
                },
              ),
      ),
    );
  }

  Widget itemChild(String title) {
    return Container(
      child: Text(title),
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

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
