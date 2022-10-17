import 'package:flutter/material.dart';

import '../../enums/NoteType.dart';
import '../../models/NoteItem.dart';

class WellTitle extends StatelessWidget {
  final NoteItem item;
  const WellTitle({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      wellTitle(item),
      textAlign: TextAlign.left,
      style: const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: 16,
        color: Colors.blueAccent,
      ),
    );
  }

  String wellTitle(NoteItem item) {
    final title = item.title.replaceAll('\n', '');
    if (item.type == NoteType.ocr) {
      return "[图片] " + title;
    }
    return title;
  }
}
