import 'package:flutter/material.dart';
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
    return Container(
        padding: const EdgeInsets.only(
          top: 20,
          right: 10,
          left: 10,
          bottom: 10,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              textAlign: TextAlign.center,
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
            Expanded(
              child: ListView(
                children: [
                  SelectableText(
                    widget.item.fullText,
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
