///  intercept.dart
///
///  Created by iotjin on 2020/07/08.
///  description:  拦截器
library;

import 'package:dio/dio.dart';
import 'package:fl_clash/common/app_config.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';

import '../jh_sp_utils.dart';

// default token
const String defaultToken = '';

///获取本地token
String getToken() {
  var resultData = JhSpUtils.getString('token');
  if (resultData != null) {
    return resultData;
  }
  return defaultToken;
}

/// 统一添加身份验证请求头（根据项目自行处理）
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path != AppConfig.apiLogin) {
      final String accessToken = getToken();

      if (accessToken.isNotEmpty) {
        options.headers['Authorization'] = accessToken;
      }
    }
    LogUtil.d(options.headers);
    super.onRequest(options, handler);
  }
}
