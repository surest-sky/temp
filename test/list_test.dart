import 'package:flutter_test/flutter_test.dart';
import 'package:kwh/models/NoteItem.dart';
import 'package:kwh/services/NoteService.dart';

void main() {
  // test('List Item 错误', () async {
  //   TestWidgetsFlutterBinding.ensureInitialized();
  //   final service = NoteService();
  //   final List<NoteItem> lists = await service.getListApi();
  //
  //   expect(lists, isNotEmpty);
  // });

  test('Home Search', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final service = NoteService();
    final List<NoteItem> tempList = await service.searchNoteItem("git", 1);

    expect(tempList, isNotEmpty);
  });
}
