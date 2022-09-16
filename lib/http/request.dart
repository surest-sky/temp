import 'package:dio/dio.dart';
import 'response.dart';

const String baseUrl = "https://kwh-dev.leolan.top/";

Dio http() {
  var request = Dio();
  request.options.baseUrl = baseUrl;
  request.options.connectTimeout = 10000;
  request.options.receiveTimeout = 10000;
  return request;
}

class Request {
  static Future<ResponseMap> post(
      String url, params) async {
    print("url: $url");
    try {
      var responseData = await http().post(url, data: params);
      return _response(responseData.data);
    } catch (e) {
      print(e);
      return ResponseMap(403, "Server", {});
    }
  }

  static ResponseMap _response(Map<String, dynamic> json) {
    try {
      print(json);
      var responseMap = ResponseMap.formJson(json);
      print(responseMap);
      return responseMap;
    } catch (e) {
      print(e);
      return ResponseMap(403, "Server", {});
    }
  }
}
