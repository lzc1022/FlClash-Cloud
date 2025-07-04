import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/event_bus/event_bus.dart';
import 'base_controller.dart';

/// BaseControllerMixin
mixin BaseControllerMixin on BaseGetController {
  /// 是否监听生命周期
  bool get listenLifecycleEvent => false;

  //late StreamSubscription refreshUiSubscription;

  StreamSubscription? lifecycleSubscription;

  @override
  void onInit() {
    super.onInit();
    // refreshUiSubscription = eventListen<RefreshUiEvent>((event) {
    //   // 延时刷新UI
    //   delayed(300, () {
    //     GlobalService.to.updateNavigationBar();
    //     updateUi();
    //   });
    // });
    if (listenLifecycleEvent) {
      lifecycleSubscription = eventListen<LifecycleEvent>((event) {
        switch (event.state) {
          case AppLifecycleState.resumed:
            onResumed();
            break;
          case AppLifecycleState.inactive:
            onInactive();
            break;
          case AppLifecycleState.detached:
            onDetached();
            break;
          case AppLifecycleState.paused:
            onPaused();
            break;
          case AppLifecycleState.hidden:
            onHidden();
            break;
        }
      });
    }
  }

  void onResumed() {}

  void onInactive() {}

  void onDetached() {}

  void onPaused() {}

  void onHidden() {}

  @override
  void onClose() {
    // refreshUiSubscription.cancel();
    lifecycleSubscription?.cancel();
    super.onClose();
  }

  /// 返回
  void back() {
    Get.back();
  }

  /// 延时退出
  void delayedBack({int seconds = 2, result}) {
    Future.delayed(Duration(seconds: seconds), () {
      if (result != null) {
        Get.back(result: result);
      } else {
        Get.back();
      }
    });
  }
}
