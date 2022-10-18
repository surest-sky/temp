import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ShareService {
  static String SHARE_KEY = "share_text";

  static Future<void> setShareValue(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SHARE_KEY, value);
  }

  static Future<String> getShareValue() async {
    final prefs = await SharedPreferences.getInstance();
    final r = prefs.getString(SHARE_KEY) ?? "";
    prefs.remove(SHARE_KEY);
    return r;
  }
}