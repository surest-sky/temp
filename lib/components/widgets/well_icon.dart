import 'package:flutter/material.dart';

import '../../enums/NoteType.dart';
import '../../models/NoteItem.dart';

class WellIcon extends StatelessWidget {
  final NoteItem item;
  const WellIcon({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return wellIcon(item);
  }

  Widget wellIcon(NoteItem item) {
    if (item.type == NoteType.ocr) {
      return const Icon(
        Icons.image,
        size: 16,
        color: Colors.blueAccent,
      );
    }
    if (item.type == NoteType.url) {
      return const Icon(
        Icons.attachment,
        size: 16,
        color: Colors.blueAccent,
      );
    }
    return const Icon(
      Icons.description,
      size: 16,
      color: Colors.blueAccent,
    );
  }
}
