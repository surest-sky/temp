import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kwh/services/NoteService.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/getwidget.dart';

class UrlPage extends StatefulWidget {
  const UrlPage({Key? key}) : super(key: key);

  @override
  State<UrlPage> createState() => _UrlPageState();
}

class _UrlPageState extends State<UrlPage> {
  final service = NoteService();
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
    try {
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
                setState(() {
                  _textEditingController.text = text;
                });
              },
              child: const Text('确认'),
            ),
          ],
        ),
      );
    } catch (e) {}
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
    // initClipboard();
  }

  @override
  Widget build(BuildContext context) {
    final height = 600 - MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            height: height - 230,
            child: TextField(
              controller: _textEditingController,
              maxLines: 100,
              keyboardType: TextInputType.multiline,
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
          ),
          const SizedBox(height: 10),
          Container(
            height: 30,
            child: Row(
              children: [tag("测试"), tag('测试3')],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: GFButton(
              onPressed: submitText,
              text: "提交",
              fullWidthButton: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget tag(String tagName) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(6),
      margin: EdgeInsets.only(left: 5),
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('#$tagName', style: const TextStyle(color: Colors.orange)),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            const Icon(
              Icons.close,
              size: 12,
            )
          ],
        ),
      ),
    );
  }
}
