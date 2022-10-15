import 'package:flutter/material.dart';

import '../mixins/ItemAction.dart';

class AddNoteAction extends StatelessWidget{
  AddNoteAction({Key? key}) : super(key: key);
  final TextEditingController _textEditingController =
  TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.add),
    );
  }

  _add(context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, //重
      builder: itemAdd,
    );
  }

  Widget itemAdd(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                  const Text(
                    "添加/修改",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => {},
                    child: const Text("保存"),
                  )
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
