import 'package:flutter_test/flutter_test.dart';
import 'package:kwh/models/ListItem.dart';
import 'package:kwh/services/ListService.dart';

void main() {
  test('List Item 错误', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final service = ListService();
    final List<ListItem> lists = await service.getListApi();

    expect(lists, isNotEmpty);
  });
}