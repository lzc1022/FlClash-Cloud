import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../ex_decoration.dart';
import '../jh_screen_utils.dart';

///弹框通用
class JhDialogComm {
  // 标准 - Alert - 模式对话框
  static normal({
    Widget? child,
    String? title,
    String? content,
    void Function()? onTap,
  }) {
    if (child != null) {
      SmartDialog.show(
          alignment: Alignment.center,
          builder: (_) {
            return child;
          });
    }
    return SmartDialog.show(builder: (_) {
      return Container(
        width: JhScreenUtils.screenWidth - 40,
        padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: JhScreenUtils.bottomSafeHeight),
        decoration: BoxDecorationExtension.circularBorder(
            radius: 10, backgroundColor: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? '提示',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(content ?? '你确定要删除吗？', style: const TextStyle(fontSize: 18)),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      SmartDialog.dismiss();
                      onTap?.call();
                    },
                    child: Container(
                      color: Colors.white,
                      child: const Text('确定',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.red)),
                    ),
                  ),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () => SmartDialog.dismiss(),
                  child: const Text('取消',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.red)),
                )),
              ],
            )
          ],
        ),
      );
    });
  }

  //支付弹框
  static payAlert({
    Widget? child,
    String? title,
    String? content,
    void Function()? onTap,
  }) {
    if (child != null) {
      SmartDialog.show(
          alignment: Alignment.center,
          builder: (_) {
            return child;
          });
    }
    return Container();
  }

  // 标准 - 底部弹出 - 模式对话框
  static bottomSheet({
    Widget? child,
  }) {
    if (child != null) {
      SmartDialog.show(
          alignment: Alignment.bottomCenter,
          builder: (_) {
            return child;
          });
    }
    return SmartDialog.show(
        alignment: Alignment.bottomCenter,
        builder: (_) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: JhScreenUtils.bottomSafeHeight),
            decoration: BoxDecorationExtension.circularBorderTop(
                radius: 10, backgroundColor: Colors.white),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '确定',
                  textAlign: TextAlign.center,
                ),
                Text('取消'),
              ],
            ),
          );
        });
  }
}
