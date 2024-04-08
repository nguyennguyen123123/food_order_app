import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Bộ nhớ cục bộ
class LocalStorage {
  static LocalStorage _instance = new LocalStorage._();
  factory LocalStorage() => _instance;
  static late SharedPreferences _prefs;

  LocalStorage._();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _prefs.setString(key, jsonString);
  }

  dynamic getJSON(String key) {
    String? jsonString = _prefs.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  Future<bool> setBool(String key, bool val) {
    return _prefs.setBool(key, val);
  }

  bool getBool(String key) {
    bool? val = _prefs.getBool(key);
    return val ?? false;
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  //get và set String
  Future<void> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  //get và set int
  Future<void> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  int getInt(String key) {
    return _prefs.getInt(key) ?? 0;
  }
}
