import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/components/HomeItemSheet.dart';
import 'package:kwh/enums/ListActionEnum.dart';
import 'package:kwh/enums/NoteType.dart';
import 'package:kwh/mixins/ItemAction.dart';
import 'package:kwh/models/NoteItem.dart';
import 'package:kwh/widgets/url_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeNoteItem extends StatelessWidget with ItemAction {
  final NoteItem item;
  final Function updateList;

  HomeNoteItem({
    Key? key,
    required this.item,
    required this.updateList,
  }) : super(key: key);

  Widget _itemAction(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [ Icon(icon), Text(text)],
    );
  }

  @override
  Widget build(BuildContext context) {
    void showButtonSheet() {
      showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => HomeItemSheet(
          item: item,
        ),
      );
    }

    _editItem(NoteItem item) {
      setEditItem(item, (NoteItem? _item) {
        updateList(ListActionEnum.update, item);
      });
      return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent, //重
        builder: itemAdd,
      );
    }

    void actionSheet(NoteItem item) {
      showAdaptiveActionSheet(
        context: context,
        // title: const Text("操作"),
        androidBorderRadius: 10,
        actions: <BottomSheetAction>[
          BottomSheetAction(
            title: _itemAction("编辑", Icons.mode_edit),
            onPressed: (context) {
              if(item.url.isNotEmpty) {
                EasyLoading.showToast("链接暂时未开放编辑");
                return;
              }
              Navigator.pop(context);
              _editItem(item);
            },
          ),
          BottomSheetAction(
            title: _itemAction("删除", Icons.delete),
            onPressed: (context) async{
              Navigator.pop(context);
              await deleteItem(context, item, (){
                updateList(ListActionEnum.delete, item);
              });
            },
          ),
        ],
        cancelAction: CancelAction(
          title: _itemAction("取消", Icons.cancel),
        ), // onPressed parameter is optional by default will dismiss the ActionSheet
      );
    }

    String wellTitle(NoteItem item) {
      final title = item.title.replaceAll('\n', '');
      if(item.type == NoteType.ocr) {
        return "[图片] " + title;
      }
      return title;
    }

    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, 'showPage', arguments: item.dataid);
        },
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 2),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8),
          //   color: Colors.white,
          //   boxShadow: const [
          //     BoxShadow(
          //       color: Colors.black12,
          //       blurRadius: 5.0,
          //     ),
          //   ],
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wellTitle(item),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Padding(padding: EdgeInsets.only(bottom: 10)),
              Text(
                item.updatedAt,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.black45),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 5)),
              Text(
                item.fullText.replaceAll('\n', ''),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
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
