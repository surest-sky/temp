import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:kwh/widgets//list_empty.dart';

import '../../components/PlatformConfig.dart';
import '../../models/LoginUser.dart';
import '../../models/UserConfig.dart';
import '../../services/AuthService.dart';
import '../../services/NoteService.dart';

class SyncConfigPage extends StatefulWidget {
  const SyncConfigPage({Key? key}) : super(key: key);

  @override
  State<SyncConfigPage> createState() => _SyncConfigPageState();
}

class _SyncConfigPageState extends State<SyncConfigPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final service = NoteService();
  List<UserConfig> _configs = [];
  LoginUser _user = LoginUser.fromJson({});

  Future _initUser() async {
    final user = await AuthService.getUser();
    final configs = await service.getUserConfig();
    setState(() {
      _user = user ?? LoginUser.fromJson({});
      _configs = configs;
    });

    if (_user.uId.isEmpty) {
      Navigator.of(context).pushNamed("loginPage");
      return;
    }

    AuthService.saveUser(_user);
  }

  _refresh() {
    _refreshIndicatorKey.currentState!.show();
    Navigator.of(context).pop();
  }

  _action({UserConfig? config}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, //重
      builder: (BuildContext context) {
        final height = MediaQuery.of(context).size.height;
        return Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          height: height * 0.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              const Text(
                "操作",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              PlatformConfig(
                refresh: _refresh,
                config: config,
              )
            ],
          ),
        );
      },
    );
  }

  _deleteItem(BuildContext context, UserConfig config) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('是否继续删除'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              EasyLoading.show(status: "请稍后...");
              service.submitConfig(config, action: 'del').whenComplete(
                () {
                  EasyLoading.showToast("删除成功");
                  _refresh();
                },
              );
            },
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show();
    _initUser().whenComplete(() => EasyLoading.dismiss());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("同步管理"),
        actions: [
          TextButton(
            onPressed: _action,
            child: const Text("新建", style: TextStyle(color: Colors.white, fontSize: 18,),),
          ),
        ],
      ),
      body: _configs.length == 0
            ? Container(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _initUser,
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return ListEmpty();
                    },
                  ),
                ),
              )
            : Container(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _initUser,
                  child: ListView.builder(
                    itemCount: _configs.length,
                    itemBuilder: (context, index) {
                      return platformItem(_configs[index], index);
                    },
                  ),
                ),
              ),
    );
  }

  Widget platformItem(UserConfig config, int index) {
    String text = config.val;
    if (config.remark.isNotEmpty) {
      text = "(${config.remark}) $text";
    }

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey.shade200,
        ),
      ),
      child: SwipeActionCell(
        ///这个key是必要的
        key: ValueKey(_configs[index]),
        trailingActions: <SwipeAction>[
          SwipeAction(
            title: "更新",
            onTap: (CompletionHandler handler) async {
              _action(config: config);
            },
            color: Colors.blueAccent,
          ),
          SwipeAction(
            title: "删除",
            onTap: (CompletionHandler handler) async {
              _deleteItem(context, config);
            },
            color: Colors.red,
          ),
        ],
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  platformIcon(config.paas),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      text,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  config.isExpire
                      ? const Text("已过期",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ))
                      : Container(),
                  Switch(
                    // This bool value toggles the switch.
                    value: config.status,
                    onChanged: (bool value) {
                      setState(() {
                        final index = _configs.indexWhere(
                          (item) => item.id == config.id,
                        );
                        final configs = _configs;
                        configs[index].status = value;
                        setState(() {
                          _configs = _configs;
                          service.submitConfig(config);
                        });
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget platformIcon(String platform) {
    String iconImage = "";
    switch (platform) {
      case "github":
        iconImage = "assets/icons/github-fill.png";
        break;
      case "bilibili_favorites":
        iconImage = "assets/icons/bilibili-fill.png";
        break;
      case "rss":
        iconImage = "assets/icons/rss.png";
        break;
      case "sitemap_xml":
        iconImage = "assets/icons/sitemap.png";
        break;
      default:
        iconImage = "assets/icons/github.png";
    }
    return Container(
      child: Image.asset(
        iconImage,
        width: 30,
        height: 30,
      ),
    );
  }
}
