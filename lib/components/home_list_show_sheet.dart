import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kwh/models/ListItem.dart';
import 'package:kwh/components/widgets/url_button.dart';

class HomeItemSheet extends StatefulWidget {
  final ListItem item;

  const HomeItemSheet({Key? key, required this.item}) : super(key: key);

  @override
  State<HomeItemSheet> createState() => _HomeItemSheetState();
}

class _HomeItemSheetState extends State<HomeItemSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Container(),
        middle: const Text("笔记详情"),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                widget.item.updatedAt,
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
              UrlButton(item: widget.item),
              Text(
                widget.item.fullText,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
