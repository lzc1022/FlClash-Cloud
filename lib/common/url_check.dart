import 'dart:async';

import 'package:dio/dio.dart';

class UrlChecker {
  final Dio _dio;
  final int maxRetries;
  final Duration timeout;

  UrlChecker({
    this.maxRetries = 3,
    Duration? timeout,
  })  : _dio = Dio(BaseOptions(
          connectTimeout: timeout ?? const Duration(seconds: 30),
          receiveTimeout: timeout ?? const Duration(seconds: 30),
        )),
        timeout = timeout ?? const Duration(seconds: 30);

  /// 主方法：从 JSON 地址获取 URL 列表，返回第一个可用的 URL
  Future<String?> findFirstAvailableUrlFromJson(String jsonUrl) async {
    print('>>> [DEBUG] findFirstAvailableUrlFromJson called, url=$jsonUrl');
    try {
      final response = await _dio.get(jsonUrl);

      if (response.statusCode == 200 && response.data is List) {
        List urls = response.data;

        final completer = Completer<String?>();

        for (var element in urls) {
          String? url = element['url'];
          if (url == null) continue;

          _tryUrlWithRetries(url).then((success) {
            if (success && !completer.isCompleted) {
              completer.complete(url);
            }
          });
        }

        return await completer.future.timeout(const Duration(seconds: 15),
            onTimeout: () {
          print('⚠️ 检查超时');
          return null;
        });
      }
    } catch (e, s) {
      print('❌ [DEBUG] 请求 JSON 失败: $e');
      print('❌ [DEBUG] Stack: $s');
    }
    return null;
  }

  /// 内部方法：尝试一个 URL，多次重试
  Future<bool> _tryUrlWithRetries(String url) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        print('🌐 尝试 [$url] 第 ${i + 1} 次');
        final res = await _dio.get(
          url,
          options: Options(
            followRedirects: true,
            validateStatus: (status) => true,
          ),
        );
        if (res.statusCode == 200) {
          print('✅ 成功: $url');
          return true;
        } else {
          print('❌ 状态码 ${res.statusCode}: $url');
        }
      } catch (e) {
        print('❌ 异常: $url -> $e');
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
    return false;
  }
}
