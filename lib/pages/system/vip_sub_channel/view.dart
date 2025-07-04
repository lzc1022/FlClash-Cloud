import 'package:fl_clash/common/jh_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/base_appbar.dart';
import '../../../common/box.dart';
import '../../../common/kcolors.dart';
import 'index.dart';
import 'widgets/vip_sub_cell.dart';

class VipSubChannelPage extends GetView<VipSubChannelController> {
  const VipSubChannelPage({super.key});

  // 主视图
  Widget _buildView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            itemCount: controller.datas.length,
            itemBuilder: (BuildContext context, int index) {
              return VipSubCell(
                data: controller.datas[index],
                onTap: (model) {
                  controller.onTap(model);
                },
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vBox(5),
              Text(
                '原价:￥${controller.choosedModel.price}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              vBox(10),
              Column(children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('优惠券折扣:'),
                    Text(
                      '-￥0.00',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                vBox(5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('手续费(0.0%):'),
                    Text(
                      '+￥0.00',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                vBox(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('费用后金额:'),
                    Text(
                      '￥${controller.choosedModel.price}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    )
                  ],
                ),
                vBox(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('余额使用:'),
                    Text(
                      '-￥${controller.userInfoMessageModel.data != null && controller.userInfoMessageModel.data!.balance / 100.0 >= controller.choosedModel.price!.jhToNum ? (controller.choosedModel.price) : '${(controller.userInfoMessageModel.data?.balance ?? 0) / 100.0}'}',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
              ]),
              vBox(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('套餐价格'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '￥${controller.realPayMoney}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: KColors.kThemeColor),
                      ),
                      vBox(5),
                      Text(
                        '剩余余额:￥${controller.userInfoMessageModel.data != null && controller.userInfoMessageModel.data!.balance / 100.0 >= controller.choosedModel.price.jhToNum ? (controller.userInfoMessageModel.data!.balance / 100 - controller.choosedModel.price.jhToNum).toStringAsFixed(2) : '0.0'}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  )
                ],
              ),
              vBox(5),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            controller.buy();
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            height: 50,
            decoration: BoxDecoration(
              color: KColors.kThemeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              '订阅',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VipSubChannelController>(
      init: VipSubChannelController(),
      id: "vip_sub_channel",
      builder: (_) {
        return Scaffold(
          backgroundColor: KColors.MainColor,
          appBar: BaseAppBar(
            controller.model.name,
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
