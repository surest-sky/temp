import 'package:flutter/services.dart';
import 'package:kwh/http/response.dart';
import 'package:kwh/models/ListItem.dart';
import 'package:kwh/models/UserConfig.dart';
import 'dart:convert';

import '../http/apis.dart';

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

  Future<List<ListItem>> searchListItem(String keyword, int page) async {
    if (keyword.isEmpty) {
      return [];
    }
    final Map<String, dynamic> params = {
      "action": "get",
      "kw": keyword,
      "page": page,
      "page_size": 20
    };

    final List<ListItem> lists = await Apis.getListApi(params);
    return lists;
  }

  Future<List<ListItem>> getLastListItem(int page) async {
    final Map<String, dynamic> params = {
      "action": "get",
      "default": "yes",
      "page": page,
      "page_size": 20
    };

    final List<ListItem> lists = await Apis.getLastListApi(params);
    return lists;
  }

  Future<ResponseMap> submit(String text) async {
    final Map<String, dynamic> params = {"action": "push"};
    // 检查是否为url
    if (text.startsWith("http") || text.startsWith("https")) {
      params.addAll({"url": text});
    } else {
      params.addAll({"text": text});
    }
    return await Apis.submitApi(params);
  }

  Future<ResponseMap> submitOcr(String url) async {
    final Map<String, dynamic> params = {"action": "push"};
    params.addAll({"ocr": url});
    return await Apis.submitApi(params);
  }

  Future<ResponseMap> delete(String dataid) async {
    return await Apis.deleteApi(dataid);
  }

  Future<ResponseMap> update(String dataid, String text) async {
    return await Apis.updateApi(dataid, text);
  }

  Future<List<UserConfig>> getUserConfig() async {
    final List<UserConfig> _list = [];
    final map = await Apis.getUserConfigApi();
    if(map.code != 200) {
      return _list;
    }
    final listResult = map.data as List<dynamic>;
    for (var element in listResult) {
      _list.add(UserConfig.fromJson(element));
    }
    return _list;
  }

  Future<ResponseMap> submitConfig(UserConfig config, {String? action}) async {
    final params = {
      "action": config.uId.isNotEmpty ? 'update' : "add",
      "paas":config.paas,
      "status": config.status ? 'on' : 'off',
      "val": config.val,
      "remark": config.remark,
      "sessdata": config.sessdata,
    };

    if(action != null) {
      params['action'] = action;
    }

    if(config.id.isNotEmpty) {
      params['id'] = config.id;
    }
    if(config.id.isNotEmpty) {
      params['u_id'] = config.uId;
    }
    print(params);
    return await Apis.submitConfigApi(params);
  }
}
