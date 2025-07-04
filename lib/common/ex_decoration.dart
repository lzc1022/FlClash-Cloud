import 'package:flutter/material.dart';

///
/**
 * 使用：Container(
            height: 300,
            decoration: BoxDecorationExtension.allBorder(),
          ),
 */
///
class BoxDecorationExtension extends BoxDecoration {
  /// 添加默认边框线条
  BoxDecorationExtension.allBorder({
    Color? color,
    double width = 0.5,
    double radius = 0,
    Color backgroundColor = Colors.transparent,
    BoxShadow? shadow,
  }) : super(
            color: backgroundColor,
            borderRadius:
                (radius > 0 ? BorderRadius.all(Radius.circular(radius)) : null),
            border: Border.all(
                color: color ?? Colors.red,
                width: width,
                style: BorderStyle.solid),
            boxShadow: shadow == null ? null : [shadow]);

  /// 添加默认顶部线条
  BoxDecorationExtension.topBorder({
    Color? color,
    double width = 0.5,
    Color? backgroundColor = Colors.white,
  }) : super(
            color: backgroundColor,
            border: Border(
              top: BorderSide(
                color: color ?? Colors.red,
                width: width,
                style: BorderStyle.solid,
              ),
            ));

  /// 添加默认底部线条
  BoxDecorationExtension.bottomBorder({
    Color? color,
    double width = 0.5,
    Color? backgroundColor = Colors.white,
  }) : super(
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(
                color: color ?? Colors.red,
                width: width,
                style: BorderStyle.solid,
              ),
            ));

  /// 添加默认左边线条
  BoxDecorationExtension.leftBorder({
    Color? color,
    double width = 0.5,
    Color? backgroundColor = Colors.white,
  }) : super(
            color: backgroundColor,
            border: Border(
              left: BorderSide(
                color: color ?? Colors.red,
                width: width,
                style: BorderStyle.solid,
              ),
            ));

  /// 添加默认右边线条
  BoxDecorationExtension.rightBorder({
    Color? color,
    double width = 0.5,
    Color? backgroundColor = Colors.white,
  }) : super(
            color: backgroundColor,
            border: Border(
              right: BorderSide(
                color: color ?? Colors.red,
                width: width,
                style: BorderStyle.solid,
              ),
            ));

  /// 添加默认水平方向线条
  BoxDecorationExtension.horizontalBorder({
    Color? color,
    double width = 0.5,
    Color? backgroundColor = Colors.white,
  }) : super(
          color: backgroundColor,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: color ?? Colors.red,
              width: width,
              style: BorderStyle.solid,
            ),
          ),
        );

  /// 添加圆角
  BoxDecorationExtension.circularBorder({
    required double radius,
    Color backgroundColor = Colors.white,
  }) : super(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(radius)));

  /// 添加leftTop、rightTop圆角
  BoxDecorationExtension.circularBorderTop({
    required double radius,
    Color backgroundColor = Colors.white,
  }) : super(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(radius)));

  /// 添加leftBottom、rightBottom圆角
  BoxDecorationExtension.circularBorderBottom({
    required double radius,
    Color backgroundColor = Colors.white,
  }) : super(
            color: backgroundColor,
            borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(radius)));
}

class DividerStyle {
  ///分割线 0.5 - 20边距
  static Widget divider1HalfPadding20 = const Divider(
    height: 0.5, //  设置高度为0.5，通常用于控制某些组件的高度，例如分割线的高度
    thickness: 0.5, //  设置厚度为0.5，通常用于控制某些组件的厚度，例如边框的厚度
    indent: 20, //  设置缩进为20，通常用于控制组件的起始位置，例如文本的起始位置
    endIndent: 20, //  设置结束缩进为20，通常用于控制组件的结束位置，例如文本的结束位置
    color: Color.from(
        alpha: 0.4,
        red: 0.878,
        green: 0.902,
        blue: 0.992), //  设置颜色为AppColors.colorShadow，通常用于指定组件的颜色，例如背景色或边框色
  );

  ///分割线 0.5 - 无边距
  static Widget divider1Half = const Divider(
      height: 0.5,
      thickness: 0.5,
      color: Color.from(alpha: 0.4, red: 0.878, green: 0.902, blue: 0.992));
}
