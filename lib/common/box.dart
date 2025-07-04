import 'package:flutter/cupertino.dart';

/// 创建一个水平间距盒子
/// [width] 水平宽度
SizedBox hBox(double width) => SizedBox(width: width);

/// 创建一个垂直间距盒子
/// [height] 垂直高度
SizedBox vBox(double height) => SizedBox(height: height);

/// 创建一个可滚动视图中的垂直间距盒子
/// [height] 垂直高度
SliverToBoxAdapter sliverVBox(double height) => SliverToBoxAdapter(
      child: vBox(height),
    );

/// 创建一个可滚动视图中的水平间距盒子
/// [width] 水平宽度
SliverToBoxAdapter sliverHBox(double width) => SliverToBoxAdapter(
      child: hBox(width),
    );
