import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwh/components/NoteAdd.dart';
import 'package:kwh/enums/NoteType.dart';
import 'package:kwh/widgets/CustomWidget.dart';
import 'package:kwh/widgets/custom_list_item.dart';

import './pages/ImageAddPage.dart';

class NewAddPage extends StatefulWidget {
  const NewAddPage({Key? key}) : super(key: key);

  @override
  State<NewAddPage> createState() => _NewAddPageState();
}

class _NewAddPageState extends State<NewAddPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  var _currentIndex = 0;
  // final moduleList = [
  //   IndexedStackChild(child: const TextAddPage()),
  //   IndexedStackChild(child: const ImageAddPage()),
  // ];

  final Map<int, String> _moduleMap = {1: '文字笔记', 2: '图片', 3: '平台链接(抖音、B站...)'};

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
    return CustomScrollView(
      slivers: <Widget>[
        CustomWidget.buildSliverAppBar("笔记", leading: const SizedBox(height: 1)),
        _buildSliverFixedExtentList()
      ],
    );
  }

  Widget _buildSliverFixedExtentList() {
    return SliverFixedExtentList(
      itemExtent: 190,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _moduleItem(index);
        },
        childCount: 1,
      ),
    );
  }

  String colorString(Color color) {
    return "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
  }

  Widget _moduleItem(int index) {
    if(index == 0) {
      return _noteMoule();
    }
    return _platformMoule();
  }

  Widget _noteMoule() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            CustomListItem(
              leading: const Icon(Icons.description, color: Color(0xFFF38181)),
              trailing: const Icon(Icons.add),
              title: "笔记添加",
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => NoteAdd(type: NoteType.text),
                );
              },
            ),
            CustomListItem(
              leading: const Icon(Icons.link, color: Color(0xFFFCE38A)),
              trailing: const Icon(Icons.add),
              title: "网址添加",
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent, //重
                  builder: (context) => NoteAdd(type: NoteType.url),
                );
              },
            ),
            CustomListItem(
              leading: const Icon(Icons.image, color: Color(0xFF3DC7BE)),
              trailing: const Icon(Icons.add),
              title: "图片添加(OCR自动识别)",
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent, //重
                  builder: (context) => const ImageAddPage(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _platformMoule() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            CustomListItem(
              leading: const Icon(Icons.description, color: Color(0xFFF38181)),
              trailing: const Icon(Icons.add),
              title: "抖音添加",
              onTap: () {
                Navigator.of(context).pushNamed("tagsManagerPage");
              },
            )
          ],
        ),
      ),
    );
  }
}
