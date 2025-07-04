///  jh_count_down_btn.dart
///
///  Created by iotjin on 2020/04/07.
///  description:  倒计时按钮
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'kcolors.dart';

const String _normalText = '获取验证码'; // 默认按钮文字
const String _resendAfterText = '重新获取'; // 重新获取文字
const int _normalTime = 60; // 默认倒计时时间
const double _fontSize = 13.0; // 文字大小
const double _borderWidth = 0.8; // 边框宽度
const double _borderRadius = 1.0; // 边框圆角

class JhCountDownBtn extends StatefulWidget {
  const JhCountDownBtn({
    super.key,
    this.getVCode,
    this.getCodeText = _normalText,
    this.resendAfterText = _resendAfterText,
    this.textColor,
    this.bgColor,
    this.fontSize = _fontSize,
    this.borderColor,
    this.borderRadius = _borderRadius,
    this.showBorder = false,
  });

  final Future<bool> Function()? getVCode;
  final String getCodeText;
  final String resendAfterText;
  final Color? textColor;
  final Color? bgColor;
  final double? fontSize;
  final Color? borderColor;
  final double? borderRadius;
  final bool showBorder;

  @override
  State<JhCountDownBtn> createState() => _JhCountDownBtnState();
}

class _JhCountDownBtnState extends State<JhCountDownBtn> {
  Timer? _countDownTimer;
  String _btnStr = _normalText;
  int _countDownNum = _normalTime;

  @override
  void initState() {
    super.initState();

    _btnStr = widget.getCodeText;
  }

  /// 释放掉Timer
  @override
  void dispose() {
    _countDownTimer?.cancel();
    _countDownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    var bgColor = Colors.transparent;
    var textColor = KColors.dynamicColor(
        context, Get.theme.colorScheme.primary, KColors.kThemeColor);
    var borderColor = KColors.dynamicColor(
        context, Get.theme.colorScheme.primary, KColors.kThemeColor);

    // 设置的颜色优先级高于暗黑模式
    bgColor = widget.bgColor ?? bgColor;
    textColor = widget.textColor ?? textColor;
    borderColor = widget.borderColor ?? borderColor;

    if (widget.getVCode == null) {
      return Container();
    }

    return TextButton(
      onPressed: () => _getVCode(),
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
        // 设置按钮大小
        fixedSize: WidgetStateProperty.all(const Size(120, 32)),
        minimumSize: WidgetStateProperty.all(const Size(120, 32)),
        // 背景色
        backgroundColor: WidgetStateProperty.all(bgColor),
        // 文字颜色
        foregroundColor: WidgetStateProperty.all(textColor),
        // 边框
        side: widget.showBorder == false
            ? null
            : WidgetStateProperty.all(
                BorderSide(color: borderColor, width: _borderWidth)),
        // 圆角
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!))),
      ),
      child: Text(_btnStr, style: TextStyle(fontSize: widget.fontSize)),
    );
  }

  Future _getVCode() async {
    if (widget.getVCode != null) {
      bool isSuccess = await widget.getVCode!();
      if (isSuccess) {
        startCountdown();
      }
    }
  }

  /// 开始倒计时
  void startCountdown() {
    if (_countDownTimer != null) {
      return;
    }

    setState(() {
      _countDownNum = _normalTime;
      _btnStr = '${widget.resendAfterText}(${_countDownNum}s)';
    });

    _countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDownNum > 0) {
          _countDownNum--;
          _btnStr = '${widget.resendAfterText}(${_countDownNum}s)';
        } else {
          _btnStr = widget.getCodeText;
          _countDownNum = _normalTime;
          _countDownTimer?.cancel();
          _countDownTimer = null;
        }
      });
    });
  }
}
