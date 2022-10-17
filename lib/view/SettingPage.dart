import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/styles/app_colors.dart';
import 'package:kwh/mixins/ImageAction.dart';
import 'package:kwh/services/NoteService.dart';
import 'package:kwh/view/auth/login.dart';

import '../models/LoginUser.dart';
import '../services/AuthService.dart';
import 'package:flutter/services.dart';

import 'auth/LoginPage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with ImageAction {
  LoginUser _user = LoginUser.fromJson({});
  final service = NoteService();
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
    AuthService.saveUser(user);
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
    if (!avatar.startsWith("http")) {
      avatar = await uploadImage();
      if (avatar.isEmpty) {
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
  Future _resetIdKey() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('是否继续重置，重置后将多平台不可使用旧key'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              EasyLoading.show(status: "更新中");
              await service.updateUser(_user, isUpdateKey: true);
              EasyLoading.dismiss();
              EasyLoading.showToast("重置成功");
              _initUserApi();
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
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
              margin: const EdgeInsets.only(right: 10),
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
          : RefreshIndicator(
              onRefresh: _initUser,
              child: Column(
                children: [
                  list(
                    onTap: () {
                      _updateAvatar();
                    },
                    children: [
                      const Text("头像"),
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
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  BorderTop(),
                  list(
                    children: [
                      const SizedBox(
                        width: 70,
                        child: Text("账号"),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: _accountController,
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                hintText: '请输入...',
                                contentPadding: EdgeInsets.all(8),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  BorderTop(),
                  list(
                    children: [
                      const SizedBox(
                        width: 70,
                        child: Text("手机号码"),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(_user.phone),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  list(
                    children: [
                      const SizedBox(
                        width: 30,
                        child: Text("Api"),
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
                                  ClipboardData(text: _user.idkey),
                                );
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
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        AuthService.logout();
                        // Navigator.pushNamed(context, "loginPage");
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const NewLoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text("退出登录"),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity, 40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget list({required List<Widget> children, GestureTapCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 5.0,
        //   ),
        // ],
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

  Widget BorderTop({double width = 1}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.appBaseColor,
            width: width,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}
