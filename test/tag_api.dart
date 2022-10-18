import 'package:flutter_test/flutter_test.dart';
import 'package:kwh/models/TagChunkNoteItem.dart';
import 'package:kwh/services/NoteService.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('获取Tags', () async {
    SharedPreferences.setMockInitialValues(
        {"authToken": '16641Zg1gEdHMzo78119'});
    // TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final service = NoteService();
    final List<TagChunkNoteItem> tempList = await service.getTagsChunkItem();
    tempList.forEach((element) {
      print(element.chunkDate);
      print(element.notes);
    });
    expect(tempList, isNotEmpty);
  });

  test('获取TagsList', () async {
    SharedPreferences.setMockInitialValues(
        {"authToken": '16641Zg1gEdHMzo78119'});
    // TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final service = NoteService();
    final tempList = await service.getTagList("开发");
    tempList.forEach((element) {
      print(element);
    });
    expect(tempList, isNotEmpty);
  });
}
