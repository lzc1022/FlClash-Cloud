import 'package:flutter/material.dart';

import '../../../../common/box.dart';
import '../../../../common/jh_time_utils.dart';
import '../../../../models/order_model.dart';

class OrderCell extends StatelessWidget {
  const OrderCell({super.key, required this.model, this.onTap, this.onCancel});
  final Order model;
  final Function(Order model)? onTap;
  final Function(Order model)? onCancel;

  @override
  Widget build(BuildContext context) {
    final amount = (model.totalAmount ?? 0) / 100.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('套餐名称：${model.orderPlan?.name ?? ''}'),
          vBox(10),
          Text('订单号: ${model.tradeNo ?? ''}'),
          vBox(10),
          Text('创建时间: ${JhTimeUtils.formatFullDateTime(model.createdAt!)}'),
          vBox(10),
          Text('支付金额: ${amount.toStringAsFixed(2)}'),
          vBox(10),
          Text.rich(TextSpan(children: [
            const TextSpan(
                text: '订单状态：', style: TextStyle(color: Colors.black)),
            TextSpan(
                text: getOrderStatusText(model.status ?? 0),
                style: const TextStyle(color: Colors.red)),
          ])),
          vBox(10),
          Text('产品流量: ${model.orderPlan?.transferEnable}G'),
          vBox(10),
          _buildView()
        ],
      ),
    );
  }

  String getOrderStatusText(int status) {
    switch (status) {
      case 0:
        return '待支付';
      case 1:
        return '开通中';
      case 2:
        return '已取消';
      case 3:
        return '已完成';
      case 4:
        return '已折扣';

      default:
        return '';
    }
  }

  Widget _buildView() {
    if (model.status == 0) {
      return Row(
        children: [
          const Spacer(),
          GestureDetector(
            onTap: () {
              onCancel?.call(model);
            },
            child: Container(
              width: 100,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '取消订单',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
