///  colors.dart
///
///  Created by iotjin on 2020/07/06.
///  description:  颜色 配置
library;

// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// 暗黑模式判断
extension ThemeExtension on BuildContext {
  bool get jhIsDark => Theme.of(this).brightness == Brightness.dark;
}

class KColors {
  /// 设置动态颜色
  static Color dynamicColor(BuildContext context, Color lightColor,
      [Color? darkColor]) {
    var isDark = context.jhIsDark;
    return isDark ? darkColor ?? lightColor : lightColor;
  }

  // 主题色（导航条背景、提交按钮背景、弹框确认文字、表单图标录入光标）
  // 暗黑模式高亮显示颜色按kThemeColor设置，如tabBar选中文字图标、提交按钮背景色、指示器选中下划线、光标等
  static const Color kThemeColor = Color(0xFF3BB815);
  static const Color kThemeDarkColor = Color(0xFF0A0A0A); // (10, 10, 10)

  // 渐变色（appBar和按钮）
  static const Color kGradientStartColor = Color(0xFF2683BE); // 渐变开始色
  static const Color kGradientEndColor = Color(0xFF34CABE); // 渐变结束色

  // 导航条背景色（主题色背景白色文字，透明背景为黑色文字，暗黑模式是白色文字）
  static const Color kNavThemeBgColor = kThemeColor;

  static const Color kMaterialBgColor = Color(0xFFFFFFFF); // (255, 255, 255)

  // 黑色文字
  static const Color kBlackTextColor = Color(0xFF333333); // (51, 51, 51)
  // 灰色文字
  static const Color kGreyTextColor = Color(0xFF777777); // (119, 119, 119)
  // 浅灰色文字
  static const Color kLightGreyTextColor = Color(0xFF999999); // (153, 153, 153)
  // 表单hint文字
  static const Color kFormHintColor = Color(0xFFBBBBBB); // (187, 187, 187)
  // 分割线
  static const Color kLineColor = Color(0xFFE6E6E6); // (230, 230, 230)
  static const Color MainColor = Color(0xFFFEF8F7);
}
