///  base_appbar.dart
///
///  description:  导航条基类
library;

import 'package:flutter/material.dart';

import 'colors.dart';
import 'images.dart';
import 'jh_status_bar_utils.dart';

const double _elevation = 0;
const double _titleFontSize = 18.0;
const double _textFontSize = 16.0;
const double _itemSpace = 15.0; // 右侧item内间距
const double _imgWH = 22.0; // 右侧图片宽高
const double _rightSpace = 5.0; // 右侧item右间距

// 默认颜色
const Color _bgColor = Colors.white;

const Color _titleColor = AppColors.kNavTitleColor;
// 状态栏字体颜色，当backgroundColor透明或者是白色，状态栏字体为黑色，暗黑模式为白色
const Brightness _brightness = Brightness.light;

const Color appbarStartColor = AppColors.kGradientStartColor; // 默认appBar 渐变开始色
const Color appbarEndColor = AppColors.kGradientEndColor; // 默认appBar 渐变结束色

/// 渐变导航条
class GradientAppBar extends StatefulWidget implements PreferredSizeWidget {
  const GradientAppBar(
    this.title, {
    super.key,
    this.rightText,
    this.rightImgPath,
    this.leftWidget,
    this.titleWidget,
    this.rightWidgets,
    this.brightness = _brightness,
    this.elevation = _elevation,
    this.bottomWidget,
    this.leftItemCallBack,
    this.rightItemCallBack,
  });

  final String title;
  final String? rightText;
  final String? rightImgPath;
  final Widget? leftWidget;
  final Widget? titleWidget;
  final List<Widget>? rightWidgets;
  final Brightness brightness;
  final double elevation;
  final PreferredSizeWidget? bottomWidget;
  final Function? leftItemCallBack;
  final Function? rightItemCallBack;

  @override
  State<GradientAppBar> createState() => _GradientAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottomWidget?.preferredSize.height ?? 0.0));
}

class _GradientAppBarState extends State<GradientAppBar> {
  @override
  Widget build(BuildContext context) {
    var flexibleSpace = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [appbarStartColor, appbarEndColor],
        ),
      ),
    );
    return BaseAppBar(
      widget.title,
      rightText: widget.rightText,
      rightImgPath: widget.rightImgPath,
      leftWidget: widget.leftWidget,
      titleWidget: widget.titleWidget,
      rightWidgets: widget.rightWidgets,
      bgColor: Colors.white.withAlpha(0),
      elevation: widget.elevation,
      bottomWidget: widget.bottomWidget,
      rightItemCallBack: widget.rightItemCallBack,
      leftItemCallBack: widget.leftItemCallBack,
      flexibleSpace: flexibleSpace,
    );
  }
}

/// 导航条基类
class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  const BaseAppBar(
    this.title, {
    super.key,
    this.rightText,
    this.leadingWidth = 56,
    this.rightImgPath,
    this.leftWidget,
    this.titleWidget,
    this.rightWidgets,
    this.bgColor = Colors.white,
    this.brightness = _brightness,
    this.elevation = _elevation,
    this.bottomWidget,
    this.flexibleSpace,
    this.leftItemCallBack,
    this.rightItemCallBack,
  });

  final String title; // 标题文字
  final String? rightText; // 右侧按钮文字
  final String? rightImgPath; // 右侧按钮图片路径，优先级高于rightText
  final Widget? leftWidget; // 左侧Widget，为空显示返回按钮
  final Widget? titleWidget; // 标题Widget，优先级高于title
  final List<Widget>? rightWidgets; // 优先级高于rightText和rightImgPath
  final Color? bgColor; // 背景颜色，默认主题色，设置的颜色优先级高于暗黑模式
  final Brightness brightness;
  final double elevation;
  final double leadingWidth;
  final PreferredSizeWidget? bottomWidget;
  final Widget? flexibleSpace;
  final Function? leftItemCallBack;
  final Function? rightItemCallBack;

  @override
  State<BaseAppBar> createState() => _BaseAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottomWidget?.preferredSize.height ?? 0.0));
}

class _BaseAppBarState extends State<BaseAppBar> {
  @override
  Widget build(BuildContext context) {
    return _appBar();
  }

  Widget _appBar() {
    // 默认颜色
    Color titleAndIconColor = _titleColor;
    Color bgColor = widget.bgColor ?? _bgColor;
    var brightness = widget.brightness;

    // 如果背景透明或者是白色，设置字体和图标、状态栏字体为黑色
    if (widget.bgColor == Colors.transparent ||
        widget.bgColor == Colors.white) {
      titleAndIconColor = Colors.black;
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }

    // 标题
    var titleWidget = widget.titleWidget ??
        Text(widget.title,
            style:
                TextStyle(fontSize: _titleFontSize, color: titleAndIconColor),
            maxLines: 2);

    // 左侧
    var backWidget = IconButton(
      icon: ImageIcon(const AssetImage(AssetsImages.icNavBackBlackPng),
          color: titleAndIconColor),
      iconSize: 18,
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      //去除水波纹效果
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: () {
        if (widget.leftItemCallBack == null) {
          _popThis(context);
        } else {
          widget.leftItemCallBack!();
        }
      },
    );
    var leftWidget = widget.leftWidget ?? backWidget;

    // 右侧
    Widget rightWidget = const Text('');
    if (widget.rightText != null) {
      rightWidget = InkWell(
        child: Container(
          margin: const EdgeInsets.all(_itemSpace),
          color: Colors.transparent,
          child: Center(
            child: Text(widget.rightText!,
                style: TextStyle(
                    fontSize: _textFontSize, color: titleAndIconColor)),
          ),
        ),
        onTap: () => widget.rightItemCallBack?.call(),
      );
    }
    if (widget.rightImgPath != null) {
      rightWidget = IconButton(
        icon: Image.asset(widget.rightImgPath!,
            width: _imgWH, height: _imgWH, color: titleAndIconColor),
        onPressed: () => widget.rightItemCallBack?.call(),
      );
    }
    var actions = [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[rightWidget, const SizedBox(width: _rightSpace)],
      ),
    ];
    var rightWidgets = widget.rightWidgets ?? actions;

    return AppBar(
      title: titleWidget,
      centerTitle: true,
      leadingWidth: widget.leadingWidth,
      backgroundColor: bgColor,
      scrolledUnderElevation: widget.elevation,
      systemOverlayStyle: JhStatusBarUtils.getStatusBarStyle(
          isDark: false, brightness: brightness),
      bottom: widget.bottomWidget,
      elevation: widget.elevation,
      leading: leftWidget,
      actions: rightWidgets,
      flexibleSpace: widget.flexibleSpace,
    );
  }
}

void _popThis(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }
}

// 多行标题
class TwoLinesTitle extends StatelessWidget {
  const TwoLinesTitle({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.color = Colors.white,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (subtitle.isEmpty) {
      widget =
          Text(title, style: TextStyle(fontSize: _titleFontSize, color: color));
    } else {
      widget = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: title,
          style: TextStyle(fontSize: 20, color: color),
          children: <TextSpan>[
            TextSpan(
                text: '\n$subtitle',
                style: TextStyle(color: color, fontSize: 14)),
          ],
        ),
      );
    }
    return widget;
  }
}
