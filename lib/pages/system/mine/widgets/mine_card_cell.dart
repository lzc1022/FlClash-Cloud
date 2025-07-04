import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';

import '../../../../common/box.dart';
import '../../../../common/ex_decoration.dart';
import '../../../../models/user_infomessage_model.dart';

class MineCardCell extends StatelessWidget {
  final UserInfoMessageModel model;
  const MineCardCell({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecorationExtension.allBorder(
          color: Colors.white, backgroundColor: Colors.white, radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '用户名：${model.data?.email ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          vBox(5),
          Text(
            '账户余额：${(model.data?.balance ?? 0) / 100.0}元',
            style: const TextStyle(fontSize: 16),
          ),
          vBox(5),
          Text(
            // 使用三元运算符判断 expiredAt 是否为 null
            '到期时间：${model.data?.expiredAt != null ? DateUtil.formatDateMs(model.data!.expiredAt! * 1000, format: 'yyyy-MM-dd') : ''}',
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
