import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/LoginUser.dart';

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

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(AUTH_KEY);
    prefs.remove(AUTH_USER);
  }

  static Future<LoginUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString(AUTH_USER);
    if(user == null) {
      return null;
    }

    return LoginUser.fromJson(json.decode(user));
  }

  static Future<void> saveUser(LoginUser user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(AuthService.AUTH_USER, json.encode(user));
    prefs.setString(AuthService.AUTH_KEY, user.idkey);
  }
}