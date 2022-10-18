import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:kwh/http/response.dart';
import 'package:kwh/models/LoginUser.dart';
import 'package:kwh/models/NoteItem.dart';
import 'package:kwh/models/TagChunkNoteItem.dart';
import 'package:kwh/models/UserConfig.dart';
import 'package:kwh/services/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http/apis.dart';

class NoteService {
  Future<List<NoteItem>> getListApi() async {
    final String jsonString =
        await rootBundle.loadString("assets/mocks/mock_list_item.json");
    final jsonResult = json.decode(jsonString);
    List<NoteItem> lists = [];

    for (Map<String, dynamic> map in jsonResult) {
      lists.add(NoteItem.fromJson(map));
    }

    return lists;
  }

  Future<List<String>> searchListTitle(String keyword) async {
    if (keyword.isEmpty) {
      return [];
    }
    final List<NoteItem> lists = await getListApi();
    final List<String> result = [];

    for (var element in lists) {
      final String title = element.title;
      if (title.contains(keyword)) {
        result.add(title);
      }
    }

    return result;
  }

  Future<List<NoteItem>> searchNoteItem(String keyword, int page) async {
    if (keyword.isEmpty) {
      return [];
    }
    final Map<String, dynamic> params = {
      "action": "get",
      "kw": keyword,
      "page": page,
      "page_size": 20
    };

    final List<NoteItem> lists = await Apis.getListApi(params);
    return lists;
  }

  Future<List<NoteItem>> getLastNoteItem(int page) async {
    final Map<String, dynamic> params = {
      "action": "get",
      "default": "yes",
      "page": page,
      "page_size": 20
    };

    final List<NoteItem> lists = await Apis.getLastListApi(params);
    return lists;
  }

  Future<List<TagChunkNoteItem>> getTagsChunkItem() async {
    final List<NoteItem> tempList = await getLastNoteItem(1);
    final Map<String, List<NoteItem>> _chunkList = {};
    final List<TagChunkNoteItem> _list = [];
    // 实际分割
    tempList.forEach((element) {
      final _date = formatDate(
          DateTime.parse(element.updatedAt), [yyyy, '-', mm, '-', dd]);
      if (_chunkList.containsKey(_date)) {
        _chunkList[_date]?.add(element);
      } else {
        _chunkList[_date] = [element];
      }
    });

    _chunkList.forEach(
        (key, value) => {_list.add(TagChunkNoteItem.fromJson(key, value))});

    return _list;
  }

  Future<ResponseMap> submit(String text, {String? type, required List<String> tags, required String remark}) async {
    final Map<String, dynamic> params = {"action": "push"};
    // 检查是否为url
    if (type == null) {
      if (text.startsWith("http") || text.startsWith("https")) {
        params.addAll({"url": text});
      } else {
        params.addAll({"text": text});
      }
    } else {
      params.addAll({type: text});
    }
    params.addAll({"tags": tags.map((e) => "#$e").join() });
    params.addAll({"remark": remark});
    print(params);
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
    if (map.code != 200) {
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
      "paas": config.paas,
      "status": config.status ? 'on' : 'off',
      "val": config.val,
      "remark": config.remark,
      "sessdata": config.sessdata,
    };

    if (action != null) {
      params['action'] = action;
    }

    if (config.id.isNotEmpty) {
      params['id'] = config.id;
    }
    if (config.id.isNotEmpty) {
      params['u_id'] = config.uId;
    }
    return await Apis.submitConfigApi(params);
  }

  Future<ResponseMap> updateUser(LoginUser user,
      {bool isUpdateKey = false}) async {
    final params = {
      "action": "update",
      "name": user.name,
      "avatar": user.avatar,
    };

    params['email'] = user.email;
    params['phone'] = user.phone;
    params['update_idkey'] = isUpdateKey ? "yes" : "no";

    return await Apis.updateUserApi(params);
  }

  Future<LoginUser> getUser(
    String phone,
  ) async {
    final params = {"action": "get", "phone": phone};

    final response = await Apis.getUserApi(
      params,
    );
    final user = LoginUser.fromJson(response.data);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthService.AUTH_USER, json.encode(user));
    return user;
  }

  Future<ResponseMap> uploadFile(String fileName) async {
    final params = {"file_name": fileName};

    return await Apis.updateUserApi(params);
  }

  Future<List<String>> getAllTags() async {
    final ResponseMap response = await Apis.getAllTagsApi();
    if (response.code != 200) {
      return [];
    }
    final _data = response.data['tags_list'] as List;
    return _data.map((e) => e.toString()).toList();
  }

  Future<ResponseMap> getShowData(String dataId) async {
    final ResponseMap response = await Apis.getShowDataApi(dataId);
    return response;
  }

  Future<List<NoteItem>> getTagList(String tag) async {
    final ResponseMap response = await Apis.getTagListApi(tag);
    if (response.code != 200) {
      return [];
    }

    final _data = response.data['data_list'] as List;
    final List<NoteItem> _lists = [];
    _data.forEach((tagItem) {
      final _item = tagItem['tag_data'];
      _lists.add(NoteItem.fromJson(_item));
    });

    return _lists;
  }
}
