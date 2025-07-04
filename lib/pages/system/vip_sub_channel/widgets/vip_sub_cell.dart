import 'package:flutter/material.dart';

import '../../../../common/box.dart';
import '../../../../common/kcolors.dart';
import '../../../../models/vip_price_model.dart';

class VipSubCell extends StatelessWidget {
  const VipSubCell({super.key, required this.data, this.onTap});
  final VipPriceModel data;
  final Function(VipPriceModel model)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(data) : null,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: data.ischoosed ? KColors.kThemeColor : KColors.MainColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Text(
              data.title ?? '',
              style: TextStyle(
                  fontSize: 14,
                  color: data.ischoosed ? Colors.white : Colors.black),
            ),
            vBox(5),
            Text(
              '￥${data.price}',
              style: TextStyle(
                  fontSize: 14,
                  color: data.ischoosed ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
