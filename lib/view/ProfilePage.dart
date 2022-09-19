import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:kwh/components/widgets/list_empty.dart';
import 'package:kwh/models/LoginUser.dart';
import 'package:kwh/services/AuthService.dart';
import 'package:kwh/services/ListService.dart';
import 'package:kwh/components/platformConfig.dart';
import 'dart:ui';

import '../models/UserConfig.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final service = ListService();
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
    }
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的"),
        automaticallyImplyLeading: false,
      ),
      body: _user.uId.isEmpty
          ? ListView(children: const [
              SizedBox(
                height: 100,
              )
            ])
          : Column(
              children: [
                // Padding(padding: EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top + 20)),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("settingPage");
                  },
                  child: Container(
                    height: 100,
                    width: width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(_user.avatar),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                    ),
                                  ),
                                  Text(
                                    _user.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "ID: ${_user.uId}",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 40,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "自动同步",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _action,
                              child: const Text("新建"),
                            ),
                          ],
                        ),
                        _configs.length == 0
                            ? Expanded(
                                child: ListView(
                                  children: const [ListEmpty()],
                                ),
                              )
                            : Expanded(
                                child: RefreshIndicator(
                                  key: _refreshIndicatorKey,
                                  onRefresh: _initUser,
                                  child: ListView.builder(
                                    itemCount: _configs.length,
                                    itemBuilder: (context, index) {
                                      return platformItem(
                                          _configs[index], index);
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
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
