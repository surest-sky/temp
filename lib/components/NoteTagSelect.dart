import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_tag_editor/tag_editor.dart';

import '../services/NoteService.dart';
import 'Skeleton.dart';

class NoteTagSelect extends StatefulWidget {
  final List<String> tags;
  final Function(List<String>) submit;

  const NoteTagSelect({Key? key, required this.tags, required this.submit}) : super(key: key);

  @override
  State<NoteTagSelect> createState() => _NoteTagSelectState();
}

class _NoteTagSelectState extends State<NoteTagSelect> {
  List<String> _values = [];
  List<String> _tags = [];
  bool loading = true;

  final service = NoteService();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  initTags() async {
    _tags = await service.getAllTags();

    setState(() {
      _tags = _tags;
      _values.addAll(widget.tags);
      loading = false;
    });
  }

  _addTag(String tag) {
    if(_values.contains(tag)) {
      EasyLoading.showToast("标签已添加过啦");
      return;
    }

    if(tag.length >= 8) {
      EasyLoading.showToast("标签长度最长为8个字符喔");
      return;
    }

    if(_values.length >= 5) {
      EasyLoading.showToast("最多添加5个标签喔");
      return;
    }

    setState(() {
      _values.add(tag);
    });
  }

  @override
  void initState() {
    super.initState();

    initTags();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TagEditor(
              length: _values.length,
              controller: _textEditingController,
              focusNode: _focusNode,
              delimiters: [',', ' '],
              hasAddButton: true,
              resetTextOnSubmitted: true,
              // This is set to grey just to illustrate the `textStyle` prop
              textStyle: const TextStyle(color: Colors.blueAccent),
              inputDecoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '请输入...',
              ),
              onTagChanged: (newValue) {
                _addTag(newValue);
              },
              tagBuilder: (context, index) => _Chip(
                index: index,
                label: _values[index],
                onDeleted: _onDelete,
              ),
              // InputFormatters example, this disallow \ and /
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
              ],
            ),
            const Divider(),
            const Text(
              "⚠️新标签将自动创建",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: loading
                  ? const Skeleton(count: 4)
                  : ListView.builder(
                      itemCount: _tags.length,
                      itemBuilder: (context, index) {
                        return itemTag(
                            _values.contains(_tags[index]), _tags[index]);
                      },
                    ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: GFButton(
                onPressed: () {
                  widget.submit(_values);
                },
                child: const Text("确认"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemTag(bool isChecked, String tagName) {
    return ListTile(
      leading: Checkbox(
        checkColor: Colors.white,
        value: isChecked,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        onChanged: (bool? value) {
          final _value = value as bool;
          setState(() {
            if (_value) {
              _addTag(tagName);
            } else {
              _values.remove(tagName);
            }
          });
        },
      ),
      title: Text(tagName),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blueAccent;
    }
    return Colors.blueAccent;
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.blueAccent,
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
        color: Colors.white,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
