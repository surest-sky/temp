import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:kwh/components/widgets/list_item.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/widgets/custom_list_item.dart';
import '../models/LoginUser.dart';
import '../services/AuthService.dart';
import '../services/NoteService.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
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

  static const _imgHeight = 80.0;
  static const _expandedHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: EasyRefresh(
        header: BuilderHeader(
          clamping: false,
          position: IndicatorPosition.locator,
          triggerOffset: 100000,
          notifyWhenInvisible: true,
          builder: (context, state) {
            const expandedExtent = _expandedHeight - kToolbarHeight;
            final pixels = state.notifier.position.pixels;
            final height = state.offset + _imgHeight;
            final clipEndHeight = pixels < expandedExtent
                ? _imgHeight
                : math.max(0.0, _imgHeight - pixels + expandedExtent);
            final imgHeight = pixels < expandedExtent
                ? _imgHeight
                : math.max(0.0, _imgHeight - (pixels - expandedExtent));
            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: _TrapezoidClipper(
                    height: height,
                    clipStartHeight: 0.0,
                    clipEndHeight: clipEndHeight,
                  ),
                  child: Container(
                    height: height,
                    width: double.infinity,
                    color: themeData.colorScheme.primary,
                  ),
                ),
                Positioned(
                  top: -1,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: _FillLineClipper(imgHeight),
                    child: Container(
                      height: 2,
                      width: double.infinity,
                      color: themeData.colorScheme.primary,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(_user.avatar),
                  ),
                ),
              ],
            );
          },
        ),
        onRefresh: () {},
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: themeData.colorScheme.primary,
              foregroundColor: themeData.colorScheme.onPrimary,
              expandedHeight: _expandedHeight,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  _user.name,
                  style: TextStyle(color: themeData.colorScheme.onPrimary),
                ),
                centerTitle: true,
              ),
            ),
            const HeaderLocator.sliver(paintExtent: 80),
            SliverToBoxAdapter(
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    CustomListItem(
                      leading: const Icon(Icons.settings),
                      trailing: const Icon(Icons.navigate_next),
                      title: '个人设置',
                      onTap: () {
                        Navigator.of(context).pushNamed("settingPage");
                      },
                    ),
                    CustomListItem(
                      leading: const Icon(Icons.sell),
                      trailing: const Icon(Icons.navigate_next),
                      title: '我的归档',
                      onTap: () {
                        Navigator.of(context).pushNamed("tagsManagerPage");
                      },
                    ),
                    CustomListItem(
                      leading: const Icon(Icons.sync),
                      trailing: const Icon(Icons.navigate_next),
                      title: '同步管理',
                      onTap: () {
                        Navigator.of(context).pushNamed("syncConfigPage");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrapezoidClipper extends CustomClipper<Path> {
  final double height;
  final double clipStartHeight;
  final double clipEndHeight;

  _TrapezoidClipper({
    required this.height,
    required this.clipStartHeight,
    required this.clipEndHeight,
  });

  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width, height - clipEndHeight);
    path.lineTo(0, height - clipStartHeight);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_TrapezoidClipper oldClipper) {
    return oldClipper.height != height ||
        oldClipper.clipStartHeight != clipStartHeight ||
        oldClipper.clipEndHeight != clipEndHeight;
  }
}

class _FillLineClipper extends CustomClipper<Path> {
  final double imgHeight;

  _FillLineClipper(this.imgHeight);

  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width, height / 2);
    path.lineTo(0, height / 2 + imgHeight / 2);
    path.lineTo(0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _FillLineClipper oldClipper) {
    return oldClipper.imgHeight != imgHeight;
  }
}
