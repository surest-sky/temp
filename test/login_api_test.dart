import 'package:flutter_test/flutter_test.dart';
import 'package:kwh/http/apis.dart';
import 'package:kwh/models/LoginModel.dart';

void main() {
  test('登录成功', () async {
    const Map<String, String> loginParms = {
      "remark": "支持email或者phone+密码或者验证码登陆。（拿到idkey就等于可以操作用户的数据了）",
      "phone": "17688762468",
      "email": "",
      "pw": "123456789",
      "sms_code": "",
      "email_code": ""
    };
    final LoginModel result;
    result = await Apis.loginApi(loginParms);
    expect(result.name?.isNotEmpty, true);
  });

  test('登录失败', () async {
    const Map<String, String> loginParms = {
      "remark": "支持email或者phone+密码或者验证码登陆。（拿到idkey就等于可以操作用户的数据了）",
      "phone": "17688762468",
      "email": "",
      "pw": "12345679",
      "sms_code": "",
      "email_code": ""
    };
    final LoginModel result;
    result = await Apis.loginApi(loginParms);
    expect(result.errorMsg.isNotEmpty, true);
  });
}
