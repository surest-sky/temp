import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../models/LoginUser.dart';
import '../services/AuthService.dart';
import 'package:flutter/services.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  LoginUser _user = LoginUser.fromJson({});
  final TextEditingController _accountController =
      TextEditingController(text: "");

  Future _initUser() async {
    final user = await AuthService.getUser();
    setState(() {
      _user = user ?? LoginUser.fromJson({});
      _accountController.text = _user.name;
    });
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
          Container(
            margin: EdgeInsets.only(right: 10),
            child: const Center(
              child: Text(
                "完成",
                style: TextStyle(
                  fontSize: 18,
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
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(_user.avatar),
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
                      width: 60,
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
                      width: 60,
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
                      width: 60,
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
                            onPressed: () {},
                            child: const Text("重置"),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 5)),
                          ElevatedButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _user.idkey));
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
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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

  Widget list({required List<Widget> children}) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
