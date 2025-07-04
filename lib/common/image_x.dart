import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'icon_x.dart';

enum ImageXType { asset, network, file }

/// 图片组件
class ImageX extends StatelessWidget {
  /// 网址
  final String url;

  /// 类型
  final ImageXType type;

  /// 圆角
  final double? radius;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 自适应方式
  final BoxFit? fit;

  /// 占位图
  final Widget? placeholder;

  /// 背景颜色
  final Color? backgroundColor;

  /// builder 函数
  final Widget Function(
    BuildContext context,
    ImageProvider provider,
    Widget completed,
    Size? size,
  )? builder;

  const ImageX({
    super.key,
    required this.type,
    required this.url,
    this.radius,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.backgroundColor,
    this.builder,
  });

  const ImageX.url(
    this.url, {
    super.key,
    this.radius,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.backgroundColor,
    this.builder,
  }) : type = ImageXType.network;

  const ImageX.asset(
    this.url, {
    super.key,
    this.radius,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.backgroundColor,
    this.builder,
  }) : type = ImageXType.asset;

  const ImageX.file(
    this.url, {
    super.key,
    this.radius,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.backgroundColor,
    this.builder,
  }) : type = ImageXType.file;

  /// 占位图
  Widget get _placeholder =>
      placeholder ??
      IconX.image(
        'assets/images/default.png',
        size: 36,
      );

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(
      Radius.circular(radius ?? 0),
    );
    Widget? image;
    switch (type) {
      case ImageXType.asset:
        image = ExtendedImage.asset(
          url,
          width: width,
          height: height,
          fit: fit,
          gaplessPlayback: true,
          shape: BoxShape.rectangle,
          borderRadius: borderRadius,
          loadStateChanged: (state) => _buildLoadState(context, state),
        );
        break;
      case ImageXType.network:
        if (!url.contains('http')) break;
        image = ExtendedImage.network(
          url,
          width: width,
          height: height,
          fit: fit,
          shape: BoxShape.rectangle,
          borderRadius: borderRadius,
          loadStateChanged: (state) => _buildLoadState(context, state),
        );
        break;
      case ImageXType.file:
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: image ?? _placeholder,
    );
  }

  Widget _buildLoadState(BuildContext context, ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      // 正在读取
      case LoadState.loading:
        return _placeholder;
      // 读取成功
      case LoadState.completed:
        Size? size;
        if (state.extendedImageInfo != null) {
          size = Size(
            state.extendedImageInfo!.image.width.toDouble(),
            state.extendedImageInfo!.image.height.toDouble(),
          );
        }
        final provider = state.imageProvider;
        final completed = state.completedWidget;
        return builder?.call(context, provider, completed, size) ?? completed;
      // 读取失败
      case LoadState.failed:
        return const Center(
          child: Icon(
            CupertinoIcons.info_circle,
            size: 20,
            color: Colors.grey,
          ),
        );
    }
  }
}
