import 'package:dio/dio.dart';
import 'package:tutor_page_h5/http/response.dart';
import './response.dart';

const String baseUrl = "https://api.tutorpage.net/api";

Dio request() {
  var request = Dio();
  request.options.baseUrl = baseUrl;
  request.options.connectTimeout = 5000;
  request.options.receiveTimeout = 3000;
  return request;
}

Future<ResponseMap> loginApi(Map<String, String> params) async {
  try {
    var responseData = await request().post('/auth/login', data: params);
    var responseMap = ResponseMap.formJson(responseData.data);
    return responseMap;
  } catch (e) {
    return ResponseMap(403, "Server", {});
  }
}
