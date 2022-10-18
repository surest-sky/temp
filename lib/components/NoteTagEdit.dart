import 'package:flutter/material.dart';

import 'NoteTagSelect.dart';

class NoteTagEdit extends StatefulWidget {
  final List<String> tags;
  final Function(List<String>) complete;

  const NoteTagEdit({Key? key, required this.tags, required this.complete}) : super(key: key);

  @override
  State<NoteTagEdit> createState() => _NoteTagEditState();
}

class _NoteTagEditState extends State<NoteTagEdit> {
  List<String> _tags = [];

  setTags(List<String> tags) {
    setState(() {
      _tags = tags;
    });
    widget.complete(tags);
  }

  @override
  void initState() {
    super.initState();

    setTags(widget.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "标签:",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 5,),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 5,
            spacing: 10,
            children: [
              ..._tags.map((name) => tag(name)).toList(),
              InkWell(
                onTap: _tagAdd,
                child: const Icon(
                  Icons.add_box,
                  color: Colors.blueAccent,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget tag(String tagName) {
    return Container(
      height: 25,
      color: const Color.fromARGB(255, 120, 22, 255),
      padding: const EdgeInsets.all(3),
      child: InkWell(
        onTap: () {
          setState(() {
            _tags.remove(tagName);
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('#$tagName', style: const TextStyle(color: Colors.white)),
            const Padding(
              padding: EdgeInsets.only(left: 5),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _tags.remove(tagName);
                });
              },
              child: const Icon(
                Icons.close,
                size: 12,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _tagAdd() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              height: height * 0.8,
              child: NoteTagSelect(
                tags: _tags,
                submit: (List<String> tags) {
                  setTags(tags);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
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
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
