import 'package:flutter/material.dart';
import 'package:kwh/models/UserConfig.dart';

import '../../components/PlatformConfig.dart';


class SyncConfigItemPage extends StatefulWidget {
  final UserConfig? config;
  const SyncConfigItemPage({Key? key, this.config}) : super(key: key);

  @override
  State<SyncConfigItemPage> createState() => _SyncConfigItemPageState();
}

class _SyncConfigItemPageState extends State<SyncConfigItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("配置管理"),
      ),
      body: PlatformConfig(
        refresh: () {},
        config: widget.config,
      ),
    );
  }
}

