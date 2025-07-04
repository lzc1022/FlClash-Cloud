///  http_utils.dart
///
///  Created by iotjin on 2020/07/07.
///  description: 网络请求工具类（dio二次封装）
library;

// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:dio/dio.dart';

import '../app_config.dart';
import '../log_utils.dart';
import 'dio_utils.dart';
import 'function.dart';
import 'intercept.dart';
import 'toast_util.dart';

// 日志开关
const bool isOpenLog = true;
const bool isOpenAllLog = false;

class HttpUtils {
  /// dio main函数初始化
  static void initDio() async {
    final List<Interceptor> interceptors = <Interceptor>[];

    /// 统一添加身份验证请求头
    interceptors.add(AuthInterceptor());

    configDio(
      baseUrl: AppConfig.wpApiBaseUrl,
      interceptors: interceptors,
    );
  }

  static setBaseUrl(String baseUrl) {
    DioUtils.instance.dio.options.baseUrl = baseUrl;
    // 重新初始化 Dio
    HttpUtils.initDio();
  }

  /// get 请求
  static void get<T>(
    String url,
    Map<String, dynamic>? params, {
    String? loadingText,
    Success? success,
    Fail? fail,
  }) {
    request(Method.get, url, params,
        loadingText: loadingText, success: success, fail: fail);
  }

  /// post 请求
  static void post<T>(String url, params,
      {String? loadingText, Success? success, Fail? fail}) {
    request(Method.post, url, params,
        loadingText: loadingText, success: success, fail: fail);
  }

  /// 上传多个图片
  static void uploadImages(
    String url,
    List<String> imageFiles, {
    String? loadingText,
    Success? success,
    Fail? fail,
  }) async {
    if (loadingText != null && loadingText.isNotEmpty) {
      ToastUtils.show(loadingText);
    }
    try {
      // 创建 FormData
      FormData formData = FormData();

      // 发送请求
      var response = await DioUtils.instance.request(
        Method.post,
        url,
        data: formData,
      );
      // 处理返回数据
      if (response['code'] == 10000) {
        success?.call(response);
      } else {
        ToastUtils.toast(response['message']);
        fail?.call(response['code'], response['message']);
      }
    } catch (e) {
      ToastUtils.toast("上传失败: ${e.toString()}");
      fail?.call(-1, "上传失败: ${e.toString()}");
    } finally {
      if (loadingText != null && loadingText.isNotEmpty) {
        ToastUtils.dismiss();
      }
    }
  }

  /// 下载文件
  static Future<void> downloadFile(
    String url,
    String savePath, {
    String? loadingText,
    Success? success,
    Fail? fail,
  }) async {
    if (loadingText != null && loadingText.isNotEmpty) {
      ToastUtils.show(loadingText);
    }

    try {
      // 创建 Dio 实例
      Dio dio = Dio();

      // 开始下载
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // 计算下载进度
            double progress = received / total;
            print("下载进度: ${(progress * 100).toStringAsFixed(0)}%");
          }
        },
      );

      // 下载成功
      success?.call("文件下载成功，保存路径: $savePath");
    } catch (e) {
      // 处理错误
      ToastUtils.toast("下载失败: ${e.toString()}");
      fail?.call(-1, "下载失败: ${e.toString()}");
    } finally {
      if (loadingText != null && loadingText.isNotEmpty) {
        ToastUtils.dismiss();
      }
    }
  }

  /// _request 请求
  static void request<T>(
    Method method,
    String url,
    params, {
    String? loadingText = '加载中...',
    Success? success,
    Fail? fail,
  }) {
    // 参数处理（如果需要加密等统一参数）
    if (isOpenLog) {
      print('---------- 域名----------');
      print(AppConfig.wpApiBaseUrl);
      print('---------- HttpUtils URL ----------');
      print(url);
      print('---------- HttpUtils params ----------');
      print(params);
    }

    Object? data;
    Map<String, dynamic>? queryParameters;
    // 处理参数
    if (method == Method.get) {
      queryParameters = params;
    }
    if (method == Method.post) {
      data = params;
    }
    print('传递参数打印$params');
    if (loadingText != null && loadingText.isNotEmpty) {
      ToastUtils.show(loadingText);
    }
    DioUtils.instance.request(method, url,
        data: data, queryParameters: queryParameters, onSuccess: (result) {
      if (isOpenLog) {}
      if (loadingText != null && loadingText.isNotEmpty) {
        ToastUtils.dismiss();
      }

      /// 处理返回数据字符串转化为json对象
      if (result is String) {
        result = jsonDecode(result);
      }
      LogUtils.d('打印结果$result');
      if (result['status'] == "success" || result['data'] != null) {
        success?.call(result);
      } else {
        //其他状态，弹出错误提示信息
        if (result['message'] != null) {
          ToastUtils.toast(result['message']);
          fail?.call(500, result['message']);
        }
      }
    }, onError: (code, msg) {
      if (loadingText != null && loadingText.isNotEmpty) {
        ToastUtils.dismiss();
      }
      if (url.contains('auth/register')) {
        // 401 未登录，跳转到登录页面
      } else {
        ToastUtils.toast(msg);
      }

      fail?.call(code, msg);
    });
  }
}
