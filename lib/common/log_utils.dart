///  intercept.dart
///
///  Created by iotjin on 2020/07/09.
///  description:  输出Log日志工具类

import 'package:flutter/foundation.dart';
import 'package:idkit/idkit.dart';

class LogUtils {
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = kReleaseMode;

  /// 是否开启fconsole
  static const bool inOpenFConsole = true;

  static void d(dynamic msg) {
    if (!inProduction) {
      IDKitLog.json(msg);
    }
  }
}
