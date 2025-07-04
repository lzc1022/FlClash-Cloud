import 'package:flutter/material.dart';

import '../../../../common/box.dart';
import '../../../../common/kcolors.dart';
import '../../../../models/plan_model.dart';

class VipChannelCell extends StatelessWidget {
  const VipChannelCell({super.key, required this.model, this.onTap});
  final Plan model;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  model.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // 价格

                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '¥',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${_findCheapestPrice(model)?.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red, // 红色字体
                        ),
                      ),
                      TextSpan(
                        text: _formatPrice(model),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // 红色字体
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            vBox(8),
            _buildUniformStyledContent(model.content ?? ''),
            vBox(15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: KColors.kThemeColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                '订阅',
                style: TextStyle(color: Colors.white),
              ),
            ),
            vBox(10),
          ],
        ),
      ),
    );
  }

  double? _findCheapestPrice(Plan plan) {
    final prices = [
      plan.monthPrice,
      plan.quarterPrice,
      plan.halfYearPrice,
      plan.yearPrice,
      plan.twoYearPrice,
      plan.threeYearPrice,
      plan.onetimePrice
    ].where((price) => price != null).toList();

    if (prices.isNotEmpty) {
      return prices.reduce((a, b) => a! < b! ? a : b);
    }
    return null;
  }

  String _formatPrice(Plan model) {
    if (model.monthPrice != null) {
      return '/月';
    } else if (model.quarterPrice != null) {
      return '/季';
    } else if (model.halfYearPrice != null) {
      return '/半年';
    } else if (model.yearPrice != null) {
      return '/年';
    } else if (model.twoYearPrice != null) {
      return '/两年';
    } else if (model.threeYearPrice != null) {
      return '/三年';
    } else if (model.onetimePrice != null) {
      return '/一次性';
    }

    return '';
  }

  Widget _buildUniformStyledContent(String content) {
    final lines = content.split('\n').where((line) => line.trim().isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  line.trim(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
