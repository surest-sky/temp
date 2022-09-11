import 'request.dart';
import 'package:kwh/http/response.dart';
import 'package:kwh/models/LoginModel.dart';

class Apis {
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
}
