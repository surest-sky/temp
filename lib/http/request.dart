import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/services/AuthService.dart';

import 'response.dart';

const String baseUrl = "https://kwh-dev.leolan.top/";

Dio http() {
  var request = Dio();
  request.options.baseUrl = baseUrl;
  request.options.connectTimeout = 10000;
  request.options.receiveTimeout = 10000;
  request.interceptors.add(InterceptorsWrapper(onResponse: (response, handler) {
    if (response.statusCode != 200) {
      EasyLoading.showToast("网络错误");
      return handler.next(response);
    }
    final code = response.data['code'] as int;
    if (code == 401) {
      AuthService.logout();
    }
    return handler.next(response);
  }));
  return request;
}

class Request {
  static Future<ResponseMap> post(String url, params) async {
    try {
      var responseData = await http().post(url, data: params);
      return _response(responseData.data);
    } on DioError catch (e) {
      print("error");
      // print(e.response);
      return ResponseMap(403, "Server", {});
    }
  }

  static Future<ResponseMap> get(
      String url, Map<String, dynamic> params) async {
    try {
      var responseData = await http().get(url, queryParameters: params);
      return _response(responseData.data);
    } catch (e) {
      return ResponseMap(403, "Server", {});
    }
  }

  static ResponseMap _response(Map<String, dynamic> json) {
    try {
      var responseMap = ResponseMap.formJson(json);
      return responseMap;
    } catch (e) {
      print("error");
      print(e.toString());
      return ResponseMap(403, "Server", {});
    }
  }
}
