import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:kwh/models/UserConfig.dart';
import 'package:kwh/rules/validate.dart';
import 'package:kwh/services/ListService.dart';

class PlatformConfig extends StatefulWidget {
  final UserConfig? config;
  final Function refresh;

  const PlatformConfig({Key? key, this.config, required this.refresh})
      : super(key: key);

  @override
  State<PlatformConfig> createState() => _PlatformConfigState();
}

class _PlatformConfigState extends State<PlatformConfig> {
  final _formKey = GlobalKey<FormState>();
  final _validate = Validate();
  final _service = ListService();
  UserConfig _config = UserConfig.fromJson({});
  final List<String> platformList = [
    "github",
    'bilibili_favorites',
    'rss',
    'sitemap_xml'
  ];

  initConfig() {
    if (widget.config != null) {
      setState(() {
        _config = widget.config!;
      });
    } else {
      setState(() {
        _config.paas = platformList.first;
      });
    }
  }

  Future _submit() async {
    final form = _formKey.currentState!;
    if (!form.validate()) {
      return;
    }
    EasyLoading.show(status: "提交中");
    final map = await _service
        .submitConfig(_config)
        .whenComplete(() => EasyLoading.dismiss());
    if (map.code != 200) {
      EasyLoading.showToast(map.message);
      return;
    }

    EasyLoading.showToast(_config.uId.isNotEmpty ? "提交成功" : "更新成功");
    widget.refresh();
  }

  String getLabel() {
    String label = "用户名";
    switch (_config.paas) {
      case "rss":
        label = "链接";
        break;
      case "sitemap_xml":
        label = "链接";
        break;
    }
    return label;
  }

  @override
  void initState() {
    super.initState();
    initConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white54),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                label("选择平台"),
                const Padding(padding: EdgeInsets.only(left: 10)),
                DropdownButton<String>(
                  value:
                  _config.paas.isEmpty ? platformList.first : _config.paas,
                  icon: const Icon(Icons.expand_more),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _config.paas = value!;
                    });
                  },
                  items: platformList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            _config.paas == "bilibili_favorites"
                ? SizedBox(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      label("收藏夹ID"),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Expanded(child: formItem("请输入", 'val', _config.val))
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      label("SESSDATA"),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Expanded(
                        child: formItem(
                          "请输入",
                          'sessdata',
                          _config.sessdata,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
                : Row(
              children: [
                label(getLabel()),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(child: formItem("请输入", 'val', _config.val))
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                label("备注"),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                    child: formItem("请输入", 'remark', _config.remark,
                        required: false))
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                label("开启同步"),
                const Padding(padding: EdgeInsets.only(left: 10)),
                FlutterSwitch(
                  width: 60.0,
                  height: 20.0,
                  value: _config.status,
                  borderRadius: 5.0,
                  padding: 2.0,
                  onToggle: (val) {
                    setState(() {
                      _config.status = val;
                    });
                  },
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text("提交"),
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

  Widget label(String label) {
    return SizedBox(
      width: 100,
      child: Text(
        "$label:",
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget formItem(String label, String field, String? initialValue,
      {bool required = true}) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.phone,
      enableInteractiveSelection: true,
      onChanged: (value) {
        final Map<String, dynamic> tempConfig = _config.toJson();
        tempConfig[field] = value;
        _config = UserConfig.fromJson(tempConfig);
      },
      validator: (value) => required ? _validate.validateRequired(value) : null,
      decoration: const InputDecoration(
        isCollapsed: true,
        hintText: '请输入...',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8),
      ),
      // The validator receives the text that the user has entered.
    );
  }
}
