import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../../common/box.dart';
import '../../../common/dio_http/toast_util.dart';
import '../../../common/ex_decoration.dart';
import '../../../common/jh_screen_utils.dart';
import '../../../common/my/base_controller.dart';
import '../../../models/order_model.dart';

class OrderListController extends BaseGetController {
  OrderListController();
  List<Order> datas = [];

  _initData() {
    ToastUtils.show();
    request.requestOrderList(
      success: (data) {
        datas = data;
        update(["order_list"]);
        ToastUtils.dismiss();
      },
      fail: (code, msg) {
        ToastUtils.dismiss();
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // 取消订单
  onCancel(Order model) {
    SmartDialog.show(
        alignment: Alignment.bottomCenter,
        builder: (_) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: JhScreenUtils.bottomSafeHeight + 20),
            decoration: BoxDecorationExtension.circularBorderTop(
                radius: 10, backgroundColor: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                vBox(10),
                const Text(
                  '是否取消订单?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                vBox(20),
                GestureDetector(
                  onTap: () {
                    SmartDialog.dismiss();
                    if (model.status == 0) {
                      request.requestOrderCancel(
                        model.tradeNo ?? '',
                        success: (data) {
                          if (data) {
                            model.status = 2;
                            ToastUtils.toast('取消成功');
                            update(["order_list"]);
                          }
                        },
                        fail: (code, msg) {},
                      );
                    }
                  },
                  child: const SizedBox(
                    width: 250,
                    child: Text(
                      '确定',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                vBox(20),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    SmartDialog.dismiss();
                  },
                  child: const SizedBox(
                    width: 250,
                    child: Text(
                      textAlign: TextAlign.center,
                      '取消',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
