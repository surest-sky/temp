import 'package:dio/dio.dart';
import 'package:kwh/services/AuthService.dart';

import '../models/ListItem.dart';
import 'request.dart';
import 'package:kwh/http/response.dart';
import 'package:kwh/models/LoginModel.dart';

class Apis {
  static const key = "brAPksDiwycS5Vvf1EToGQu3meYxO8lF";
  static Future<LoginModel> loginApi(Map<String, dynamic> params) async {
    const String url = "/v1/login";
    final ResponseMap response;
    final LoginModel result;
    response = await Request.post(url, params);
    if (response.code == 200) {
      result = LoginModel.fromJson(response.data);
    } else {
      result = LoginModel(errorMsg: response.message);
    }
    return result;
  }

  static Future<List<ListItem>> getListApi(Map<String, dynamic> params) async {
    final String idKey = await AuthService.getAuthKey();
    final String url = "/v1/data/$idKey";
    final ResponseMap response;
    final List<ListItem> result = [];
    response = await Request.post(url, params);
    if(response.data.isEmpty) {
      return result;
    }

    final listResult = response.data as List<dynamic>;
    if (response.code == 200) {
      for (var element in listResult) {
        result.add(ListItem.fromJson(element));
      }
    }
    return result;
  }

  static Future<List<ListItem>> getLastListApi(Map<String, dynamic> params) async {
    final String idKey = await AuthService.getAuthKey();
    final String url = "/v1/data/$idKey";
    final ResponseMap response;
    final List<ListItem> result = [];
    response = await Request.post(url, params);
    if(response.data.isEmpty) {
      return result;
    }

    final listResult = response.data as List<dynamic>;
    if (response.code == 200) {
      for (var element in listResult) {
        result.add(ListItem.fromJson(element));
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
    const String url = "/v1/upload_file?key=$key";
    final ResponseMap response;
    response = await Request.post(url, params);
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
    print("delete: $dataid");
    print("idKey: $idKey");
    response = await Request.post(url, params);
    print(response.toJson());
    return response;
  }
}
