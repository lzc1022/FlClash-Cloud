import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/base_appbar.dart';
import '../../../common/kcolors.dart';
import 'index.dart';
import 'widgets/notice_item.dart';

class NoticePage extends GetView<NoticeController> {
  const NoticePage({super.key});

  // 主视图
  Widget _buildView() {
    return ListView.builder(
      itemCount: controller.noticeList.length,
      itemBuilder: (BuildContext context, int index) {
        return NoticeItem(model: controller.noticeList[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoticeController>(
      init: NoticeController(),
      id: "notice",
      builder: (_) {
        return Scaffold(
          backgroundColor: KColors.MainColor,
          appBar: const BaseAppBar('系统通知', bgColor: Colors.transparent),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
