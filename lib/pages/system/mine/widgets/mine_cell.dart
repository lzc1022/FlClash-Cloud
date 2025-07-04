import 'package:flutter/material.dart';

import '../../../../common/box.dart';
import '../../../../common/ex_decoration.dart';
import '../../../../common/image_x.dart';
import '../../../../common/images.dart';
import '../../../../common/kcolors.dart';

class MineCell extends StatelessWidget {
  const MineCell(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.icon,
      this.onTap});
  final String title;
  final String subTitle;
  final String icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecorationExtension.allBorder(
            color: Colors.white, backgroundColor: Colors.white, radius: 20),
        child: Row(
          children: [
            ImageX.asset(
              icon,
              width: 30,
              height: 30,
            ),
            hBox(20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  vBox(5),
                  Text(
                    subTitle,
                    style: const TextStyle(
                        fontSize: 14, color: KColors.kFormHintColor),
                  ),
                ],
              ),
            ),
            const ImageX.asset(
              AssetsImages.rightPng,
              width: 12,
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}
