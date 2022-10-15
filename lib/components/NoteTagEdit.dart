import 'package:flutter/material.dart';

class NoteTagEdit extends StatefulWidget {
  final List<String> tags;

  const NoteTagEdit({Key? key, required this.tags}) : super(key: key);

  @override
  State<NoteTagEdit> createState() => _NoteTagEditState();
}

class _NoteTagEditState extends State<NoteTagEdit> {
  List<String> _tags = ["cc", "测试2", 'add', "cc", "测试2", 'add',"cc", "测试2", 'add'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 5,
      spacing: 10,
      children: _tags.map((name) => tag(name)).toList(),
    );
  }

  Widget tag(String tagName) {
    if (tagName == 'add') {
      return const InkWell(
        child: Icon(
          Icons.add_box,
          color: Colors.blueAccent,
        ),
      );
    }
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
}
