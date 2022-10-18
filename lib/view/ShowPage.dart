import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/components/Skeleton.dart';
import 'package:kwh/http/response.dart';
import 'package:kwh/models/NoteItem.dart';
import 'package:kwh/services/NoteService.dart';
import 'package:kwh/widgets/CustomWidget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import './pages/TextAddPage.dart';
import '../components/HomeItemSheet.dart';

class ShowPage extends StatefulWidget {
  String dataId;

  ShowPage({Key? key, required this.dataId}) : super(key: key);

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  late final NoteItem item;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final service = NoteService();
  bool loading = true;

  Future _loadData() async {
    print(widget.dataId);
    final ResponseMap responseMap = await service.getShowData(widget.dataId);
    if (responseMap.code != 200) {
      EasyLoading.showToast("数据不存在");
      Navigator.pop(context);
      return;
    }

    if ((responseMap.data as List).isEmpty) {
      EasyLoading.showToast("数据不存在");
      Navigator.pop(context);
      return;
    }

    setState(() {
      item = NoteItem.fromJson(responseMap.data[0]);
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("详情"),
        actions: [_buildPopupMenuButton(context)],
      ),
      body: loading
          ? const Padding(
              padding: EdgeInsets.all(10),
              child: Skeleton(count: 4),
            )
          : RefreshIndicator(
              child: Container(
                child: HomeItemSheet(
                  item: item,
                ),
                color: Colors.white,
              ),
              onRefresh: _loadData,
            ),
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        CustomWidget.buildPopupItem("快速编辑", Icons.edit),
        CustomWidget.buildPopupItem("回到首页", Icons.home)
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
        ),
      ),
      onSelected: (e) {
        if (e == '回到首页') {
          Navigator.pushReplacementNamed(context, 'appPage');
        }
        if (e == '快速编辑') {
          showBarModalBottomSheet(
            expand: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const Padding(padding: EdgeInsets.all(10), child: TextAddPage(),),
          );
        }
      },
      onCanceled: () => print('onCanceled'),
    );
  }
}
