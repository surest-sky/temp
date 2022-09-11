import 'package:flutter/material.dart';
import 'package:kwh/models/ListItem.dart';
import 'package:kwh/components/home_list_show_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kwh/components/widgets/url_button.dart';

class HomeListItem extends StatelessWidget {
  final ListItem item;

  const HomeListItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => HomeItemSheet(
          item: item,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 3), // 偏移量
                blurRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 5)),
            Text(
              item.fullText,
              textAlign: TextAlign.left,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
            UrlButton(item: item),
          ],
        ),
      ),
    );
  }
}
