import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwh/services/ListService.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/getwidget.dart';

class TextAddPage extends StatefulWidget {
  const TextAddPage({Key? key}) : super(key: key);

  @override
  State<TextAddPage> createState() => _TextAddPageState();
}

class _TextAddPageState extends State<TextAddPage> {
  final service = ListService();
  final TextEditingController _textEditingController =
      TextEditingController(text: "");

  _initEditText() async {
    ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value.isNotEmpty) {
        _textEditingController.text = value;
        submitText();
      }
    });
  }

  initClipboard() async {
    String text = Clipboard.getData(Clipboard.kTextPlain) as String;
    if (text.isEmpty) {
      return;
    }

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('检测到剪贴板有内容，是否自动填充'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState((){
                _textEditingController.text = text;
              });
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  // 文本输入框提交
  void submitText() async {
    final text = _textEditingController.text;
    if (text.isEmpty) {
      EasyLoading.showToast("请输入");
      return;
    }
    EasyLoading.show(status: "提交中...");
    await service.submit(text);
    EasyLoading.dismiss();
    EasyLoading.showToast("提交成功");

    _textEditingController.clear();
  }

  @override
  void initState() {
    super.initState();
    _initEditText();
    initClipboard();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _textEditingController,
          maxLines: 10,
          onEditingComplete: () {},
          enableInteractiveSelection: true,
          decoration: const InputDecoration(
            hintText: '请输入或粘贴网址 https://...',
            fillColor: Color(0XFFF5F5F5),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                color: Color(0XFFF5F5F5),
              ), //<-- SEE HERE
            ),
            focusedBorder: OutlineInputBorder(
              //<-- SEE HERE
              borderSide: BorderSide(
                width: 0,
                color: Color(0XFFF5F5F5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GFButton(
          onPressed: submitText,
          text: "提交",
          fullWidthButton: true,
        ),
      ],
    );
  }
}
