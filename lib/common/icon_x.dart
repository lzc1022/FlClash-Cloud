import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum IconXType { icon, svg, image, url }

/// 图标组件
class IconX extends StatelessWidget {
  /// 图标类型
  final IconXType type;

  /// 图标数据
  final IconData? iconData;

  /// assets 路径
  final String? assetName;

  /// 图片 url
  final String? imageUrl;

  /// 尺寸
  final double? size;

  /// 宽
  final double? width;

  /// 高
  final double? height;

  /// 颜色
  final Color? color;

  /// 是否小圆点
  final bool? isDot;

  /// Badge 文字
  final String? badgeString;

  /// 图片 fit
  final BoxFit? fit;

  const IconX({
    super.key,
    this.type = IconXType.icon,
    this.size,
    this.width,
    this.height,
    this.color,
    this.iconData,
    this.isDot,
    this.badgeString,
    this.assetName,
    this.imageUrl,
    this.fit,
  });

  IconX.icon(
    this.iconData, {
    super.key,
    this.type = IconXType.icon,
    this.size = 24,
    this.width,
    this.height,
    this.color,
    this.isDot,
    this.badgeString,
    this.assetName,
    this.imageUrl,
    this.fit,
  }) {
    return;
  }

  IconX.image(
    this.assetName, {
    super.key,
    this.type = IconXType.image,
    this.size = 24,
    this.width,
    this.height,
    this.color,
    this.iconData,
    this.isDot,
    this.badgeString,
    this.imageUrl,
    this.fit,
  }) {
    return;
  }

  IconX.svg(
    this.assetName, {
    super.key,
    this.type = IconXType.svg,
    this.size = 24,
    this.width,
    this.height,
    this.color,
    this.iconData,
    this.isDot,
    this.badgeString,
    this.imageUrl,
    this.fit,
  }) {
    return;
  }

  IconX.url(
    this.imageUrl, {
    super.key,
    this.type = IconXType.url,
    this.size = 24,
    this.width,
    this.height,
    this.color,
    this.iconData,
    this.isDot,
    this.badgeString,
    this.assetName,
    this.fit,
  }) {
    return;
  }

  @override
  Widget build(BuildContext context) {
    Widget? icon;
    switch (type) {
      case IconXType.icon:
        icon = Icon(
          iconData,
          size: size,
          color: color ?? Colors.black,
        );
        break;
      case IconXType.svg:
        icon = SvgPicture.asset(
          assetName!,
          width: width ?? size,
          height: height ?? size,
          fit: fit ?? BoxFit.contain,
        );
        break;
      case IconXType.image:
        icon = Image.asset(
          assetName!,
          width: width ?? size,
          height: height ?? size,
          color: color,
          fit: fit ?? BoxFit.contain,
        );
        break;
      case IconXType.url:
        icon = Image.network(
          imageUrl!,
          width: width ?? size,
          height: height ?? size,
          color: color,
          fit: fit ?? BoxFit.contain,
        );
        break;
    }

    // 文字、数字

    // 图标
    return icon;
  }
}
