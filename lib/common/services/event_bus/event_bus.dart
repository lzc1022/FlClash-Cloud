// ignore: file_names
import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

///各种通知处理
EventBus eventBus = EventBus();

/// 监听事件总线
StreamSubscription<T> eventListen<T>(
  void Function(T)? onData, {
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
}) {
  return eventBus.on<T>().listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}

/// 发送事件总线
sendEvent<T>(T event) {
  eventBus.fire(event);
}

class UserLoginEvent {
  String name;
  UserLoginEvent(this.name);
}

//订阅通知
class UpdateSubscribeEvent {
  String name;
  UpdateSubscribeEvent(this.name);
}

/// 生命周期事件
class LifecycleEvent {
  final AppLifecycleState state;
  LifecycleEvent(this.state);
}
