///  dio_utils.dart
///
///  Created by iotjin on 2020/07/06.
///  description:  dio工具类
library;

import 'package:dio/dio.dart';

import '../app_config.dart';
import 'error_handle.dart';

/// 默认dio配置
String _baseUrl = AppConfig.wpApiBaseUrl;
Duration _connectTimeout = const Duration(seconds: 20);
Duration _receiveTimeout = const Duration(seconds: 20);
Duration _sendTimeout = const Duration(seconds: 10);
List<Interceptor> _interceptors = [];
// const httpHeaders = {
//   'Accept': 'application/json, text/plain, */*',
//   'Accept-Encoding': 'gzip, deflate, br',
//   'Accept-Language': 'zh-CN,zh;q=0.9',
//   'Connection': 'keep-alive',
//   'Content-Type': 'application/json',
//   'User-Agent':
//       'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1',
// };

typedef NetSuccessCallback<T> = Function(T data);
typedef NetSuccessListCallback<T> = Function(List<T> data);
typedef NetErrorCallback = Function(int code, String msg);

/// 初始化Dio配置
void configDio({
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
  String? baseUrl,
  List<Interceptor>? interceptors,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
}

class DioUtils {
  factory DioUtils() => _singleton;

  DioUtils._() {
    // 全局属性：请求前缀、连接超时时间、响应超时时间
    final BaseOptions options = BaseOptions(
      responseType: ResponseType.json,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: _baseUrl,
      headers: _httpHeaders,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
    );

    _dio = Dio(options);
    //添加拦截器
    void addInterceptor(Interceptor interceptor) {
      _dio.interceptors.add(interceptor);
    }

    _interceptors.forEach(addInterceptor);
  }

  static final DioUtils _singleton = DioUtils._();

  static DioUtils get instance => DioUtils();

  static late Dio _dio;

  Dio get dio => _dio;

  Future request<T>(
    Method method,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    NetSuccessCallback? onSuccess,
    NetErrorCallback? onError,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      // 没有网络
      // var connectivityResult = await (Connectivity().checkConnectivity());
      // if (connectivityResult.first == ConnectivityResult.none) {
      //   _onError(ExceptionHandle.net_error, '网络异常，请检查你的网络！', onError);
      //   return;
      // }
      final Response response = await _dio.request<T>(
        url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(_methodValues[method], options),
        cancelToken: cancelToken,
      );
      print('信息：${response.data}');

      if (response.statusCode == 200) {
        onSuccess?.call(response.data);
        return response.data;
      } else {
        final msg = response.data['message'];
        _onError(response.statusCode, msg, onError);
      }
    } on DioException catch (e) {
      onError?.call(10086, '加载失败');
      final NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    }
  }
}

Options _checkOptions(String? method, Options? options) {
  options ??= Options();
  options.method = method;
  return options;
}

void _onError(int? code, String msg, NetErrorCallback? onError) {
  if (code == null) {
    code = ExceptionHandle.unknown_error;
    msg = '未知异常';
  }

  onError?.call(code, msg);
}

/// 自定义Header
Map<String, dynamic> _httpHeaders = {
  'Accept': 'application/json,*/*,charset=utf-8',
  'Content-Type': 'application/json',
};

enum Method { get, post, put, patch, delete, head }

/// 使用：_methodValues[Method.post]
const _methodValues = {
  Method.get: 'get',
  Method.post: 'post',
  Method.delete: 'delete',
  Method.put: 'put',
  Method.patch: 'patch',
  Method.head: 'head',
};
