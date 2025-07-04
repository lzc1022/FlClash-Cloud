import 'dart:math';

import 'package:flutter/material.dart';

/// 应用颜色
class AppColors {
  /// 十六进制颜色设置
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  /// AppColors.hexAColor(0x3caafa); | AppColors.hexAColor(0x3caafa,alpha: 0.5);
  static Color hexAColor(int hex, {double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0, alpha);
  }

  /// hex颜色设置
  static Color hexColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// 创建Material风格的color
  static MaterialColor materialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.r.toInt(), g = color.g.toInt(), b = color.b.toInt();

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    // ignore: deprecated_member_use
    return MaterialColor(color.value, swatch as Map<int, Color>);
  }

  /// 取随机颜色
  static Color randomColor() {
    var red = Random.secure().nextInt(255);
    var greed = Random.secure().nextInt(255);
    var blue = Random.secure().nextInt(255);
    return Color.fromARGB(255, red, greed, blue);
  }

  /// 设置动态颜色
  static Color dynamicColor(BuildContext context, Color lightColor,
      [Color? darkColor]) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkColor ?? lightColor : lightColor;
  }

  // 主题色（导航条背景、提交按钮背景、弹框确认文字、表单图标录入光标）
  static const Color kThemeColor = Color(0xFF3BB815);
  // 渐变色（appBar和按钮）
  static const Color kGradientStartColor = Color(0xFF2683BE); // 渐变开始色
  static const Color kGradientEndColor = Color(0xFF34CABE); // 渐变结束色

  // 导航条背景色（白色背景色黑色文字，透明背景为黑色文字，暗黑模式是白色文字）
  static const Color kNavTitleColor = Colors.white;

  // 黑色文字
  static const Color kBlackTextColor = Color(0xFF333333); // (51, 51, 51)
}
