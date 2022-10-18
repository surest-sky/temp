import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/components/HomeNoteItem.dart';
import 'package:kwh/components/Skeleton.dart';
import 'package:kwh/models/NoteItem.dart';

import '../../services/NoteService.dart';

class TagPage extends StatefulWidget {
  final String tag;

  const TagPage({Key? key, required this.tag}) : super(key: key);

  @override
  State<TagPage> createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<NoteItem> _list = [];
  final service = NoteService();
  bool loading = true;
  final Map<String, IconData> map = const {
    "回到首页": Icons.home,
    "回到首页2": Icons.home,
    "问题反馈": Icons.add_comment,
  };

  Future _loadData() async {
    final tempList = await service.getTagList("开发");
    setState(() {
      _list = tempList;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#${widget.tag}"),
        // actions: _buildActions(context),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return _loadData().then(
            (value) {
              EasyLoading.showToast("刷新完成");
            },
          );
        },
        child: ListView(
          children: _list
              .map(
                (item) => Container(
                  margin: EdgeInsets.only(top: 10),
                  child: HomeNoteItem(
                    item: item,
                    updateList: () {},
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<Widget> _buildActions(context) {
    return <Widget>[
      _buildPopupMenuButton(context)
    ];
  }

  String colorString(Color color) {
    return "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
  }

  SliverChildBuilderDelegate loadingSkeleton() {
    return SliverChildBuilderDelegate(
      (_, int index) => Container(
        padding: const EdgeInsets.all(10),
        child: const Skeleton(count: 3),
      ),
      childCount: 2,
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        ...buildItems().sublist(0, 2),
        const PopupMenuDivider(),
        ...buildItems().sublist(2, 3)
      ],
      offset: const Offset(0, 50),
      color: Colors.white,
      elevation: 1,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
        topRight: Radius.circular(5),
        bottomLeft: Radius.circular(5),
      )),
      onSelected: (e) {
        if (e == '回到首页') {
          Navigator.pushReplacementNamed(context, 'homePage');
        }
      },
      onCanceled: () => print('onCanceled'),
    );
  }

  List<PopupMenuItem<String>> buildItems() {
    return map.keys
        .toList()
        .map((e) => PopupMenuItem<String>(
            value: e,
            child: Wrap(
              spacing: 10,
              children: <Widget>[
                Icon(map[e], color: Colors.blue),
                Text(e),
              ],
            )))
        .toList();
  }
}
