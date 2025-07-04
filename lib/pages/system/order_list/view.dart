import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/base_appbar.dart';
import '../../../common/kcolors.dart';
import 'index.dart';
import 'widgets/order_cell.dart';

class OrderListPage extends GetView<OrderListController> {
  const OrderListPage({super.key});

  // 主视图
  Widget _buildView() {
    return ListView.builder(
      itemCount: controller.datas.length,
      itemBuilder: (BuildContext context, int index) {
        return OrderCell(
          model: controller.datas[index],
          onCancel: (model) {
            controller.onCancel(model);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderListController>(
      init: OrderListController(),
      id: "order_list",
      builder: (_) {
        return Scaffold(
          backgroundColor: KColors.MainColor,
          appBar: const BaseAppBar(
            '我的订单',
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
