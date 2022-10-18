import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/typography/gf_typography.dart';
import 'package:getwidget/types/gf_typography_type.dart';
import 'package:kwh/components/Skeleton.dart';
import 'package:kwh/models/NoteItem.dart';
import 'package:kwh/services/NoteService.dart';
import 'package:kwh/widgets//well_icon.dart';
import 'package:kwh/widgets/well_title.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../components/HomeItemSheet.dart';
import '../../models/TagChunkNoteItem.dart';
import '../../styles/styles.dart';

class TagsManagerPage extends StatefulWidget {
  const TagsManagerPage({Key? key}) : super(key: key);

  @override
  State<TagsManagerPage> createState() => _TagsManagerPageState();
}

class _TagsManagerPageState extends State<TagsManagerPage> {
  List<String> tags = [];
  late EasyRefreshController _controller;
  late ScrollController _scrollController;
  List<TagChunkNoteItem> lists = [];
  final service = NoteService();
  bool tags_loading = true;
  bool lists_loading = true;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    _loadData();
  }

  Future _loadData() async {
    await service
        .getTagsChunkItem()
        .then((_lists) => {
              setState(() {
                lists = _lists;
              })
            })
        .whenComplete(() => setState(() {
              lists_loading = false;
            }));

    service
        .getAllTags()
        .then((_tags) => {
              setState(() {
                tags = _tags;
              })
            })
        .whenComplete(() => {
              setState(() {
                tags_loading = false;
              })
            });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('归档'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                GFTypography(
                  type: GFTypographyType.typo6,
                  dividerWidth: 40,
                  dividerColor: Color(0xFF19CA4B),
                  child: Row(
                    children: [
                      const Icon(Icons.sell, size: 16),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '标签',
                        style: hintStyleTextblack(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                tags_loading
                    ? const Skeleton(count: 1)
                    : Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        children: tags.map<Widget>(
                          (tag) {
                            return Container(
                              color: Colors.grey.shade200,
                              padding: const EdgeInsets.all(6),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    "tagPage",
                                    arguments: tag,
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '#$tag',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    // const Text(
                                    //   "10",
                                    //   style: TextStyle(color: Colors.orange),
                                    // )
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                const SizedBox(
                  height: 20,
                ),
                GFTypography(
                  type: GFTypographyType.typo6,
                  dividerWidth: 40,
                  dividerColor: Color(0xFF19CA4B),
                  child: Row(
                    children: [
                      const Icon(Icons.line_axis, size: 16),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '历史',
                        style: hintStyleTextblack(),
                      )
                    ],
                  ),
                ),
                Column(
                  children: lists_loading
                      ? [
                          const SizedBox(height: 10),
                          const Skeleton(count: 5),
                        ]
                      : lists.map((e) => noteTagItem(e)).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noteTagItem(TagChunkNoteItem tagItem) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tagItem.chunkDate),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tagItem.notes.map((e) => noteItem(e)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget noteItem(NoteItem item) {
    return InkWell(
      onTap: () {
        showBarModalBottomSheet(
          expand: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => HomeItemSheet(
            item: item,
          ),
        );
      },
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            WellIcon(item: item),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: WellTitle(item: item),
            )
          ],
        ),
      ),
    );
  }
}
