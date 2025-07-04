import 'package:flutter/material.dart';

import '../../../../common/box.dart';
import '../../../../common/kcolors.dart';

class WalletCell extends StatelessWidget {
  const WalletCell({super.key, required this.money, required this.commission});
  final double money;
  final double commission;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: double.infinity,
        decoration: const BoxDecoration(
          // 添加圆角
          color: KColors.kThemeColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('账户余额',
                style: TextStyle(fontSize: 12, color: Colors.white)),
            vBox(10),
            Text('￥$money',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            vBox(10),
            const Text('佣金余额(可提现)',
                style: TextStyle(fontSize: 12, color: Colors.white)),
            vBox(10),
            Text('￥$commission',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ));
  }
}
