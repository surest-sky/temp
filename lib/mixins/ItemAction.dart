import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/services/ListService.dart';
import 'package:kwh/models/ListItem.dart';

mixin ItemAction {
  final TextEditingController _textEditingController =
      TextEditingController(text: "你好测试");
  final service = ListService();
  late final ListItem editItem;
  late final Function(ListItem) callback;

  // 文本输入框提交
  void submitText(BuildContext context) async {
    final text = _textEditingController.text;
    if (text.isEmpty) {
      EasyLoading.showToast("请输入");
      return;
    }

    EasyLoading.show(status: "提交中...");
    if (editItem.dataid.isNotEmpty) {
      editItem.fullText = text;
      callback(editItem);
      EasyLoading.showToast("修改成功");
      Navigator.pop(context);
      return;
    }

    await service.submit(text);
    EasyLoading.showToast("提交成功");
    _textEditingController.clear();
    EasyLoading.dismiss();
  }

  deleteItem(BuildContext context, ListItem item, Function callbackFunc) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('是否继续删除'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              EasyLoading.show(status: "请稍后...");
              service.delete(item.dataid).whenComplete(
                () {
                  EasyLoading.showToast("删除成功");
                  Navigator.pop(context, 'Cancel');
                  callbackFunc();
                },
              );
            },
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
  }

  void setEditItem(ListItem item, Function(ListItem) _callback) {
    editItem = item;
    callback = _callback;
    _textEditingController.text = item.fullText;
  }

  Widget itemAdd(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.3,
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
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: const Text(
                      "取消",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Text(
                    "添加/修改",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () => submitText(context), child: const Text("保存"))
                ],
              ),
            ),
            Expanded(
              child: TextField(
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
                controller: _textEditingController,
                maxLines: 20,
                onEditingComplete: () {},
                enableInteractiveSelection: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
