
import 'package:flutter/material.dart';

import '../../../../common/box.dart';
import '../../../../common/image_x.dart';
import '../../../../common/images.dart';
import '../../../../models/pay_type_model.dart';


class PayTypeCell extends StatelessWidget {
  const PayTypeCell({super.key, required this.model, this.onTap});
  final PayTypeModel model;
  final Function(PayTypeModel model)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(model),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(children: [
          ImageX.url(
            model.icon ?? '',
            width: 25,
            height: 25,
          ),
          hBox(10),
          Text(model.name ?? ''),
          const Spacer(),
          model.isChoosed
              ? const ImageX.asset(
                  AssetsImages.vpnSelcedlPng,
                  width: 14,
                  height: 14,
                )
              : const ImageX.asset(
                  AssetsImages.vpnNormalPng,
                  width: 14,
                  height: 14,
                )
        ]),
      ),
    );
  }
}
