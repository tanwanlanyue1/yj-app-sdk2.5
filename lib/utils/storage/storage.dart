import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/* 
  本地存储工具类封装 
*/
class StorageUtil {
  static StorageUtil _instance = new StorageUtil._();
  factory StorageUtil() => _instance;
  static SharedPreferences? _prefs;

  StorageUtil._();

  static Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  // 緩存字符串
  Future<bool>? setString(String key, String val) {
    return _prefs?.setString(key, val);
  }

  // 读取緩存字符串
  dynamic getString(String key) {
    String? Str = _prefs?.getString(key);
    return Str == null ? null : Str;
  }

  // 緩存json
  Future<bool>? setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _prefs?.setString(key, jsonString);
  }

  // 读取緩存json
  dynamic getJSON(String key) {
    String? jsonString = _prefs?.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  // 緩存布尔
  Future<bool>? setBool(String key, bool val) {
    return _prefs?.setBool(key, val);
  }

  // 读取緩存布尔
  bool getBool(String key) {
    bool? val = _prefs?.getBool(key);
    return val == null ? false : val;
  }

  // 移除某个缓存key值
  Future<bool>? remove(String key) {
    return _prefs?.remove(key);
  }
}
