import 'package:flutter/services.dart';
import 'package:kwh/models/ListItem.dart';
import 'dart:convert';

class ListService {
  Future<List<ListItem>> getListApi() async {
    final String jsonString =
        await rootBundle.loadString("assets/mocks/mock_list_item.json");
    final jsonResult = json.decode(jsonString);
    List<ListItem> lists = [];

    for (Map<String, dynamic> map in jsonResult) {
      lists.add(ListItem.fromJson(map));
    }

    return lists;
  }

  Future<List<String>> searchListTitle(String keyword) async {
    if (keyword.isEmpty) {
      return [];
    }
    final List<ListItem> lists = await getListApi();
    final List<String> result = [];

    for (var element in lists) {
      final String title = element.title;
      if (title.contains(keyword)) {
        result.add(title);
      }
    }

    return result;
  }

  Future<List<ListItem>> searchListItem(String keyword) async {
    if (keyword.isEmpty) {
      return [];
    }
    final List<ListItem> lists = await getListApi();
    final List<ListItem> result = [];

    lists.forEach((element) {
      final String title = element.title;
      if (title.contains(keyword)) {
        result.add(element);
      }
    });

    return result;
  }
}
