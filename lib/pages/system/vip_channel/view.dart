import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/base_appbar.dart';
import '../../../common/kcolors.dart';
import '../../../common/routers/names.dart';
import 'index.dart';
import 'widgets/vip_channel_cell.dart';

class VipChannelPage extends GetView<VipChannelController> {
  const VipChannelPage({super.key});

  // 主视图
  Widget _buildView() {
    return ListView.builder(
      itemCount: controller.plans.length,
      itemBuilder: (BuildContext context, int index) {
        return VipChannelCell(
          model: controller.plans[index],
          onTap: () {
            Get.toNamed(RouteNames.systemVipSubChannel,
                arguments: controller.plans[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VipChannelController>(
      init: VipChannelController(),
      id: "vip_channel",
      builder: (_) {
        return Scaffold(
          backgroundColor: KColors.MainColor,
          appBar: const BaseAppBar(
            '套餐',
            bgColor: Colors.transparent,
          ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
