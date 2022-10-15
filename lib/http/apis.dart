import 'package:dio/dio.dart';
import 'package:kwh/services/AuthService.dart';

import '../models/NoteItem.dart';
import 'request.dart';
import 'package:kwh/http/response.dart';
import 'package:kwh/models/LoginUser.dart';

class Apis {
  static const key = "brAPksDiwycS5Vvf1EToGQu3meYxO8lF";
  static Future<LoginUser> loginApi(Map<String, dynamic> params) async {
    const String url = "/v1/login";
    final ResponseMap response;
    final LoginUser result;
    response = await Request.post(url, params);
    if (response.code == 200) {
      result = LoginUser.fromJson(response.data);
    } else {
      result = LoginUser.fromJson({"errorMsg": ""});
    }
    return result;
  }

  static Future<List<NoteItem>> getListApi(Map<String, dynamic> params) async {
    final String idKey = await AuthService.getAuthKey();
    final String url = "/v1/data/$idKey";
    final ResponseMap response;
    final List<NoteItem> result = [];
    response = await Request.post(url, params);
    if(response.data.isEmpty) {
      return result;
    }

    final listResult = response.data as List<dynamic>;
    if (response.code == 200) {
      for (var element in listResult) {
        result.add(NoteItem.fromJson(element));
      }
    }
    return result;
  }

  static Future<List<NoteItem>> getLastListApi(Map<String, dynamic> params) async {
    final String idKey = await AuthService.getAuthKey();
    final String url = "/v1/data/$idKey";
    final ResponseMap response;
    final List<NoteItem> result = [];
    response = await Request.post(url, params);
    if(response.data.isEmpty) {
      return result;
    }

    final listResult = response.data as List<dynamic>;
    if (response.code == 200) {
      for (var element in listResult) {
        result.add(NoteItem.fromJson(element));
      }
    }
    return result;
  }

  static Future<ResponseMap> submitApi(Map<String, dynamic> params) async {
    final String idKey = await AuthService.getAuthKey();
    final String url = "/v1/data/$idKey";
    final ResponseMap response;
    response = await Request.post(url, params);
    return response;
  }

  static Future<ResponseMap> uploadApi(FormData params) async {
    final String idKey = await AuthService.getAuthKey();
    const String url = "/v1/upload_img?key=$key";
    final ResponseMap response;
    response = await Request.post(url, params);
    return response;
  }

  static Future<ResponseMap> uploadFileApi(String base64) async {
    final String idKey = await AuthService.getAuthKey();
    FormData formData = FormData.fromMap({
      "base64_str": base64,
      "idkey": idKey,
      "key": key,
    });
    const String url = "/v1/upload_file_to_oss";
    final ResponseMap response;
    response = await Request.post(url, formData);
    return response;
  }

  static Future<ResponseMap> deleteApi(String dataid) async {
    final String idKey = await AuthService.getAuthKey();
    final String url = "/v1/data/$idKey";
    final ResponseMap response;
    final params = {
      "action": "del",
      "dataid": dataid
    };
    response = await Request.post(url, params);
    return response;
  }


  static Future<ResponseMap> updateApi(String dataid, String text) async {
    final String idKey = await AuthService.getAuthKey();
    final String url = "/v1/data/note/$dataid";
    final ResponseMap response;
    final params = {
      "action": "update",
      "idkey": idKey,
      "text": text
    };
    response = await Request.post(url, params);
    return response;
  }

  static Future<ResponseMap> getUserConfigApi() async {
    final String idKey = await AuthService.getAuthKey();
    const String url = "/v1/user_conf_status";
    final ResponseMap response;
    response = await Request.get(url, {
      "idkey": idKey,
    });
    return response;
  }

  static Future<ResponseMap> submitConfigApi(params) async {
    final String idKey = await AuthService.getAuthKey();
    params['idkey'] = idKey;
    const String url = "/v1/user_conf";
    final ResponseMap response;
    response = await Request.post(url, params);
    return response;
  }

  static Future<ResponseMap> updateUserApi(params) async {
    params['key'] = key;
    const String url = "/v1/users";
    final ResponseMap response;
    response = await Request.post(url, params);
    return response;
  }

  static Future<ResponseMap> getUserApi(params) async {
    params['key'] = key;
    const String url = "/v1/users";
    final ResponseMap response;
    response = await Request.post(url, params);
    return response;
  }

  static Future<ResponseMap> getAllTagsApi() async {
    final String idKey = await AuthService.getAuthKey();
    FormData params = FormData.fromMap({
      "idkey": idKey,
    });
    const String url = "/v1/get_user_all_tags";
    final ResponseMap response;
    response = await Request.post(url, params);
    return response;
  }

  static Future<ResponseMap> getTagListApi(String tag) async {
    final String idKey = await AuthService.getAuthKey();
    FormData params = FormData.fromMap({
      "idkey": idKey,
      "tag": tag,
    });
    const String url = "/v1/search_tag";
    final ResponseMap response;
    response = await Request.post(url, params);
    return response;
  }

  static Future<ResponseMap> getShowDataApi(String dataId) async {
    final String idKey = await AuthService.getAuthKey();
    final params = {
      "action": "get",
      "dataid": dataId,
    };
    final String url = "/v1/data/$idKey";
    final ResponseMap response;
    response = await Request.post(url, params);
    return response;
  }

}
