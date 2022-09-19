import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/mixins/ImageAction.dart';
import 'package:kwh/services/ListService.dart';

import '../models/LoginUser.dart';
import '../services/AuthService.dart';
import 'package:flutter/services.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with ImageAction {
  LoginUser _user = LoginUser.fromJson({});
  final service = ListService();
  final TextEditingController _accountController =
      TextEditingController(text: "");

  Future _initUser() async {
    final user = await AuthService.getUser();
    setState(() {
      _user = user ?? LoginUser.fromJson({});
      _accountController.text = _user.name;
    });
  }

  Future _initUserApi() async {
    final user = await service.getUser(_user.phone);
    setState(() {
      _user = user;
    });
  }

  Future _updateAvatar() async {
    _submitAvatar(String base64, String path) {
      setState(() {
        _user.avatar = path;
      });
    }

    await imageSelect(complete: _submitAvatar);
  }

  Future _updateUser() async {
    String avatar = _user.avatar;
    EasyLoading.show(status: "更新中");
    if(!avatar.startsWith("http")) {
      avatar = await uploadImage();
      if(avatar.isEmpty) {
        EasyLoading.dismiss();
        return;
      }
    }
    _user.avatar = avatar;
    _user.name = _accountController.text;
    await service.updateUser(_user);
    EasyLoading.dismiss();
    EasyLoading.showToast("更新成功");
    _initUserApi();
  }

  // 秘钥重置
  Future _resetIdKey() async{
    EasyLoading.show(status: "更新中");
    await service.updateUser(_user, isUpdateKey: true);
    EasyLoading.dismiss();
    EasyLoading.showToast("更新成功");
    _initUserApi();
  }

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("设置"),
        actions: [
          InkWell(
            onTap: _updateUser,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: const Center(
                child: Text(
                  "保存",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _user.uId.isEmpty
          ? Container()
          : Column(
              children: [
                list(
                  onTap: () {
                    _updateAvatar();
                  },
                  children: [
                    Row(
                      children: [
                        _user.avatar.startsWith("http")
                            ? CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(_user.avatar),
                              )
                            : CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(_user.avatar),
                              ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        const Text("头像"),
                      ],
                    ),
                    const Icon(
                      Icons.navigate_next,
                    ),
                  ],
                ),
                list(
                  children: [
                    const SizedBox(
                      width: 70,
                      child: Text("账号:"),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _accountController,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          hintText: '请输入...',
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    )
                  ],
                ),
                list(
                  children: [
                    const SizedBox(
                      width: 70,
                      child: Text("手机号码:"),
                    ),
                    Expanded(
                      child: Text(_user.phone),
                    ),
                  ],
                ),
                list(
                  children: [
                    const SizedBox(
                      width: 40,
                      child: Text("Key:"),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 40,
                        child: Text(_user.idkey),
                      ),
                    ),
                    SizedBox(
                      width: 135,
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Colors.grey,
                            ),
                            onPressed: _resetIdKey,
                            child: const Text("重置"),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 5)),
                          ElevatedButton(
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: _user.idkey));
                              EasyLoading.showToast("复制成功");
                            },
                            child: const Text("复制"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      AuthService.logout();
                      Navigator.pushNamed(context, "loginPage");
                    },
                    child: const Text("退出登录"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.infinity, 40),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget list({required List<Widget> children, GestureTapCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      height: 70,
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
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
