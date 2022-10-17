import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/enums/NoteType.dart';
import 'package:kwh/models/NoteItem.dart';
import 'package:kwh/widgets/url_button.dart';

class HomeItemSheet extends StatefulWidget {
  final NoteItem item;

  const HomeItemSheet({Key? key, required this.item}) : super(key: key);

  @override
  State<HomeItemSheet> createState() => _HomeItemSheetState();
}

class _HomeItemSheetState extends State<HomeItemSheet> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 20,
            right: 10,
            left: 10,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                "添加时间: ${widget.item.updatedAt}",
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
              Row(
                children: [
                  widget.item.url.isNotEmpty ? urlWidget() : const SizedBox(),
                  Expanded(child: UrlButton(item: widget.item)),
                ],
              ),
              contentText(widget.item),
            ],
          ),
        )
      ],
    );
  }

  Widget contentText(NoteItem item) {
    if (item.type == NoteType.ocr) {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade500),
        ),
        child: Image.network(
          item.url,
          alignment: Alignment.center,
        ),
      );
    }

    return SelectableText(
      widget.item.fullText,
      textAlign: TextAlign.left,
    );
  }

  Widget urlWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () {
          Clipboard.setData(
            ClipboardData(text: widget.item.url),
          );
          EasyLoading.showToast("复制成功");
        },
        child: const Icon(
          Icons.copy,
          size: 16,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
