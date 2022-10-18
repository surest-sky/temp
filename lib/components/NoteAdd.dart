import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kwh/enums/NoteType.dart';
import 'package:kwh/widgets/CustomModule.dart';
import 'package:kwh/widgets/CustomStyle.dart';

import '../models/NoteItem.dart';
import '../services/NoteService.dart';
import 'NoteTagEdit.dart';

class NoteAdd extends StatefulWidget {
  final NoteItem? editItem;
  final String type;

  const NoteAdd({Key? key, this.editItem, required this.type})
      : super(key: key);

  @override
  State<NoteAdd> createState() => _NoteAddState();
}

class _NoteAddState extends State<NoteAdd> {
  final TextEditingController _textEditingController =
      TextEditingController(text: "");
  final TextEditingController _remarkEditingController =
      TextEditingController(text: "");
  final service = NoteService();
  List<String> tags = [];

  loadData() {
    if (widget.editItem == null) return;
    setState(() {
      _textEditingController.text = widget.editItem?.fullText ?? "";
      _remarkEditingController.text = widget.editItem?.remark ?? "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 20),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "取消",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    CustomModule.noteTitle(widget.type),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _paste,
                        icon: const Icon(
                          Icons.content_paste_go,
                          color: Colors.grey,
                        ),
                      ),
                      GFButton(
                        size: GFSize.SMALL,
                        onPressed: () => submitText(context),
                        child: const Text("保存"),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: TextField(
                decoration: CustomStyle.getTextFieldDecoration(
                    '请输入或粘贴网址 https://...',
                    padding: 15),
                controller: _textEditingController,
                maxLines: 20,
                onEditingComplete: () {},
                enableInteractiveSelection: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 60,
              child: TextField(
                controller: _remarkEditingController,
                decoration: CustomStyle.getTextFieldDecoration('备注[可选]'),
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                maxHeight: 160,
                minHeight: 50,
              ),
              width: width,
              padding: const EdgeInsets.only(top: 10),
              child: NoteTagEdit(
                tags: widget.editItem?.tags ?? [],
                complete: (_tags) => tags = _tags,
              ),
            )
          ],
        ),
      ),
    );
  }

  // 文本输入框提交
  void submitText(BuildContext context) async {
    final text = _textEditingController.text;
    if (text.isEmpty) {
      EasyLoading.showToast("请输入");
      return;
    }

    if (widget.type == NoteType.url) {
      if (!text.startsWith("http") || !text.startsWith("https")) {
        EasyLoading.showToast("请输入正确的网址喔");
        return;
      }
    }

    EasyLoading.show(status: "提交中...");
    if (widget.editItem != null) {
      widget.editItem!.fullText = text;
      await service.update(widget.editItem!.dataid, text);
      EasyLoading.showToast("修改成功");
      return;
    }

    await service.submit(text,
        type: widget.type, tags: tags, remark: widget.editItem?.remark ?? "");
    EasyLoading.showToast("提交成功");
    _textEditingController.clear();
    EasyLoading.dismiss();
  }

  void _paste() async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    final String text = clipboard?.text as String;
    if (text.isEmpty) {
      EasyLoading.showToast("剪贴板未检测到数据");
      return;
    }

    setState(() {
      _textEditingController.text = text;
    });
  }
}
