import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String AUTH_KEY = "authToken";
  static String AUTH_USER = "authUser";

  static Future<bool> isLogin() async {
    final idKey = await getAuthKey();
    return idKey.isNotEmpty;
  }

  static Future<String> getAuthKey() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.setString(AUTH_KEY, "你好");
    return prefs.getString(AUTH_KEY) ?? '';
  }
}