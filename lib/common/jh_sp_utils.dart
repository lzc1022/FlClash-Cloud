///  jh_storage_utils.dart
///
///  Created by iotjin on 2020/05/07.
///  description:  AES 数据存储（封装第三方）
library;

import 'package:flustars_flutter3/flustars_flutter3.dart';

/// 数据存储（不使用AES加密）
class JhSpUtils {
  /// 存 String
  static Future<bool>? saveString(String key, String value) {
    return SpUtil.putString(key, value);
  }

  /// 取 String
  static String? getString(String key) {
    return SpUtil.getString(key);
  }

  /// 存 bool
  static Future<bool>? saveBool(String key, bool value) {
    return SpUtil.putBool(key, value);
  }

  /// 取 bool
  static bool? getBool(String key) {
    return SpUtil.getBool(key);
  }

  /// 存 int
  static Future<bool>? saveInt(String key, int value) {
    return SpUtil.putInt(key, value);
  }

  /// 取 int
  static int? getInt(String key) {
    return SpUtil.getInt(key);
  }

  /// 存 数组
  static Future<bool>? saveList(String key, List<Object> value) {
    return SpUtil.putObjectList(key, value);
  }

  /// 取 数组
  static List? getList(String key) {
    return SpUtil.getObjectList(key);
  }

  /// 存 double
  static Future<bool>? saveDouble(String key, double value) {
    return SpUtil.putDouble(key, value);
  }

  /// 取 double
  static double? getDouble(String key) {
    return SpUtil.getDouble(key);
  }

  /// 存 Map
  static Future<bool>? saveMap(String key, Map<String, dynamic> value) {
    return SpUtil.putObject(key, value);
  }

  /// 存 Model
  static Future<bool>? saveModel(String key, Object model) {
    return SpUtil.putObject(key, model);
  }

  ///获取map
  static Map<String, dynamic>? getMap(String key) {
    var jsonStr = SpUtil.getObject(key);
    if (jsonStr == null || jsonStr.isEmpty) {
      return null;
    } else {
      return jsonStr as Map<String, dynamic>;
    }
  }

  /// 取 Model
  static Map<String, dynamic>? getModel(String key) {
    var jsonStr = SpUtil.getObject(key);
    if (jsonStr == null || jsonStr.isEmpty) {
      return null;
    } else {
      return jsonStr as Map<String, dynamic>;
    }
  }

  /// 移除单个
  static Future<bool>? remove(String key) {
    return SpUtil.remove(key);
  }

  /// 移除所有
  static Future<bool>? clear() {
    return SpUtil.clear();
  }
}

/// AES 加密存储
class JhAesSpUtils {}
