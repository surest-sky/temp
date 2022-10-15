import 'package:flutter/material.dart';
import 'package:kwh/models/NoteItem.dart';
import 'package:kwh/models/ItemView.dart';

class UrlButton extends StatelessWidget {
  final NoteItem item;

  const UrlButton({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String url = item.url;
    final ItemView itemView = ItemView(title: item.title, url: url);

    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: url.isEmpty
          ? null
          : TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "itemWebViewPage",
                    arguments: itemView);
              },
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.bottomLeft,
              ),
              child: Text(
                item.url,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
    );
  }
}
