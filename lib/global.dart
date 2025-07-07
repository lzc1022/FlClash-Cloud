import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:idkit/idkit.dart';

import 'common/api/index.dart';
import 'common/app_config.dart';
import 'common/dio_http/http_utils.dart';
import 'common/dio_http/toast_util.dart';
import 'common/services/event_bus/event_bus.dart';
import 'common/services/user_info_model/user_info.dart';
import 'common/url_check.dart';

/// 全局配置类
/// 负责应用程序的初始化配置、系统UI设置和生命周期管理
class Global {
  static StreamSubscription? _connectivitySubscription;

  /// 全局初始化
  /// 在应用启动时调用，完成所有必要的初始化工作
  static Future<void> init() async {
    try {
      // // 等待Flutter初始化完成
      // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      //显示状态栏
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
      );

      // 初始化系统UI设置
      await _initSystemUI();
      // 初始化日志
      await _initLogger();
      // 初始化其他服务
      await _initServices();
      //获取IP
      await getIPAddress();
    } catch (e) {
      // IDKitLog.error('Global initialization failed: $e');
      rethrow;
    }
  }

  /// 初始化日志系统
  static Future<void> _initLogger() async {
    IDKitLog.init(
      option: const LogOption(
        isEnable: true,
        colorTheme: ColorTheme.red,
        language: Language.zh,
      ),
    );
  }

  static Future<String> getIPAddress() async {
    Dio dio = Dio();
    try {
      final result = await dio.get('https://ipinfo.io/json');
      if (result.statusCode == 200) {
        UserInfo.instance.ip = result.data['ip'];
        if (kDebugMode) {
          print('📶 获取到的公网IP地址: ${result.data}');
        }
        return result.data.toString();
      }
    } catch (e) {
      // IDKitLog.error('Failed to get IP address: $e');
    }
    return '';
  }

  /// 更新可用域名
  static Future<void> _updateAvailableUrl() async {
    try {
      final checker = UrlChecker();
      var availableUrl = await checker.findFirstAvailableUrlFromJson(
        AppConfig.appApi,
      );
      if (availableUrl != null) {
        if (kDebugMode) {
          print('🎯 可用地址: $availableUrl');
        }

        // 先更新配置
        AppConfig.wpApiBaseUrl = 'https://v2.dsoanf.xyz/';

        // 确保 URL 格式正确
        if (!availableUrl.endsWith('/')) {
          availableUrl = 'https://v2.dsoanf.xyz/';
        }
        if (kDebugMode) {
          print('✅ 域名更新成功');
        }
      } else {
        if (kDebugMode) {
          print('😢 没有可用地址');
        }
        ToastUtils.toast('😢 没有可用地址');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 更新域名失败: $e');
      }
      ToastUtils.toast('更新域名失败');
    }
  }

  /// 初始化各项服务
  static Future<void> _initServices() async {
    await SpUtil.getInstance();
    await _updateAvailableUrl();
    HttpUtils.initDio();
    ToastUtils.init();
    Get.put<HomeApi>(HomeApi());
    Get.put(WidgetsObserver());
  }

  /// 系统UI初始化
  static Future<void> _initSystemUI() async {
    if (!GetPlatform.isMobile) return;
    // 设置屏幕方向
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (GetPlatform.isAndroid) {
      await _setAndroidSystemUI();
    } else {
      await _setDefaultSystemUI();
    }
  }

  /// Android 特定的系统UI设置
  static Future<void> _setAndroidSystemUI() async {
    const systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    );

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  /// 默认系统UI设置
  static Future<void> _setDefaultSystemUI() async {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  /// 释放资源
  static void dispose() {
    _connectivitySubscription?.cancel();
  }
}

class WidgetsObserver with WidgetsBindingObserver {
  static final WidgetsObserver _instance = WidgetsObserver._internal();
  factory WidgetsObserver() {
    return _instance;
  }
  static WidgetsObserver get instance => _instance;
  WidgetsObserver._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// 监听应用生命周期并发送给全部页面
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    sendEvent(LifecycleEvent(state));
  }
}
