import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/box.dart';
import '../../../common/images.dart';
import '../../../common/kcolors.dart';
import '../../../common/routers/names.dart';
import 'index.dart';
import 'widgets/mine_card_cell.dart';
import 'widgets/mine_cell.dart';

class MinePage extends GetView<MineController> {
  const MinePage({super.key});

  // 主视图
  Widget _buildView() {
    return controller.userInfoMessageModel.data == null
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    MineCardCell(
                      model: controller.userInfoMessageModel,
                    ),
                    MineCell(
                      title: '我的钱包',
                      subTitle: controller.money,
                      icon: AssetsImages.walletPng,
                      onTap: () =>
                          Get.toNamed(RouteNames.systemUserWallet, arguments: {
                        'money':
                            (controller.userInfoMessageModel.data?.balance ??
                                    0) /
                                100.0,
                        'commission': (controller.userInfoMessageModel.data
                                    ?.commissionBalance
                                    .toDouble() ??
                                0) /
                            100.0
                      }),
                    ),
                    // MineCell(
                    //   title: '邀请中心',
                    //   subTitle: '分享给朋友赚取佣金',
                    //   icon: AssetsImages.vpn_yaoqingPng,
                    //   onTap: () {},
                    // ),
                    MineCell(
                      title: '在售套餐',
                      subTitle: '查看和订阅套餐',
                      icon: AssetsImages.vpn_taocanPng,
                      onTap: () {
                        controller.buyVip();
                      },
                    ),

                    MineCell(
                      title: '我的订单',
                      subTitle: '查看订单',
                      icon: AssetsImages.vpn_gongdanPng,
                      onTap: () => Get.toNamed(RouteNames.systemOrderList),
                    ),
                  ],
                ),
                vBox(50),
                //const Spacer(),
                GestureDetector(
                  onTap: () {
                    controller.logout();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(22)),
                    child: Text(
                      '退出登录',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineController>(
      init: MineController(),
      id: "mine",
      builder: (_) {
        return Scaffold(
          backgroundColor: KColors.MainColor,
          // appBar: BaseAppBar(
          //   '个人中心',
          //   bgColor: Colors.transparent,
          //   leftWidget: Container(),
          // ),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
