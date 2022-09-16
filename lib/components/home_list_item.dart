import 'package:flutter/material.dart';
import 'package:kwh/enums/ListActionEnum.dart';
import 'package:kwh/models/ListItem.dart';
import 'package:kwh/components/widgets/url_button.dart';
import 'package:kwh/components/home_list_show_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:kwh/mixins/ItemAction.dart';

class HomeListItem extends StatelessWidget with ItemAction {
  final ListItem item;
  final Function updateList;

  HomeListItem({
    Key? key,
    required this.item,
    required this.updateList,
  }) : super(key: key);

  Widget _itemAction(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(text), Icon(icon)],
    );
  }

  @override
  Widget build(BuildContext context) {
    void showButtonSheet() {
      FocusManager.instance.primaryFocus?.unfocus();
      showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => HomeItemSheet(
          item: item,
        ),
      );
    }

    _editItem(ListItem item) {
      setEditItem(item, (ListItem _item) {
        print(item.fullText);
        updateList(ListActionEnum.update, item);
      });
      return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent, //重
        builder: itemAdd,
      );
    }

    void actionSheet(ListItem item) {
      showAdaptiveActionSheet(
        context: context,
        title: const Text("操作"),
        androidBorderRadius: 10,
        actions: <BottomSheetAction>[
          BottomSheetAction(
            title: _itemAction("编辑", Icons.edit_off),
            onPressed: (context) {
              Navigator.pop(context);
              _editItem(item);
            },
          ),
          BottomSheetAction(
            title: _itemAction("删除", Icons.delete_outline),
            onPressed: (context) async{
              Navigator.pop(context);
              await deleteItem(context, item, (){
                updateList(ListActionEnum.delete, item);
              });
            },
          ),
        ],
        cancelAction: CancelAction(
          title: _itemAction("取消", Icons.highlight_off),
        ), // onPressed parameter is optional by default will dismiss the ActionSheet
      );
    }

    return InkWell(
      onTap: showButtonSheet,
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
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Text(
              item.updatedAt,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.black45),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: UrlButton(item: item),
                ),
                SizedBox(
                  width: 50,
                  child: IconButton(
                    onPressed: () => actionSheet(item),
                    icon: const Icon(Icons.more_horiz),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
