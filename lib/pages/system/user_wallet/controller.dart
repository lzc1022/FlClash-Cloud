import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../common/dio_http/toast_util.dart';
import '../../../common/my/base_controller.dart';
import '../../../common/services/event_bus/event_bus.dart';

class UserWalletController extends BaseGetController {
  UserWalletController();
  Map<String, dynamic> userWallet = Get.arguments ?? {};
  //余额
  double money = 0.0;
  //佣金
  double commission = 0.0;
  String payMoney = '';
  TextEditingController moneyController = TextEditingController();

  _initData() {
    money = userWallet['money'] ?? 0.0;
    commission = userWallet['commission'] ?? 0.0;
    update(["user_wallet"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  //提现
  void withdraw() {
    if (payMoney.isEmpty) {
      ToastUtils.toast('请输入划转金额');
      return;
    }
    if (double.parse(payMoney) > commission) {
      ToastUtils.toast('划转金额不能超过佣金余额');
      return;
    }

    request.requestCommissionTransfer(
      payMoney,
      success: (data) {
        if (data) {
          ToastUtils.toast('划转成功');
          commission = commission - double.parse(payMoney);
          money = money + double.parse(payMoney);
          sendEvent(UpdateSubscribeEvent('user_wallet'));
          update(["user_wallet"]);
        }
      },
      fail: (code, msg) {},
    );
  }

  @override
  void dispose() {
    moneyController.dispose();
    super.dispose();
  }
}
