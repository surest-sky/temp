import 'package:flutter/material.dart';
import 'package:kwh/models/LoginUser.dart';
import 'package:kwh/services/AuthService.dart';
import 'package:kwh/services/NoteService.dart';

import '../components/widgets/list_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final service = NoteService();
  LoginUser _user = LoginUser.fromJson({});

  Future _initUser() async {
    final user = await AuthService.getUser();
    setState(() {
      _user = user ?? LoginUser.fromJson({});
    });

    if (_user.uId.isEmpty) {
      Navigator.of(context).pushNamed("loginPage");
      return;
    }

    AuthService.saveUser(_user);
  }

  @override
  void initState() {
    super.initState();
    _initUser();
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
                Container(
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
                    children:  [
                      ListItem(
                        onTap: () {
                          Navigator.of(context).pushNamed("syncConfigPage");
                        },
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.sync,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 5,),
                              Text("同步管理"),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: Colors.black54,
                          )
                        ],
                      ),
                      ListItem(
                        onTap: () {
                          Navigator.of(context).pushNamed("tagsManagerPage");
                        },
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.library_books,
                                size: 20,
                                color: Colors.black87,
                              ),
                              SizedBox(width: 5,),
                              Text("归档"),
                            ],
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: Colors.black54,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
